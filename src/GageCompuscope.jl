module GageCompuscope

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
using .LibGage

include("gagecard.jl")
include("transfer.jl")
include("asynctransfer.jl")
include("streamtodisk.jl")
foreach(names(@__MODULE__;all = true)) do s
    if !any(occursin.(["eval","#","var\"","include"], Ref(string(s))))
        @eval export $s
    end
end

end
