using GageCompuscope
using CBinding

gage = GageCard(0)

set_segmentcount(gage, 1)
set_samplerate(gage, 1e7)
set_trigger!(gage, 1, 1)


inputd = LibGage.IN_PARAMS_TRANSFERDATA(undef)

inputd.Channel = 1;
inputd.Length = 8192
inputd.StartAddress = gage.acquisition_config.SampleOffset
inputd.Segment = 1
output = LibGage.OUT_PARAMS_TRANSFERDATA()

#----- make non-crashing event pointer.
hnote = @cfunction(x -> 0x00000000, Cint, (Ptr{Cvoid},))
inputd.hNotifyEvent = hnote
#---- make transfer storage

d = Vector{Int16}(undef, 8192)
inputd.pDataBuffer = pointer_from_objref(d)
token = Ref{Int32}()
#---- do the transfer.

ccall(
    (:CsTransferAS, :CsSsm),
    Int32,
    (
     UInt32,
     Ref{LibGage.IN_PARAMS_TRANSFERDATA},
     Ref{LibGage.OUT_PARAMS_TRANSFERDATA},
     Ptr{Int32},
    ),
    gage.gagehandle,
    inputd,
    output,
    token,
)
#---- check the status of the transfer.
result = Ref{Int64}()

LibGage.CsGetTransferASResult(
    gage.gagehandle,
    token[],
    pointer_from_objref(result),
)
