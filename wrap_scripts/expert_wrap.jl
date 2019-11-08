using Clang
include("generate_gage.jl")

gage_path = joinpath(ENV["PROGRAMFILES(X86)"], "Gage", "Compuscope", "include")
hdrs = [joinpath(@__DIR__, "expert.h")]
gcc_include = "C:\\Users\\jarrison\\scoop\\apps\\nuwen-mingw-gcc\\8.2.0\\x86_64-w64-mingw32\\include"
gcc_include2 = "C:\\Users\\jarrison\\scoop\\apps\\nuwen-mingw-gcc\\8.2.0\\include"


clang_args = ["-ferror-limit 19 ",
"-fmessage-length 120 ",
"-fno-use-cxa-atexit ",
"-fms-extensions",
"-fms-compatibility",
"-fms-compatibility-version=19.11",
"-fdelayed-template-parsing",
"-fobjc-runtime=gcc",
"-fdiagnostics-show-option",
"-cc1",
"-triple x86_64-pc-windows-gnu",
"-E",
"-mthread-model posix",
"-fmath-errno",
"-masm-verbose",
"-mconstructor-aliases",
"-munwind-tables",
"-target-cpu x86-64",
"-dwarf-column-info",
"-momit-leaf-frame-pointer",
"-v"]


wc = Clang.init(
    headers = hdrs,
    output_file = "wexpert.jl",
    common_file = "wdefines.jl",
    clang_args = vcat("-xc++","-cxx-isystem","C:\\Users\\jarrison\\scoop\\apps\\nuwen-mingw-gcc\\current\\include",
"-v" ,"-masm-verbose","-mconstructor-aliases","-munwind-tables",clang_args),
    header_library = x -> ":CsSsm",
    clang_includes = vcat(gage_path,ENV["CPLUS_INCLUDE_PATH"],gcc_include, gcc_include2),
    header_wrapped = (root,current)-> startswith(splitdir(current)[2],r"CsT|CsE"),
    clang_diagnostics = true,
)
wc.options.ismutable = true

generate(wc)
