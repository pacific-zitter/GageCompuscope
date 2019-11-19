using GageCompuscope

gage = GageCard(true)

m = MultipleRecord(gage)

set_samplerate(gage, 10e7)
set_segmentcount(gage,1920)
set_trigger!(gage,1,1)
start(gage)

get_status(gage)
force(gage)
abort(gage)

free_system(gage)



_in = IN_PARAMS_TRANSFERDATA()
_in.StartAddress = -1; _in.Length = 8192
q = Vector{Cshort}(undef,8192)
_in.pDataBuffer = pointer(q)

_o = OUT_PARAMS_TRANSFERDATA()
ccall(
    (:CsDrvTransferData,:CsDisp),
    Cint,
    (
        Cuint,
        IN_PARAMS_TRANSFERDATA,
        Ref{OUT_PARAMS_TRANSFERDATA}
    ),
    gage.gagehandle,
    _in,
    _o
    )
