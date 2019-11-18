using Clang

gpath = ENV["GAGEDIR"]
GINC = joinpath(gpath, "include")
hdrs = [joinpath(GINC, "CsPrototypes.h")]

args = vcat(
    "-I",
    "C:/scoop/apps/nuwen-mingw-gcc/current/x86_64-w64-mingw32/include",
    "-I",
    GINC,
    "-target",
    "x86_64-w64-mingw32",
    "-target-cpu x86_64",
    "-v",
    "-fdelayed-template-parsing"
)

wc = init(;headers = hdrs,
            clang_args= args,
            output_file="apii.jl",
            common_file="cmmn.jl",
            header_library=x->"CsSsm",
            header_wrapped = (root,current)-> startswith(splitpath(current)[end],"Cs"),
            clang_diagnostics = true)

run(wc);


# parse_headers!(ctx,wc.headers,args=wc.clang_args)
# # settings
# ctx.libname = "CsDisp"
# ctx.options["is_function_strictly_typed"] = false
# ctx.options["is_struct_mutable"] = false
#
# # write output
# api_file = joinpath(@__DIR__, "apii.jl")
# api_stream = open(api_file, "w")
#
# for trans_unit in ctx.trans_units
#     root_cursor = getcursor(trans_unit)
#     push!(ctx.cursor_stack, root_cursor)
#     header = spelling(root_cursor)
#     @info "wrapping header: $header ..."
#     # loop over all of the child cursors and wrap them, if appropriate.
#     ctx.children = children(root_cursor)
#     for (i, child) in enumerate(ctx.children)
#         child_name = name(child)
#         child_header = filename(child)
#         ctx.children_index = i
#         # choose which cursor to wrap
#         startswith(child_name, "__") && continue  # skip compiler definitions
#         child_name in keys(ctx.common_buffer) && continue  # already wrapped
#         child_header != header && continue  # skip if cursor filename is not in the headers to be wrapped
#
#         wrap!(ctx, child)
#     end
#     @info "writing $(api_file)"
#     println(api_stream, "# Julia wrapper for header: $(basename(header))")
#     println(api_stream, "# Automatically generated using Clang.jl\n")
#     print_buffer(api_stream, ctx.api_buffer)
#     empty!(ctx.api_buffer)  # clean up api_buffer for the next header
# end
# close(api_stream)
#
# # write "common" definitions: types, typealiases, etc.
# common_file = joinpath(@__DIR__, "cmmn.jl")
# open(common_file, "w") do f
#     println(f, "# Automatically generated using Clang.jl\n")
#     print_buffer(f, dump_to_buffer(ctx.common_buffer))
# end

# uncomment the following code to generate dependency and template files
# copydeps(dirname(api_file))
# print_template(j
