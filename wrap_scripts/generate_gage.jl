function generate(wc::WrapContext;generate_template=false)
    # parse headers
    ctx = DefaultContext(wc.index)
    parse_headers!(
        ctx,
        wc.headers,
        args = wc.clang_args,
        includes = wc.clang_includes,
    )
    ctx.options["is_function_strictly_typed"] = false
    ctx.options["is_struct_mutable"] = wc.options.ismutable
    # Helper to store file handles
    filehandles = Dict{String,IOStream}()
    getfile(f) =
        (f in keys(filehandles)) ? filehandles[f] :
        (filehandles[f] = open(f, "w"))

    for trans_unit in ctx.trans_units
        root_cursor = getcursor(trans_unit)
        push!(ctx.cursor_stack, root_cursor)
        header = spelling(root_cursor)
        @info "wrapping header: $header ..."

        # loop over all of the child cursors and wrap them, if appropriate.
        ctx.children = children(root_cursor)
        for (i, child) in enumerate(ctx.children)
            child_name = name(child)
            child_header = filename(child)
            ctx.children_index = i
            # what should be wrapped:
            #   1. wrap if context.header_wrapped(header, child_header) == True
            #   2. wrap if context.cursor_wrapped(cursor_name, cursor) == True
            #   3. skip compiler defs and cursors already wrapped
            if !wc.header_wrapped(header, child_header) ||
               !wc.cursor_wrapped(child_name, child) ||       # client callbacks
               startswith(child_name, "__") ||       # skip compiler definitions
               child_name in keys(ctx.common_buffer)          # already wrapped
                continue
            end
            ctx.libname = wc.header_library(child_header)

            try
                wrap!(ctx, child)
            catch err
                push!(ctx.cursor_stack, child)
                @info "error thrown. Last cursor available in context.cursor_stack."
                # rethrow(err)
            end
        end

        # apply user-supplied transformation
        wc.rewriter(ctx.api_buffer)

        # write output
        out_file = wc.header_outputfile(header)
        @info "writing $(out_file)"

        out_stream = getfile(out_file)
        println(out_stream, "# Julia wrapper for header: $(basename(header))")
        println(out_stream, "# Automatically generated using Clang.jl\n")
        print_buffer(out_stream, ctx.api_buffer)
        ctx.api_buffer = Expr[]  # clean api_buffer for the next header
    end

    common_buf = dump_to_buffer(ctx.common_buffer)

    # apply user-supplied transformation
    common_buf = wc.rewriter(common_buf)

    # write "common" definitions: types, typealiases, etc.
    open(wc.common_file, "w") do f
        println(f, "# Automatically generated using Clang.jl\n")
        print_buffer(f, common_buf)
    end

    map(close, values(filehandles))

    if generate_template
        copydeps(dirname(wc.common_file))
        print_template(joinpath(dirname(wc.common_file), "LibTemplate.jl"))
    end
end
