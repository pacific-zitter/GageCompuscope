<<<<<<< HEAD
#TODO: REFACTOR ALL THIS CODE INTO GAGECARD.JL AND ENCAPSULATE GLOBALS.
#-------------------------------------------------------------------------------
const system_info = CSSYSTEMINFO()
const acquisition_config = CSACQUISITIONCONFIG()
const channel_config = CSCHANNELCONFIG[]
const trigger_config = CSTRIGGERCONFIG[]

CsDo(operation) = LibGage.CsDo(gagehandle[], operation);
gage_start() = CsDo(ACTION_START)
gage_commit(coerce = false) = begin
    q = ACTION_COMMIT
    coerce && (q = ACTION_COMMIT_COERCE)
    CsDo(q)
end

gage_abort() = CsDo(ACTION_ABORT)
gage_forcetrigger() = CsDo(ACTION_FORCE)
#-------------------------------------------------------------------------------
function get_systeminfo()
    CsGetSystemInfo(system_info)
end

function get_configs()
    st = CsGet(CS_ACQUISITION, CS_CURRENT_CONFIGURATION, acquisition_config)
    st < 1 && error("error getting acquisition_config: " * CsGetErrorString(st))
    !isempty(channel_config) && empty!(channel_config)
    !isempty(trigger_config) && empty!(trigger_config)
    for chi = 1:system_info.ChannelCount
        chnl = CSCHANNELCONFIG(chi)
        CsGet(CS_CHANNEL, CS_CURRENT_CONFIGURATION, chnl)
        push!(channel_config, chnl)
    end
    for tri = 1:system_info.TriggerMachineCount
        @info tri
        trgr = CSTRIGGERCONFIG(tri)
        CsGet(CS_TRIGGER, CS_CURRENT_CONFIGURATION, trgr)
        push!(trigger_config, trgr)
    end
end

function set_allconfigs()
    st1 = CsSet(CS_ACQUISITION, acquisition_config)

    st2 = Int32[]
    for chnl in channel_config
        push!(st2, CsSet(CS_CHANNEL, chnl))
    end

    st3 = Int32[]
    for trgr in trigger_config
        push!(st3, CsSet(CS_TRIGGER, trgr))
    end

    any(vcat(st1, st2, st3) .< 0) ? vcat(st1, st2, st3) : 1
end

function get_gagecard()
    initialize_gage()
    get_systeminfo()
    get_configs()
end

#-------------------------------------------------------------------------------
function singlemode()
    acquisition_config.Mode = CS_MODE_SINGLE
    set_config(acquisition_config)
    gage_commit(coerce = true)
end

function set_samplerate(fs)
    acquisition_config.SampleRate = fs
    set_config(acquisition_config)
    gage_commit(coerce = true)
end

#-------------------------------------------------------------------------------
function set_channel(channel_number)

end

function set_trigger(
    number,
    source;
    level = 0,
    condition = "rising",
    impedance = nothing,
)
    current_trigger = trigger_config[number]
    current_trigger.Source = source
    current_trigger.Level = level
    current_trigger.Condition = CS_TRIG_COND_POS_SLOPE
    current_trigger.ExtImpedance = CS_REAL_IMP_1M_OHM
    set_config(current_trigger)
    gage_commit(coerce = false)
end

#-------------------------------------------------------------------------------
function allocate_transfer()
    l = acquisition_config.SegmentSize
    return zeros(Int16, l)
end

"""
    Given the acquisition information and a preallocated data buffer and the
channel number that we want to transfer,return the IN_PARAMS_TRANSFERDATA struct-
ure that the GaGe CAPI expects.
"""
function _inparams_gage(channel, segment, databuff)
    strtAddr = acquisition_config.SampleOffset
    l = length(databuff)
    gobj = IN_PARAMS_TRANSFERDATA(
        channel,
        TxMODE_DEFAULT,
        segment,
        strtAddr,
        l,
        pointer(databuff),
        C_NULL,
    )
end

function gage_transfer()
    ddb = Vector{Int16}(
        undef,
        acquisition_config.SegmentCount * acquisition_config.SegmentSize,
    )
    ddb = reshape(ddb, :, Int(acquisition_config.SegmentCount))
    inp = _inparams_gage(1, 1, ddb)
    outp = LibGage.OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
    @inbounds for (i, p) in enumerate(eachcol(ddb))
        inp.Segment = i
        inp.pDataBuffer = pointer(p)
        LibGage.CsTransfer(GageCompuscope.gagehandle[], inp, outp)
    end
    ddb
end

function gage_transfer_async()
    ddb = Vector{Int16}(
        undef,
        acquisition_config.SegmentCount * acquisition_config.SegmentSize,
    )
    ddb = reshape(ddb, :, Int(acquisition_config.SegmentCount))
    inp = _inparams_gage(1, 1, ddb)
    outp = LibGage.OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
    @inbounds for (i, p) in enumerate(eachcol(ddb))
        inp.Segment = i
        inp.pDataBuffer = pointer(p)
        LibGage.CsTransferAS(
            GageCompuscope.gagehandle[],
            inp,
            outp,
            Ref(Int32(0)),
        )
    end
    ddb
