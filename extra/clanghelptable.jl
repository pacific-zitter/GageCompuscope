using ElectronDisplay
using Query, DataFrames
using Lazy

function getclanghelp()
    @> clanghelp = readlines(`clang --help`)
    for (i, line) in enumerate(clanghelp)
        if startswith(line, r"\s{3,}+")
            clanghelp[i-1] *= string(line)
            clanghelp[i] = "  nothing"
        end
    end

    clanghelp = [ch for ch in clanghelp if ch != "  nothing"]


    q = map(clanghelp) do ch
        m = match(r"(\-?\-[a-zA-Z\-]*(\<arg\>)?)(\s+)(.*)", ch)
        isnothing(m) ? Nothing : [m[1], m[4]]
    end

    ch = [qq for qq in q if qq !== Nothing]

    helpf = DataFrame()
    helpf.flag = [string(getindex(gg, 1)) for gg in ch]
    helpf.doc = [string(getindex(gg, 2)) for gg in ch]
    helpf
end

help = getclanghelp()
electrondisplay(help)
