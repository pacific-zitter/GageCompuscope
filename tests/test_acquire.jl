joinpath(@__DIR__, "..", "devel", "higher.jl") |> include
using Plots, BenchmarkTools

get_gagecard()

acquisition_config.SegmentCount = 1
acquisition_config.SampleRate = 1e6
acquisition_config.SegmentSize = acquisition_config.Depth = 8192
set_config(acquisition_config)
gage_commit() |> CsGetErrorString
get_configs()
ACQ_STATUS_WAIT_TRIGGER

q = Int8[]
times = Float64[]
begin
    t1 = time()
    gage_start()
    while CsGetStatus(gagehandle[]) != 0
        push!(q, CsGetStatus(gagehandle[]))
        push!(times, time() - t1)
        sleep(1e-3)
    end
end
plot(times, q)

dbuf = allocate_transfer()
inp = _inparams_gage(1, 1, dbuf)
outp = OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)


free_system()

CsFreeSystem(131083)
