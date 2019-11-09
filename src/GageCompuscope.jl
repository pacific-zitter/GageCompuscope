module GageCompuscope
using Reexport
using CBinding
include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
@reexport using .LibGage
include("gage_functions.jl")
include("gagecard.jl")
include("transfer.jl")
include("asynctransfer.jl")
include("streamtodisk.jl")


export GageCard, start, free_system, set_samplerate, set_segmentcount,
  set_segmentsize,set_trigger!, get_status


end
