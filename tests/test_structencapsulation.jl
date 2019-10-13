using GageCompuscope
import GageCompuscope.LibGage
using BenchmarkTools

gage = GageCard(0)
xfer = Transfer(gage)
set_segmentsize(gage, 1e6)
acquire(gage, xfer)
