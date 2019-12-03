Base.include(@__MODULE__,joinpath(@__DIR__,"initgage_default.jl"))
using GageCompuscope: Acquire, untilReady, transfer_thread, trigger_thread
using Plots;plotlyjs()

A = Acquire(gage,256)

for _ in 1:4
    x1 = Threads.@spawn transfer_thread(A)
end
s1 = @async save_data(A)
a1 = @async trigger_thread(A)
close(A.data)
img = [take!(A.data) for i=1:256]

chnl1 = map(first,img)


using JLD2
y = @eval readdir(joinpath(homedir(),".gingerlab"))
y = jldopen("C:/Users/jarrison/.gingerlab/gl_jl_E48D.tmp.jld2")

display(y)
