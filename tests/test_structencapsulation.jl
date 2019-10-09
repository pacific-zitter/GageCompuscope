<<<<<<< HEAD
using GageCompuscope
import GageCompuscope.LibGage
using BenchmarkTools

gage = GageCard(0)
<<<<<<< Updated upstream
=======
using GageCompuscope

gage = GageCard(0)
>>>>>>> 29ef793a7e338feaebbe2e21b81b2d4c07aef89f
=======
xfer = Transfer(gage)
set_segmentsize(gage,1e6)
acquire(gage,xfer)


using JLD2

jldopen(mkdir()[1],"w") do file
    for i=1:1000
        acquire(gage,xfer)
        file["testitems/"*string(i)] = xfer.segment_buffer
    end
end
free_system(gage)
>>>>>>> Stashed changes
