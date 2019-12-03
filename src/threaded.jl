mutable struct Acquire
    gagecard::GageCard
    isAcquiring::Channel
    acqReady::Channel
    transferDone::Channel
    aborted::Channel
    endAcq::Base.RefValue{Ptr{Cvoid}} # wrapper around win32 event.
    data::Channel{NTuple{2,Array{Int16,2}}}

    Acquire(G::GageCard, nAcq) = new(
    G,
    Channel(1),
    Channel(1),
    Channel(1),
    Channel(1),
    getGageEvent(G, ACQ_EVENT_END_BUSY),
    Channel{NTuple{2,Array{Int16,2}}}(nAcq),
    )
end

function untilReady(G::GageCard; to = 1.0, interval = 10e-6)
    cb() = ccall((:CsGetStatus, csssm), Cint, (Cuint,), G.gagehandle) == 0
    while true
        cb() && break
        yield()
        hybrid_sleep(10e-6)
    end
end

function transfer_thread(A::Acquire)
    CData = MultipleRecord(A.gagecard, 1)
    CData2 = MultipleRecord(A.gagecard, 2)
    while true
        take!(A.acqReady)
        take!(A.isAcquiring)
        CData()
        CData2()
        put!(A.transferDone, :ok)
        put!(A.data, (copy(CData.data_array), copy(CData2.data_array)))
    end
end

function trigger_thread(A::Acquire; timeout = 1.0, interval = 1e-6)
    acqCount = Ref(0)
    cb() = get_status(A.gagecard) < 1
    while true

        acqCount[] > A.data.sz_max && break
        put!(A.isAcquiring, :ok)
        start(A.gagecard)
        untilReady(A.gagecard; interval = interval)
        put!(A.acqReady, :ok)
        take!(A.transferDone)
        acqCount[] += 1
    end
end

function save_data(A::Acquire)
    # mkdir(joinpath(homedir(),".gingerlab"))
    filename = "gl_"*splitdir(tempname())[end]*".jld2"
    sav_count = Ref(0)
    jldopen(joinpath(homedir(),".gingerlab",filename),"w+") do jf
        while true
            d = take!(A.data)
            lname = "line"*lpad(sav_count[],4,'0')
            jf[lname] = d
            sav_count[]+=1
        end
    end
end
