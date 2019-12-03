mutable struct GageCard
    gagehandle::Cuint
    systeminfo::SystemInfo
    acquisition_config::AcquisitionCfg
    channel_config::Vector{ChannelCfg}
    trigger_config::Vector{TriggerCfg}
end


function get_systeminfo!(g::GageCard)
    g.systeminfo = SystemInfo()
    CsGetSystemInfo(g.gagehandle, g.systeminfo)
end

function GageCard()
    _handle = Ref{Cuint}()
    CsInitialize()
    st = CsGetSystem(_handle, 0, 0, 0, 0)
    st < 0 && error("$(cserror(st))")

    info = SystemInfo()
    CsGetSystemInfo(_handle[], info)

    acq = AcquisitionCfg()
    st = CsGet(_handle[], CS_ACQUISITION, CS_CURRENT_CONFIGURATION, acq)

    chnls = ChannelCfg[]
    for i = 1:info.ChannelCount
        chnl = ChannelCfg(i)
        CsGet(_handle[], CS_CHANNEL, CS_CURRENT_CONFIGURATION, chnl)
        push!(chnls, chnl)
    end

    trgrs = TriggerCfg[]
    for i = 1:info.TriggerMachineCount
        trgr = TriggerCfg(i)
        CsGet(_handle[], CS_TRIGGER, CS_CURRENT_CONFIGURATION, trgr)
        push!(trgrs, trgr)
    end


    return GageCard(_handle[], info, acq, chnls, trgrs)
end

function free_system(g::GageCard)
    CsFreeSystem(g.gagehandle)
end

function start(g::GageCard)
    st = CsDo(g.gagehandle, ACTION_START)
    st < 1 && error(cserror(st))
end

function abort(g::GageCard)
    CsDo(g.gagehandle, ACTION_ABORT)
end

function commit(g::GageCard; coerce = false)
    which_action = coerce ? ACTION_COMMIT_COERCE : ACTION_COMMIT
    st = CsDo(g.gagehandle, which_action)
    st < 1 && error(cserror(st))
end

function get_status(g::GageCard)
    CsGetStatus(g.gagehandle)
end

function force(g::GageCard)
    CsDo(g.gagehandle, ACTION_FORCE)
end

function set_segmentsize(g::GageCard, nsegment)
    g.acquisition_config.Depth = nsegment
    g.acquisition_config.SegmentSize = nsegment
    st = CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    st < 0 && error(cserror(st))
    st = CsDo(g.gagehandle, ACTION_COMMIT)
    st < 0 && error(cserror(st))
    st
end

function set_segmentcount(g::GageCard, n)
    g.acquisition_config.SegmentCount = n
    st1 = CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    st1 < 0 && error(cserror(st1))
    st2 = CsDo(g.gagehandle, ACTION_COMMIT)
    st2 < 0 && error(cserror(st2))
    return 1
end

function set_samplerate(g::GageCard, samplerate)
    g.acquisition_config.SampleRate = samplerate
    st1 = CsSet(g.gagehandle, CS_ACQUISITION, g.acquisition_config)
    st1 < 0 && error(cserror(st1))
    st2 = CsDo(g.gagehandle, ACTION_COMMIT)
    st2 < 0 && error(cserror(st2))
    1
end

const terminations = Dict("dc" => CS_COUPLING_DC, "ac" => CS_COUPLING_AC)
const impedances = Dict(
    "low" => CS_REAL_IMP_50_OHM,
    "high" => CS_REAL_IMP_1M_OHM,
)

function set_channel!(
    g::GageCard,
    index,
    range_mv::Int;
    impedance = "low",
    termination = "ac",
)
    cfg::CSCHANNELCONFIG = g.channel_config[index]
    cfg.InputRange = range_mv
    cfg.Term = terminations[termination]
    cfg.Impedance = impedances[impedance]
    CsSet(g.gagehandle, CS_CHANNEL, cfg)
    commit(g)
end

const trigger_conditions = Dict(
    "rising" => CS_TRIG_COND_POS_SLOPE,
    "falling" => CS_TRIG_COND_NEG_SLOPE,
    "pulse_width" => CS_TRIG_COND_PULSE_WIDTH,
)
const trigger_sources = Dict(
    "1" => CS_TRIG_SOURCE_CHAN_1,
    "2" => CS_TRIG_SOURCE_CHAN_2,
    "external" => CS_TRIG_SOURCE_EXT,
    "off" => CS_TRIG_SOURCE_DISABLE,
)
function set_trigger!(
    g::GageCard,
    idx,
    level,
    source = "1";
    condition = "rising",
)
    level > 100 && error("level is given as a percent of source. 0-100%")
    trgr = g.trigger_config[idx]
    trgr.Level = level
    trgr.Source = trigger_sources[source]
    trgr.Condition = trigger_conditions[condition]
    CsSet(g.gagehandle, CS_TRIGGER, trgr)
    commit(g)
end
