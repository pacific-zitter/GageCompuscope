module LibGage
using Base: @kwdef

include("defines_gage.jl")
include("common_gage.jl")
include(joinpath(@__DIR__, "api_gage.jl"))

foreach(names(@__MODULE__, all = true)) do s
    occursin("eval", string(s)) && return
    occursin("include", string(s)) && return
    @eval export $s
end

end
