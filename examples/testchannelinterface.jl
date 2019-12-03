Base.include(@__MODULE__,joinpath(@__DIR__,"initgage_default.jl"))
using GageCompuscope: Acquire, untilReady, transfer_thread, trigger_thread
gage
A = Acquire(gage,1024)

x1 = @async transfer_thread(A)

a1 = @async trigger_thread(A)

y = A.data |> collect

using Plots

ch1 = map(first,y)
ch2 = map(last,y)
p1 = plot(ch1[1])
p2 = plot(ch2[2])

p3 = plot(p1,p2,layout=(2,1))
