using GageCompuscope
using CBinding
gage = GageCard(true)

set_samplerate(gage, 10^7)
set_segmentsize(gage, 8192)
set_segmentcount(gage, 1)
hxEvent = ccall((:CreateEvent,:Kernel32),Cint,(Ptr{Cvoid},Cint,Cint,Ptr{Cvoid}),
    C_NULL,0,0,C_NULL)

using Libdl

dlsym(dlopen(:Kernel32),:CreateEventA)

Base.AsyncCondition()

CsDo(gage.gagehandle,ACTION_START)



@cstruct gIn {
    Channel::Cushort
    Mode::Cuint
    Segment::Cuint
    StartAddress::Clonglong
    Length::Clonglong
    pDataBuffer::Ptr{Cvoid}
    hNotifyEvent::Ptr{Ptr{Cvoid}}
  } __packed__

data = Vector{Int16}(undef, 10^5)

HH =[C_NULL]
out = OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
_input = gIn(Channel=1,Mode=TxMODE_SLAVE,Segment=1,StartAddress= -1, Length=10^5,
    pDataBuffer=pointer(data,1),hNotifyEvent=HH[1])


start(gage)
get_status(gage)

Base.unsafe_convert(::Type{Ptr{gIn}},i::gIn) = Base.unsafe_convert(Ptr{gIn},Ref(i))
Base.unsafe_convert(::Type{Ptr{gIn}},i::gIn) = Base.unsafe_convert(Ptr{gIn},Ref(i))

token = Ref{Cint}(0)
ccall(
    (:CsTransfer,:CsSsm),
    Cint,
    (
     Cuint,
     Ptr{gIn},
     Ptr{OUT_PARAMS_TRANSFERDATA},
    ),
    gage.gagehandle,
    _input,
    out
)

CsGetTransferASResult(gage.gagehandle,token[], Clonglong[])

CsFreeSystem(gage.gagehandle)
