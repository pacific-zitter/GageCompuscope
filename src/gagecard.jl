mutable struct GageCard
    gagehandle::Int
    systeminfo::CSSYSTEMINFO
    acquisition_config::CSACQUISITIONCONFIG
    channel_configs::Vector{CSCHANNELCONFIG}
    trigger_configs::Vector{CSTRIGGERCONFIG}
    GageCard() = new()
end

# --
function LibGage.CsGet(
    g::GageCard,
    cfg::Union{CSACQUISITIONCONFIG,CSTRIGGERCONFIG,CSCHANNELCONFIG},
)
    LibGage.CsGet(g.gagehandle, cfg)
end

function get_systeminfo!(g::GageCard)
    g.systeminfo = CSSYSTEMINFO()
    CsGetSystemInfo(g.gagehandle, g.systeminfo)
end

function get_configs!(g::GageCard)
    st = CsGet(g, g.acquisition_config)
    st < 1 && error("error getting acquisition_config: " * CsGetErrorString(st))
    for chnl in g.channel_configs
        CsGet(g, chnl)
    end
    for trgr in g.trigger_configs
        CsGet(g, trgr)
    end
end

function GageCard(board_index)
    gage = GageCard()
    m = Ref{Cuint}(0)

    CsInitialize()
    CsGetSystem(m, 0, 0, 0, board_index)
    gage.gagehandle = Int(m[])
    get_systeminfo!(gage)
    gage.acquisition_config = CSACQUISITIONCONFIG()

    gage.channel_configs = CSCHANNELCONFIG[]
    for i = 1:gage.systeminfo.ChannelCount
        push!(gage.channel_configs, CSCHANNELCONFIG(Int(i)))
    end

    gage.trigger_configs = CSTRIGGERCONFIG[]
    for i = 1:gage.systeminfo.TriggerMachineCount
        push!(gage.trigger_configs, CSTRIGGERCONFIG(Int(i)))
    end
    get_configs!(gage)

    return gage
end

function free_system(g::GageCard)
    CsFreeSystem(g.gagehandle)
end

function start(g::GageCard)
    CsDo(g.gagehandle, ACTION_START)
end

function abort(g::GageCard)
    CsDo(g.gagehandle, ACTION_ABORT)
end

function commit(g::GageCard)
    CsDo(g.gagehandle,ACTION_COMMIT)
end

function get_status(g::GageCard)
    CsGetStatus(g.gagehandle)
end

function force_trigger(g::GageCard)
    CsDo(g.gagehandle, ACTION_FORCE)
end

function set_segmentsize(g::GageCard, nsegment)
    g.acquisition_config.Depth = nsegment
    g.acquisition_config.SegmentSize = nsegment
    CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    CsDo(g.gagehandle, ACTION_COMMIT)
end

function set_segmentcount(g::GageCard, n)
    g.acquisition_config.SegmentCount = n
    CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    CsDo(g.gagehandle, ACTION_COMMIT)
end

function set_samplerate(g::GageCard, samplerate)
    g.acquisition_config.SampleRate = samplerate
    CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    CsDo(g.gagehandle, ACTION_COMMIT)
end

#------------------------------------------------------------------------------
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
