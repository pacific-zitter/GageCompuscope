using GageCompuscope
using GageCompuscope.LibGage
using BenchmarkTools
gage = GageCard(0)

set_samplerate(gage, 10^7)
set_segmentsize(gage, 10000)
set_segmentcount(gage,1000)
gage.trigger_config[1].Level = 5
commit(gage)

xfer = MultipleTransfer(gage)
function one_acq(g,x)
    start(g)
    until_ready(g)
    t1 = time_ns()
    transfer_multiplerecord(g,x)
    (time_ns() - t1)*1e-9 # s
end

free_system(gage)
