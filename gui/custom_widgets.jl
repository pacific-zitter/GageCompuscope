using Interact
using Interact.Widgets
using GageCompuscope
using NamedTupleTools

function gagestatus(g::GageCard)
    colors = OrderedDict(0=>"green",2=>"cyan",4=>"yellow")
    status = get_gagestatus(g) |> Observable

    @async while true
        sleep(0.2)
        status[] = get_gagestatus(g)
    end
    @manipulate for stat in status
        h, w = 100, 100

        attributes = Dict(
            "fill" => colors[stat],
            "points" => join(
                ["$(w/2*(1+cos(θ))),$(h/2*(1+sin(θ)))" for θ = 0:2π/100:2π],
                ' ',
            ),
        )
        dom"svg:svg[width=$w, height=$h]"(dom"svg:polygon"(attributes = attributes))
    end
end

acq_names = ntfromstruct(gage.acquisition_config) |> OrderedDict ∘ pairs


mm=tabulator(acq_names;key=:Size)
