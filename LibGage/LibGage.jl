<<<<<<< HEAD
module LibGage
using CEnum

include(joinpath(@__DIR__,"api_gage.jl"))

foreach(names(@__MODULE__,all=true)) do s
    occursin("eval" , string(s)) && return
    occursin("include", string(s)) && return

    @eval export $s

end

end
=======
module LibGage
using CEnum

include(joinpath(@__DIR__,"api_gage.jl"))

foreach(names(@__MODULE__,all=true)) do s
    occursin("eval" , string(s)) && return
    occursin("include", string(s)) && return

    @eval export $s

end

end
>>>>>>> 29ef793a7e338feaebbe2e21b81b2d4c07aef89f
