using GageCompuscope

function getData(g::GageCard)
    inputd = IN_PARAMS_TRANSFERDATA(
        zeros(fieldcount(IN_PARAMS_TRANSFERDATA) - 2)...,
        C_NULL,
        C_NULL,
    )
    inputd.Channel = 1
    inputd.Length = g.acquisition_config.SegmentSize
    inputd.StartAddress = g.acquisition_config.SampleOffset
    inputd.Segment = 1
    output = OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
    evnt = Ref[C_NULL]
    inputd.hNotifyEvent = evnt[1]
    c1 = Array{Int16,2}(undef, inputd.Length, 1)
    inputd.pDataBuffer = pointer(c1, 1)

    ccall(
        (:CsDrvTransferData, :CsDisp),
        Int32,
        (UInt32, Ptr{IN_PARAMS_TRANSFERDATA}, Ptr{OUT_PARAMS_TRANSFERDATA}),
        g.gagehandle,
        inputd,
        output,
    )
    c1
end

tokens = Channel(16)
xfers = Channel(16)

function datacomplete(g::GageCard)
    !(get_status(g) > 0)
end

function acquireData(g::GageCard)
    @show "acquire"
    start(g)
    timedwait(() -> datacomplete(g), 10.0)
    put!(tokens, rand(1:10))
end

function transferData(g::GageCard)
    while true
        tok = take!(tokens)
        @show "Xferdata $tok"
        y = getData(g)
        put!(xfers, y)
    end
end

gage = GageCard(true)
set_samplerate(gage, 1e7)

begin
    acq = gage.acquisition_config
    acq.SegmentSize = 8192
    acq.Depth = 4192
    CsSet(gage.gagehandle,CS_ACQUISITION,gage.acquisition_config)
    commit(gage)
end


set_segmentcount(gage, 200)

for i = 1:4
    @async transferData(gage)
end

function take_image()
    for i = 1:16
        acquireData(gage)
    end
    close(xfers)
end

take_image()

dd = [i for i in xfers]
