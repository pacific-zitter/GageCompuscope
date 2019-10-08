using Clang
using Queryverse, Lazy

hdr = joinpath(
    ENV["PROGRAMFILES(X86)"],
    "Gage/compuscope/include/CsStruct.h",
) |> normpath

gage_include = splitdir(hdr)[1]

xunit = parse_header(hdr; args = vcat("-xc++","-I",gage_include,"-femit-all-decls",
    ))


root = getcursor(xunit)
q=search(root,"CSCHANNELCONFIG")[1]

children(q)[1]

|> clang2julia



q[1][1] |> clang2julia


allchildren = children(root)
begin #show header
    astdf = DataFrame()
    astdf.canon = repr.(allchildren) .|> string
    astdf.filenames = Clang.filename.(allchildren) .|> splitdir .|> x->getindex(x,2)
    astdf.children = map(children.(allchildren)) do childs
            map(childs) do child
                nm = spelling(child)
                typ = canonical(child)
                string(nm,typ)
            end |> join
        end
    astdf.julia = clang2julia.(allchildren)
    electrondisplay(astdf |> @filter(@> _.filenames startswith("Cs")))
end

methodswith(CLCursor) |> electrondisplay
