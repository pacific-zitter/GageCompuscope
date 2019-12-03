const gage_index = Dict(
    CSACQUISITIONCONFIG => CS_ACQUISITION,
    CSTRIGGERCONFIG => CS_TRIGGER,
    CSCHANNELCONFIG => CS_CHANNEL,
    CSSYSTEMINFO => CS_BOARD_INFO,
)

Base.convert(::T, g::GageCard) where {T<:Integer} = convert(T, g.gagehandle)

#-------------------------------------------------------------------------------
# CsSet specializations.
#-------------------------------------------------------------------------------
CsSet(g::GageCard, a::AcquisitionCfg) =
    LibGage.CsSet(g.gagehandle, CS_ACQUISITION, a)
CsSet(g::GageCard, a::TriggerCfg) = LibGage.CsSet(g.gagehandle, CS_TRIGGER, a)
CsSet(g::GageCard, a::ChannelCfg) = LibGage.CsSet(g.gagehandle, CS_CHANNEL, a)

function CsSet(g::GageCard)
    st = CsSet(g, g.acquisition_config)
    st < 0 && error(cserror(st))
    foreach(g.channel_config) do c
        st = CsSet(g, c)
        st < 0 && error(cserror(st))
    end
    foreach(g.trigger_config) do tr

        st = CsSet(g, tr)
        st < 0 && error(cserror(st))
    end
end

#-------------------------------------------------------------------------------
# Iteration interface.
#-------------------------------------------------------------------------------
function Base.iterate(Cs::C, state = 1) where {C<:CsConfig}
    state >= fieldcount(C) ? nothing :
    (getfield(Cs, fieldname(C, state)), state + 1)
end

Base.length(cfg::C) where {C<:CsConfig} = fieldcount(C)
Base.eltype(::Type{CsConfig}) = Union{Integer,NTuple{Integer,N}} where {N}

#-------------------------------------------------------------------------------
# AbstractArray interface.
#-------------------------------------------------------------------------------
Base.getindex(cfg::C, i::Int) where {C<:CsConfig} = getproperty(cfg, i)
Base.getindex(cfg::C, i::AbstractString) where {C<:CsConfig} =
    getfield(cfg, Symbol(i))

"""
Allow for dictionary-like interaction, eg. AcquisitionCfg["SampleRate"] = 1e7
"""
function Base.setindex!(
    cfg::C,
    v,
    f::Union{Int64,AbstractString},
) where {C<:CsConfig}
    v = convert(fieldtype(C, Symbol(f)), v)
    nm = setproperty!(cfg, Symbol(f), v)
end
