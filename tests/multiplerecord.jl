using GageCompuscope


gage = GageCard()
begin #Settings and structure initialization.
    A = gage.acquisition_config

    A.SampleRate = 1e8
    A.TriggerHoldoff = 0
    A.SegmentSize = A.Depth = 1e5
    A.Mode = CS_MODE_SINGLE
    A.SegmentCount = 10

    CsSet(gage)
    st = commit(gage)
    st < 0 && error(cserror(st))
end


M = MultipleRecord(gage)
start(gage)
get_status(gage)

for (i,d) in enumerate(eachcol(M.data_array))
    M.input_gage.Segment = i
    M.input_gage.pDataBuffer = pointer(d)
    st=ccall((:CsTransfer, csssm),Cint,(Cuint,Ref{IN_PARAMS_TRANSFERDATA},Ptr{OUT_PARAMS_TRANSFERDATA}),gage.gagehandle,M.input_gage,M.output_gage)
end

using Plots
M
plotly()
p1=plot(M.data_array[:,1])
