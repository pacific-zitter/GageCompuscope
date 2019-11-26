using GageCompuscope
using FFTW

Base.convert(::Type{UInt32}, x::GageCard) = x.gagehandle
gage = GageCard(true)

A = gage.acquisition_config
A.Depth = A.SegmentSize = 8192
A.Mode = CS_MODE_SINGLE
CsSet(gage, CS_ACQUISITION, A)
commit(gage)
not = [0]
M = MultipleRecord(gage)
M.input_gage.hNotifyEvent = pointer(not, 1)

function drvtransfer(g::GageCard, mult::MultipleRecord)

    ccall(
        (:CsDrvTransferData, :CsDisp),
        Cint,
        (
         Cuint,
         Ref{IN_PARAMS_TRANSFERDATA},
         Ref{OUT_PARAMS_TRANSFERDATA}
        ),
        g,
        mult.input_gage,
        mult.output_gage
    )

end
cserror(3)
drvtransfer(gage, M)
p = Int64[]


using Plots
gr()
plot(M.data_array)
