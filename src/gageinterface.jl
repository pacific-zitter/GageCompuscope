
const gage_index = Dict(
    CSACQUISITIONCONFIG => CS_ACQUISITION,
    CSTRIGGERCONFIG => CS_TRIGGER,
    CSCHANNELCONFIG => CS_CHANNEL,
    CSSYSTEMINFO => CS_BOARD_INFO,
)

Base.convert(::T,g::GageCard) where {T<:Integer} = convert(Int,g.gagehandle)
CsSet(g::GageCard, a::AcquisitionCfg) = LibGage.CsSet(g.gagehandle,CS_ACQUISITION,a)
CsSet(g::GageCard, a::TriggerCfg) = LibGage.CsSet(g.gagehandle,CS_TRIGGER,a)
CsSet(g::GageCard, a::ChannelCfg) = LibGage.CsSet(g.gagehandle,CS_CHANNEL,a)

function CsSet(g::GageCard)
    st= CsSet(g,g.acquisition_config)
    st < 0 && error(cserror(st))
    foreach(g.channel_config) do c
        st=CsSet(g,c)
        st < 0 && error(cserror(st))
    end
    foreach(g.trigger_config) do tr
        st=CsSet(g,tr)
        st < 0 && error(cserror(st))
    end
end
