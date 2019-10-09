module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")

export GageCard, get_configs!, get_systeminfo!, free_system

end
