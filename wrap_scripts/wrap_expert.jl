using Clang
using CBindingGen
gpath = ENV["GAGEDIR"]
GINC = joinpath(gpath, "include")
hdrs = ["C:/Users/pacific-zitter/Documents/gati-linux-driver/Include/Private/CsDisp.h"]

ctx = ConverterContext(["CsDisp"]) do decl
    header = filename(decl)
    name = spelling(decl)

# ignore anything not in the library's headers, e.g. "LibExample/hdr1.h"
    any(
        hdr -> endswith(header, joinpath("Compuscope", "include", hdr)),
        hdrs,
    ) || return false

# ignore the particular functions listed below (usually because they are in a header but not exposed with the library)
    decl isa CLFunctionDecl &&
    name in ("missing1", "missing2") && return false

# ignore functions, variables, and macros starting with double-underscore
    startswith(name, "__") &&
    (decl isa CLFunctionDecl ||
     decl isa CLVarDecl || decl isa CLMacroDefinition) && return false

    return true
end

parse_headers!(
    ctx,
    hdrs,
    args = [
        "-std=gnu99",
        "-DUSE_DEF=1",
        "-I",
        GINC,
        "-v",
        "-target",
        "-x86_64-pc-windows-gnu",
        "-cpu-target",
        "x86_64",
    ],
)
generate(ctx, joinpath(dirname(@__DIR__), "gen"), "example")
