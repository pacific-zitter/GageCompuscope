mutable struct GageCard
    gagehandle::Int
    systeminfo::CSSYSTEMINFO
    acquisition_config::CSACQUISITIONCONFIG
    channel_config::Vector{CSCHANNELCONFIG}
    trigger_config::Vector{CSTRIGGERCONFIG}
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
    for chnl in g.channel_config
        CsGet(g, chnl)
    end
    for trgr in g.trigger_config
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

    gage.channel_config = CSCHANNELCONFIG[]
    for i = 1:gage.systeminfo.ChannelCount
        push!(gage.channel_config, CSCHANNELCONFIG(Int(i)))
    end

    gage.trigger_config = CSTRIGGERCONFIG[]
    for i = 1:gage.systeminfo.TriggerMachineCount
        push!(gage.trigger_config, CSTRIGGERCONFIG(Int(i)))
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

function commit(g::GageCard; coerce = false)
    which_action = coerce ? ACTION_COMMIT_COERCE : ACTION_COMMIT
    CsDo(g.gagehandle, which_action)
end

function get_status(g::GageCard)
    CsGetStatus(g.gagehandle)
end

function force(g::GageCard)
    CsDo(g.gagehandle, ACTION_FORCE)
end


"""
    CsSet(g::GageCard, option)
option ∈ [:all, :acquisition,:channel,:trigger]
"""
function set_cfg!(gage, cfg, option)
    cfg = Symbol(option,:_config)
    nidx = eval(Symbol("CS_", uppercase(string(option))))
    @show Base.@locals
    CsSet(gage.gagehandle, nidx,cfg)
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
    CsSet(g.gagehandle,CS_CHANNEL,cfg)
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
function set_trigger!(g::GageCard,idx,level,source="1";condition="rising")
    level > 100 && error("level is given as a percent of source. 0-100%")
    trgr = g.trigger_config[idx]
    trgr.Level = level
    trgr.Source = trigger_sources[source]
    trgr.Condition = trigger_conditions[condition]
    CsSet(g.gagehandle,CS_TRIGGER,trgr)
    commit(g)
end

cserror(code) = CsGetErrorString(code)
