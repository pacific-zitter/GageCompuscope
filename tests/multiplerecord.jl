using GageCompuscope
using TimerOutputs
gage = GageCard()

begin #Settings and structure initialization.
    A = gage.acquisition_config

    A.SampleRate = 2e8
    A.TriggerHoldoff = 0
    A.SegmentSize = A.Depth = 8192
    A.Mode = CS_MODE_SINGLE
    A.SegmentCount = 1
    c1 = gage.channel_config[1]
    c1.Term = CS_COUPLING_DC
    c1.Filter = 0
    c1.Impedance = CS_REAL_IMP_50_OHM
    c1.InputRange = CS_GAIN_1_V
    CsSet(gage)
    st = commit(gage)
    st < 0 && error(cserror(st))
end

C1 = MultipleRecord(gage)

start(gage)
timedwait(()->get_status(gage)<1,10.0)
const to = TimerOutput()



C1(1)
