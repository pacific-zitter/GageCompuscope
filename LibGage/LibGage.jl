module LibGage
using CEnum

include(joinpath(@__DIR__,"api_gage.jl"))

foreach(names(@__MODULE__,all=true)) do s
    occursin("eval" , string(s)) && return
    occursin("include", string(s)) && return

    @eval export $s

end

end
