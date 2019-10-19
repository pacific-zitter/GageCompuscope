module GageCompuscope
using HDF5

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")
include("transfer.jl")
include("streaming.jl")
export GageCard, Transfer, get_configs!, get_systeminfo!, free_system, start
export set_cfg!, set_channel!, cserror
export acquire, set_segmentsize, set_samplerate, set_segmentcount
export abort, force_trigger, get_status, commit
export transfer_data, until_ready, MultipleTransfer, transfer_multiplerecord
# Streaming
export initiate_transfer, poll_transferstatus
end
