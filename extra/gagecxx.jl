using Cxx

gagepath = joinpath(ENV["PROGRAMFILES(X86)"],"Gage","Compuscope","include") |>
    normpath

edit(joinpath(DEPOT_PATH[1],"packages","Cxx","dYc90","src","bootstrap.cpp"))
