using GageCompuscope
using TimerOutputs
gage= GageCard()

begin # settings.
    A = gage.acquisition_config
    channel1 = gage.channel_config[1]
    channel2 = gage.channel_config[2]
    A["SampleRate"] = 2e8
    A["SegmentSize"] = A["Depth"] = 81920
    A["SegmentCount"] = 1
    A["Mode"] = CS_MODE_DUAL

    channel1.InputRange = channel2.InputRange = CS_GAIN_2_V
    channel2.Filter = channel1.Filter = CS_FILTER_OFF
    channel1.Term = channel2.Term = CS_COUPLING_DC
    #send values to driver and commit.
    CsSet(gage)
    commit(gage)
end

function untilReady(G::GageCard;to=1.0,interval=10e-6)
    cb() = ccall((:CsGetStatus,csssm),Cint,(Cuint,),G.gagehandle) == 0
    while true
        cb() && break
        hybrid_sleep(10e-6)
        yield()
    end
end

const acqMax = 1024
const to = TimerOutput()
timeit_debug_enabled() = false

begin # acquire sychronization objects
    isAcquiring = Channel(1)
    acqReady = Channel(1)
    transferDone = Channel(1)
    endAcq = getGageEvent(gage,ACQ_EVENT_END_BUSY)
    data = Channel{Array{Int16,2}}(acqMax)
end

begin # threaded functions.
    function transfer_thread(G::GageCard)
        CData = MultipleRecord(G)
         while true
            @timeit_debug to "transfer loop" begin
                take!(isAcquiring)
                take!(acqReady)
                @timeit_debug to "mult rec. xfer" CData(1)
                put!(transferDone,:ok)
                put!(data, copy(CData.data_array))
            end
        end
    end

    function trigger_thread(G::GageCard;timeout=1.0,interval=10e-3)
        acqCount = Ref(0)
        while true
            cb() = get_status(G) < 1
            @timeit_debug to "trigger loop" begin
                acqCount[] > acqMax && break
                put!(isAcquiring,:ok)
                start(G)
                # @timeit_debug to "wait ready." timedwait(cb,timeout;pollint=interval)
                @timeit_debug to "wait_custom" untilReady(G; interval=1e-6)
                put!(acqReady,:ok)
                take!(transferDone)
                acqCount[] += 1
            end

        end
        close.([data,isAcquiring])
    end
end
for _ in 1:4
    x1 = Threads.@spawn transfer_thread(gage)
end

y1 = @elapsed @sync begin
    x2 = @async trigger_thread(gage)
end


close(isAcquiring)
close(data)
close(transferDone)
close(acqReady)

print_timer(to)

y = collect(data)
h = reshape(vcat(vec(y)...),:,16)
