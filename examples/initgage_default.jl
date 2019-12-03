using GageCompuscope
const gage = GageCard()

begin # settings.
    A = gage.acquisition_config
    channel1 = gage.channel_config[1]
    channel2 = gage.channel_config[2]
    A["SegmentSize"] = A["Depth"] = 8192
    A["SegmentCount"] = 1
    A["Mode"] = CS_MODE_DUAL

    # channel1.InputRange = channel2.InputRange = CS_GAIN_2_V
    # channel2.Filter = channel1.Filter = CS_FILTER_OFF
    # channel1.Term = channel2.Term = CS_COUPLING_DC
    #send values to driver and commit.
    CsSet(gage)
    commit(gage)
end
