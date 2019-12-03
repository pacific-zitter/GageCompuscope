using TimerOutputs


@kwdef mutable struct Acquire
    gagecard::GageCard
    isAcquiring = Channel(1)
    acqReady = Channel(1)
    transferDone = Channel(1)
    endAcq::Base.RefValue{Ptr{Cvoid}}
    data::Channel{NTuple{2,Array{Int16,2}}}

    Acquire(G::GageCard, nAcq) = new(
    G,
    Channel(1),
    Channel(1),
    Channel(1),
    getGageEvent(G, ACQ_EVENT_END_BUSY),
    Channel{NTuple{2,Array{Int16,2}}}(nAcq),
    )
end


const to = TimerOutput()
timeit_debug_enabled() = false

function untilReady(G::GageCard;to=1.0,interval=10e-6)
    cb() = ccall((:CsGetStatus,csssm),Cint,(Cuint,),G.gagehandle) == 0
    while true
        cb() && break
        hybrid_sleep(10e-6)
        yield()
    end
end

function transfer_thread(A::Acquire)
    CData = MultipleRecord(A.gagecard,1)
    CData2 = MultipleRecord(A.gagecard,2)
     while true
        @timeit_debug to "transfer loop" begin
            take!(A.acqReady)
            take!(A.isAcquiring)
            @timeit_debug to "ch1. transfer" CData()
            @timeit_debug to "ch2. transfer." CData2()
            put!(A.transferDone,:ok)
            put!(A.data, (copy(CData.data_array),copy(CData2.data_array)))
        end
    end
end

function trigger_thread(A::Acquire;timeout=1.0,interval=10e-3)
    acqCount = Ref(0)
    while true
        cb() = get_status(A.gagecard) < 1
        @timeit_debug to "trigger loop" begin
            acqCount[] > A.data.sz_max && break
            put!(A.isAcquiring,:ok)
            start(A.gagecard)
            # @timeit_debug to "wait ready." timedwait(cb,timeout;pollint=interval)
            @timeit_debug to "wait_custom" untilReady(A.gagecard; interval=1e-6)
            put!(A.acqReady,:ok)
            take!(A.transferDone)
            acqCount[] += 1
        end

    end
    close.([A.data,A.isAcquiring])
end
