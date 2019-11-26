using GageCompuscope
  using JLD2, FileIO
  using TimerOutputs
begin
  const to = TimerOutput()
  gage = GageCard(true)

  gage.acquisition_config.Mode = CS_MODE_SINGLE
  CsSet(gage.gagehandle, CS_ACQUISITION, gage.acquisition_config)
  commit(gage)

  set_samplerate(gage, 10e7)
  set_segmentsize(gage, 1e4)
  set_segmentcount(gage, 100)
  set_trigger!(gage, 1, 5)
  for i = 2:length(gage.trigger_config)
    set_trigger!(gage, i, 0, "off")
  end

  data = MultipleRecord(gage)
  const TIMEOUT = 10.0

  start(gage)
  get_status(gage)

  fpath = ENV["USERPROFILE"]
  Base.unsafe_convert(::Type{Ptr{G}}, x::G) where {G<:GageConfig} =
    Base.unsafe_convert(Ptr{G}, Ref(x))
  done_busy() = get_status(gage) == 0

  start(gage)
  done_busy()
  @timeit to "xfer" CsTransfer(data, gage)
end
Q=Base.AsyncCondition()

Base.CFunction()
CsGetEventHandle(gage.gagehandle, ACQ_EVENT_END_BUSY, Q )
start(gage)
Q
@timeit to "xfer" CsTransferAS(gage.gagehandle,data.input_gage,data.output_gage,Ref(UInt32(0)))

function dox(gage, data)
  for i = 1:100
    @info i
    @timeit to "start" start(gage)
    @timeit to "wait for ready" begin
      @timeit to "wait" timedwait(done_busy, 1.0, pollint = 1e-3)
    end
    @timeit to "transfer" begin
       CsTransfer(data, gage)
    end
    lnum = lpad(string(i), 4, "0")
  end
end

dox(gage, data)

free_system(gage)
