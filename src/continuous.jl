using GageCompuscope
using GageCompuscope.LibGage
using Observables
using Observables: @on, @map, @map!
import Signals

gage = GageCard(0)
acquisition = gage.acquisition_config
channel = gage.channel_config
triggers = gage.trigger_config

set_segmentsize(gage,10^7)
set_samplerate(gage,10^7)

xfer = Transfer(gage)

A = Channel(32)
B = Channel(32)

function doacq(acquired::Channel)
    acquisition_count=4
    for n in 1:acquisition_count
        start(gage)
        st=until_ready(gage)
        put!(acquired,st)
        @info "$n Acquired."
    end
end

function dotransfer(c::Channel)
    while true
        take!(c)
        @sync transfer_data(gage,xfer)
        put!(B,xfer.segment_buffer)
    end
end

@async doacq(A)
dotransfer(A)


BB = B.data
