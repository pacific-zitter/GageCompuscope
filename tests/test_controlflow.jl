using GageCompuscope
import GageCompuscope.LibGage
using Plots;plotlyjs()
using Tracker
gage = GageCard(0)
set_samplerate(gage,1e6)
set_segmentsize(gage,3e6)
xfer = Transfer(gage)

LibGage.CsGetStatus(gage.gagehandle)

token = Ref{Cint}(0)

h = [C_NULL]
function cv()::Cvoid
	return nothing
end
cc = @cfunction(cv,Cvoid,())
xfer.input.hNotifyEvent = pointer_from_objref(h)

start(gage)
while LibGage.CsGetStatus(gage.gagehandle) > 0
	@show LibGage.CsGetStatus(gage.gagehandle)
end
struct tokens
	m::Int
end
mytok = tokens(0)


Base.unsafe_convert(::Type{Ptr{LibGage.OUT_PARAMS_TRANSFERDATA}},m::Ref{LibGage.OUT_PARAMS_TRANSFERDATA}) = begin
	
end

LibGage.CsTransferAS(gage.gagehandle,xfer.input,xfer.output,Ref(mytok))



while LibGage.CsGetStatus(gage.gagehandle) > 0
	@show LibGage.CsGetStatus(gage.gagehandle)
end

q
l = Int64[1]
LibGage.CsGetTransferASResult(gage.gagehandle,Ref(q,1),Ref(l,1))


xfer.segment_buffer


plot(xfer.segment_buffer[1:1000])
force_trigger(gage)
free_system(gage)
