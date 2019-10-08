module LibGage
using CEnum

include(joinpath(@__DIR__, "..", "gen", "api_gage.jl"))

foreach(names(@__MODULE__,all=true)) do s
    if any(string(s) .== ["eval","include"]) == false
        @eval export $s
    end
end

end
