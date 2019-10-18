using GageCompuscope.LibGage
using GageCompuscope

gage = GageCard(0)


token = Ref{Int32}()


xfer = Transfer(gage)
xfer.input.Mode = TxMODE_DATA_ANALOGONLY
start(gage)

evnt = Base.AsyncCondition()
xfer.input.hNotifyEvent = evnt.handle

function Base.unsafe_convert(
    ::Type{Ptr{IN_PARAMS_TRANSFERDATA}},
    x::IN_PARAMS_TRANSFERDATA,
)
    Base.unsafe_convert(Ptr{IN_PARAMS_TRANSFERDATA}, Ref(x))
end

CsTransferAS(gage.gagehandle, xfer.input, xfer.output, token)


CsGetTransferASResult(gage.gagehandle, token[], Ref(0))



dostop = Ref(false)
dostop[] = true
@async while true
    @info evnt
    sleep(0.5)
    dostop[] && break
end
