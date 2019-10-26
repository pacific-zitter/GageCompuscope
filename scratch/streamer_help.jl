using GageCompuscope
using GageCompuscope.LibGage

gage = GageCard(0)
Base.convert(::Type{UInt32}, g::GageCard) = g.gagehandle
r = Int64[0]
st = CsGet(gage, CS_PARAMS, CS_EXTENDED_BOARD_OPTIONS, pointer(r, 1))

function _get(g::GageCard)
    o = Ref{Cintmax_t}()
    st = ccall((:CsGet, :CsSsm),
        Int32,
        (UInt32, Int32, Int32, Ptr{Cvoid}),
        g.gagehandle,
        CS_PARAMS,
        CS_EXTENDED_BOARD_OPTIONS,
        o)
    o, st
end

_get(gage)
