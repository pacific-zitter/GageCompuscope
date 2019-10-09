<<<<<<< HEAD
module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")

export GageCard, get_configs!, get_systeminfo!, free_system

end
=======
module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")

export GageCard, get_configs!, get_systeminfo!, free_system

end
>>>>>>> 29ef793a7e338feaebbe2e21b81b2d4c07aef89f
