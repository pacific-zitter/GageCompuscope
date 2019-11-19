using GageCompuscope

gage = GageCard(true)

set_samplerate(gage, 10e6)
set_segmentsize(gage, 10e6)
set_segmentcount(gage, 64)
set_trigger!(gage, 1, 1; source = 2)

start(gage)
get_status(gage)

r = IN_PARAMS_TRANSFERDATA()
r.Length = 10e6
data_buffer = Vector{Int16}(undef, 10^7)
r.pDataBuffer = pointer(data_buffer, 1)

o = OUT_PARAMS_TRANSFERDATA()
tok = Ref{Cint}()

res = Ref{Int64}(0)
CsGetTransferASResult(gage.gagehandle, tok[], res)
CsFreeSystem(3939227)




ccall((:CsExpertCall,:CsSsm),Cint,())
