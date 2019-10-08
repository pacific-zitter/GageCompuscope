using Clang
include("generate_gage.jl")

gage_path = joinpath(ENV["PROGRAMFILES(X86)"], "Gage", "Compuscope", "include")
hdrs = [joinpath(gage_path, "CsPrototypes.h")]

function shouldwrap(root, current)
    hname = splitdir(current)[end]
    startswith(hname, "Cs") && !startswith(hname, r"CsErro")
end

wc = Clang.init(
    headers = hdrs,
    output_file = joinpath(@__DIR__, "..", "gen", "api_gage.jl"),
    common_file = joinpath(@__DIR__, "..", "gen", "common_gage.jl"),
    clang_args = ["-xc++", "-v", "-I", gage_path],
    header_library = x -> ":CsSsm",
    clang_includes = vcat(gage_path, LLVM_INCLUDE, CLANG_INCLUDE),
    header_wrapped = shouldwrap,
    clang_diagnostics = true,
)

wc.options.wrap_structs = true
wc.options.ismutable = true

generate(wc)
