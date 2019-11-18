using GageCompuscope
using BenchmarkTools

function Base.cconvert(::Type{Ptr{IN_PARAMS_TRANSFERDATA}}, x::IN_PARAMS_TRANSFERDATA)
    Ref(x)
end

function Base.cconvert(::Type{Ptr{OUT_PARAMS_TRANSFERDATA}}, x::OUT_PARAMS_TRANSFERDATA)
    Ref(x)
end

function getData(g::GageCard)
    inputd = IN_PARAMS_TRANSFERDATA(zeros(fieldcount(IN_PARAMS_TRANSFERDATA) - 2)...,
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

    @threadcall(
        (:CsDrvTransferData, :CsDisp),
        Int32,
        (UInt32, Ptr{IN_PARAMS_TRANSFERDATA}, Ptr{OUT_PARAMS_TRANSFERDATA}),
        g.gagehandle,
        inputd,
        output,
    )
    c1
end

function datacomplete(gage)
    get_status(gage) > 1
end

function acquireData()
    while true
        take!(xfer_rdy)
        @show "acquire"
        start(gage)
        timedwait(()->datacomplete(gage), 1.0)
        put!(tokens, rand(1:10))
    end
end

function transferData()
    while true
        take!(tokens)
        @show "Xferdata"
        y = getData(gage)
        put!(xfers, y)
        put!(xfer_rdy, 1)
    end
end

xfer_rdy = Channel(4)
tokens = Channel(4)
xfers = Channel(4)

gage = GageCard(true)
set_segmentsize(gage, 5e5)
set_segmentcount(gage, 1)
set_samplerate(gage, 1e5)
set_trigger!(gage, 1, 1)

getData(gage)
@async acquireData()
@async transferData()
push!(xfer_rdy, 1)

for x in xfers
    show(x[1:10])
end
