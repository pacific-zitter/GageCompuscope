module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")

export GageCard, Transfer, get_configs!, get_systeminfo!, free_system, start
export acquire, set_segmentsize, set_samplerate, get_gagestatus
export abort, force_trigger

end
