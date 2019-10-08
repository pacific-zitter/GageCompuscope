module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "gen", "LibGage.jl"))
using .LibGage

include("higher.jl")

foreach(names(@__MODULE__, all = true, imported = false)) do s
    if match(r"eval|include"i,string(s)) isa Nothing
        @eval export $s
    end
end

end
