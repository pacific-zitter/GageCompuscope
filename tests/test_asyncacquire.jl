using GageCompuscope
using BenchmarkTools
using Blink, Interact
using Plots
get_gagecard()

acquisition_config.SampleRate = 1e7
acquisition_config.Depth = acquisition_config.SegmentSize = 1e7
acquisition_config.SegmentCount = 1
acquisition_config.Depth |> Int

set_allconfigs()
gage_commit(true) |> LibGage.CsGetErrorString
get_configs()
gage_start()

ddb = Vector{Int16}(
    undef,
    acquisition_config.SegmentCount * acquisition_config.SegmentSize,
)

inp = _inparams_gage(1, 1, ddb)
inp.hNotifyEvent = @cfunction(x -> nothing, Cvoid, ())
outp = LibGage.OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)

inp.Segment = 1
inp.pDataBuffer = pointer(ddb)
token = Ref{Int32}(0)
q = Int32[]
begin
    LibGage.CsTransferAS(GageCompuscope.gagehandle[], inp, outp, token) |> LibGage.CsGetErrorString
    t1=time()
    while  time() - t1 < 1
        push!(q,token[])
    end
end
unique(q)
LibGage.CsGetStatus(GageCompuscope.gagehandle[])
t1 = time()

f = time() - t1
