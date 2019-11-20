using GageCompuscope
using JLD2, FileIO
using TimerOutputs

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


function dox(gage, data)
  for i = 1:100
    @info i
    @timeit to "start" start(gage)
    @timeit to "wait for ready" begin
      @timeit to "wait" timedwait(done_busy, 1.0, pollint = 1e-6)
    end
    @timeit to "transfer" begin
       CsTransfer(data, gage)
    end
    lnum = lpad(string(i), 4, "0")
  end
end

dox(gage, data)
axes(q,1).-1
print_timer(to)
q = data.data_array
q .= [q[:,i] .- q[:,i+1] for i in size(q,2)-1]
q
free_system(gage)
