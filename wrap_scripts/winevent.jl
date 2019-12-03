using Clang


wc = init(;
    headers=[joinpath(@__DIR__,"cb.h")],
    output_file = "api.jl",
    common_file = "commn.jl",
    header_wrapped = (r,c) -> startswith(splitdir(c)[end],"sync"),
    clang_args = vcat("-v","-xc","-target","x86_64-pc-windows-gnu"),
    clang_includes = vcat(CLANG_INCLUDE,raw"C:\Users\jarrison\scoop\apps\gcc\current\lib\gcc\x86_64-w64-mingw32\8.1.0\include"),
    header_library = x->"kernel32"
    )

run(wc,false)