end
#------------------------------------------------------------------------------
=======
#TODO: REFACTOR ALL THIS CODE INTO GAGECARD.JL AND ENCAPSULATE GLOBALS.
#-------------------------------------------------------------------------------
const system_info = CSSYSTEMINFO()
const acquisition_config = CSACQUISITIONCONFIG()
const channel_config = CSCHANNELCONFIG[]
const trigger_config = CSTRIGGERCONFIG[]

CsDo(operation) = LibGage.CsDo(gagehandle[], operation);
gage_start() = CsDo(ACTION_START)
gage_commit(coerce = false) = begin
    q = ACTION_COMMIT
    coerce && (q = ACTION_COMMIT_COERCE)
    CsDo(q)
end

gage_abort() = CsDo(ACTION_ABORT)
gage_forcetrigger() = CsDo(ACTION_FORCE)
#-------------------------------------------------------------------------------
function get_systeminfo()
    CsGetSystemInfo(system_info)
end

function get_configs()
    st = CsGet(CS_ACQUISITION, CS_CURRENT_CONFIGURATION, acquisition_config)
    st < 1 && error("error getting acquisition_config: " * CsGetErrorString(st))
    !isempty(channel_config) && empty!(channel_config)
    !isempty(trigger_config) && empty!(trigger_config)
    for chi = 1:system_info.ChannelCount
        chnl = CSCHANNELCONFIG(chi)
        CsGet(CS_CHANNEL, CS_CURRENT_CONFIGURATION, chnl)
        push!(channel_config, chnl)
    end
    for tri = 1:system_info.TriggerMachineCount
        @info tri
        trgr = CSTRIGGERCONFIG(tri)
        CsGet(CS_TRIGGER, CS_CURRENT_CONFIGURATION, trgr)
        push!(trigger_config, trgr)
    end
end

function set_allconfigs()
    st1 = CsSet(CS_ACQUISITION, acquisition_config)

    st2 = Int32[]
    for chnl in channel_config
        push!(st2, CsSet(CS_CHANNEL, chnl))
    end

    st3 = Int32[]
    for trgr in trigger_config
        push!(st3, CsSet(CS_TRIGGER, trgr))
    end

    any(vcat(st1, st2, st3) .< 0) ? vcat(st1, st2, st3) : 1
end

function get_gagecard()
    initialize_gage()
    get_systeminfo()
    get_configs()
end

#-------------------------------------------------------------------------------
function singlemode()
    acquisition_config.Mode = CS_MODE_SINGLE
    set_config(acquisition_config)
    gage_commit(coerce = true)
end

function set_samplerate(fs)
    acquisition_config.SampleRate = fs
    set_config(acquisition_config)
    gage_commit(coerce = true)
end

#-------------------------------------------------------------------------------
function set_channel(channel_number)

end

function set_trigger(
    number,
    source;
    level = 0,
    condition = "rising",
    impedance = nothing,
)
    current_trigger = trigger_config[number]
    current_trigger.Source = source
    current_trigger.Level = level
    current_trigger.Condition = CS_TRIG_COND_POS_SLOPE
    current_trigger.ExtImpedance = CS_REAL_IMP_1M_OHM
    set_config(current_trigger)
    gage_commit(coerce = false)
end

#-------------------------------------------------------------------------------
function allocate_transfer()
    l = acquisition_config.SegmentSize
    return zeros(Int16, l)
end

"""
    Given the acquisition information and a preallocated data buffer and the
channel number that we want to transfer,return the IN_PARAMS_TRANSFERDATA struct-
ure that the GaGe CAPI expects.
"""
function _inparams_gage(channel, segment, databuff)
    strtAddr = acquisition_config.SampleOffset
    l = length(databuff)
    gobj = IN_PARAMS_TRANSFERDATA(
        channel,
        TxMODE_DEFAULT,
        segment,
        strtAddr,
        l,
        pointer(databuff),
        C_NULL,
    )
end

function gage_transfer()
    ddb = Vector{Int16}(
        undef,
        acquisition_config.SegmentCount * acquisition_config.SegmentSize,
    )
    ddb = reshape(ddb, :, Int(acquisition_config.SegmentCount))
    inp = _inparams_gage(1, 1, ddb)
    outp = LibGage.OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
    @inbounds for (i, p) in enumerate(eachcol(ddb))
        inp.Segment = i
        inp.pDataBuffer = pointer(p)
        LibGage.CsTransfer(GageCompuscope.gagehandle[], inp, outp)
    end
    ddb
end

function gage_transfer_async()
    ddb = Vector{Int16}(
        undef,
        acquisition_config.SegmentCount * acquisition_config.SegmentSize,
    )
    ddb = reshape(ddb, :, Int(acquisition_config.SegmentCount))
    inp = _inparams_gage(1, 1, ddb)
    outp = LibGage.OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
    @inbounds for (i, p) in enumerate(eachcol(ddb))
        inp.Segment = i
        inp.pDataBuffer = pointer(p)
        LibGage.CsTransferAS(
            GageCompuscope.gagehandle[],
            inp,
            outp,
            Ref(Int32(0)),
        )
    end
    ddb
end
#------------------------------------------------------------------------------
>>>>>>> 29ef793a7e338feaebbe2e21b81b2d4c07aef89f
