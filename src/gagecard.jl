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
    @info g.channel_configs
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
    gage.channel_configs = Vector{CSCHANNELCONFIG}(
        undef,
        gage.systeminfo.ChannelCount,
    )
    gage.trigger_configs = Vector{CSTRIGGERCONFIG}(
        undef,
        gage.systeminfo.TriggerMachineCount,
    )
    get_configs!(gage)

    return gage
end

function free_system(g::GageCard)
    CsFreeSystem(g.gagehandle)
end
