using GageCompuscope
using CBinding
gage = GageCard(0)

set_segmentcount(gage, 1)
set_samplerate(gage, 1e7)
set_trigger!(gage,1,1)


start(gage)
get_status(gage)


@ctypedef InP2 @cstruct InPer {
    channel::Cushort
    mode::Cuint
    segment::Cuint
    startAddress::Cintmax_t
    length::Cintmax_t
    dataBuffer::Ptr{Cvoid}
    hNotifyEvent::Ptr{Cvoid}
  }

@cstruct OUT_PARAMS_TRANSFERDATA3 {
    ActualStart::Clonglong
    ActualLength::Clonglong
    LowPart::Cint
    HighPart::Cint
  } __packed__

OUT_PARAMS_TRANSFERDATA3()


inputd = InP2()
inputd.Mode[] =0
inputd.Channel[] = 1
inputd.Segment[] = 1
inputd.StartAddress[] = gage.acquisition_config.SampleOffset
inputd.Length[] = gage.acquisition_config.SegmentSize


#----- make non-crashing event pointer.
hnote = @cfunction(x->0x00000000,Cint,(Ptr{Cvoid},))
inputd.hNotifyEvent[] = hnote

#---- make transfer storage

d = Vector{Int16}(undef, 8192)
inputd.pDataBuffer[] = pointer_from_objref(d)
token = Ref{Int32}()
#---- do the transfer.

ccall((:CsTransferAS, :CsSsm),
    Int32,
    (UInt32,
     Ref{LibGage.IN_PARAMS_TRANSFERDATA2},
     Ref{OUT_PARAMS_TRANSFERDATA2},
     Ptr{Int32},),
    gage.gagehandle,
    Ref(inputd),
    Ref(output),
    token,
)
#---- check the status of the transfer.
result = Ref{Int64}()

LibGage.CsGetTransferASResult(gage.gagehandle,token[],pointer_from_objref(result))

result

using Plots; gr()

plot(d)
