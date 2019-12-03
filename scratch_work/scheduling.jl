using GageCompuscope
mutable struct GStream
    transfer_cond::Threads.Event
    acq_channel::Channel
end

function acquire_stream(G::GageCard, channel::Channel;tsleep=10e-6,nacquisitions=32)
    while true
        start(G)
        nr= @async while !dataReady(G)
            hybrid_sleep(tsleep)
        end
        wait(nr)
        put!(channel,:ok)
        wait(transferComplete)
    end
end


function acquire(AS::GStream,G::GageCard;tsleep=10e-6)
    while true
        start(G)
        nr= @async while !dataReady(G)
            hybrid_sleep(tsleep)
        end
        wait(nr)
        put!(AS.acq_channel,:ok)
        wait(AS.transfer_cond)
    end
end


gage= GageCard()
begin # settings.
    A = gage.acquisition_config
    channel1 = gage.channel_config[1]
    channel2 = gage.channel_config[2]
    A["SampleRate"] = 1e7
    A["SegmentSize"] = A["Depth"] = 128
    A["SegmentCount"] = 1
    A["Mode"] = CS_MODE_DUAL

    channel1.InputRange = channel2.InputRange = CS_GAIN_2_V
    channel2.Filter = channel1.Filter = CS_FILTER_ON

    #send values to driver and commit.
    CsSet(gage)
    commit(gage)
end

xfer(G::GageCard, acqChannel::Channel,dataOut::Channel;nchannels=2) = begin
    records = map(x->MultipleRecord(G),1:nchannels)
    while true

        take!(acqChannel)
        d = MultipleRecord[]
        for i in 1:nchannels
            push!(d,(records[i])(i))
        end

        put!(dataOut,d)

        notify(S.transfer_cond)
    end
end


S = GStream(Threads.Event(),Channel(8))
y1 = @async acquire(S,gage)


dChannel1= Channel(32)


F1 = @async xfer(gage,S.acq_channel,dChannel1)
