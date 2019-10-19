mutable struct Transfer
    input::IN_PARAMS_TRANSFERDATA
    output::OUT_PARAMS_TRANSFERDATA
    segment_buffer::Union{Vector{Int16},Nothing}
    Transfer() =
        new(IN_PARAMS_TRANSFERDATA(), OUT_PARAMS_TRANSFERDATA(), nothing)
end

function Transfer(g::GageCard)
    xfer = Transfer()
    aq = g.acquisition_config
    inp = xfer.input
    inp.Channel = 1
    inp.Mode = TxMODE_DEFAULT
    inp.Segment = 1
    inp.StartAddress = aq.SampleOffset
    inp.Length = aq.SegmentSize
    xfer.segment_buffer = Vector{Int16}(undef, aq.SegmentSize)
    inp.pDataBuffer = pointer(xfer.segment_buffer)
    return xfer
end

Base.convert(::Type{IN_PARAMS_TRANSFERDATA}, x::Transfer) = x.input

function Base.unsafe_convert(::Type{Ptr{OUT_PARAMS_TRANSFERDATA}},x::OUT_PARAMS_TRANSFERDATA)
    Base.unsafe_convert(Ptr{OUT_PARAMS_TRANSFERDATA},Ref(x))
end

function acquire(gage::GageCard, xfer::Transfer)
    start(gage)
    while CsGetStatus(gage.gagehandle) > 0
    end
    CsTransfer(gage.gagehandle, xfer.input, xfer.output)
    nothing
end

function transfer_data(g::GageCard, xfer::Transfer)
    CsTransfer_threadcall(g.gagehandle, xfer.input, xfer.output)
end

function until_ready(g::GageCard;timeout=10.0)
    status = get_status(g)
    t1 = time()
    laststatus = 0
    while status > 0
        sleep(1e-2)
        time() - t1 > timeout && break
        status = get_status(g)
    end
end
struct MultipleTransfer
    input::IN_PARAMS_TRANSFERDATA
    output::OUT_PARAMS_TRANSFERDATA
    segment_buffer::Array{Int16,2}
end

function MultipleTransfer(g::GageCard)
    acq = g.acquisition_config
    _inp = IN_PARAMS_TRANSFERDATA(1,0,1,acq.SampleOffset,acq.SegmentSize,C_NULL,C_NULL)
    _outp = OUT_PARAMS_TRANSFERDATA(0,0,0,0)

    xfer = MultipleTransfer(_inp, _outp, Array{Int16,2}(undef,acq.SegmentSize,acq.SegmentCount))
    xfer.input.pDataBuffer = pointer(xfer.segment_buffer)
    return xfer
end

function transfer_multiplerecord(g::GageCard,x::MultipleTransfer)
    @inbounds for (i,xt) in enumerate(eachcol(x.segment_buffer))
        x.input.Segment = i
        x.input.pDataBuffer = pointer(xt)
        st = CsTransfer(g.gagehandle, x.input,x.output)
        st < 0 && error("failed.")
    end
end
