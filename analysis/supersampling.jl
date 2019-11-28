using Transducers
    using DSP
    using PyCall
    using GageCompuscope
    using Plots;gr()


gage = GageCard()

A = gage.acquisition_config
C1 = gage.channel_config[1]
C2 = gage.channel_config[2]

A["SegmentSize"] = A["Depth"] = 16384
A["Mode"] = CS_MODE_DUAL
CsDo(gage.gagehandle,ACTION_CALIB)
C2.InputRange = C1.InputRange= CS_GAIN_2_V

CsSet(gage)

commit(gage)

pyvisa = pyimport_conda("pyvisa","pyvisa","conda-forge")
rm = pyvisa.ResourceManager()
r = rm.list_resources()
findfirst(occursin.(r"usb"i,r))
inst = rm.open_resource(r[findfirst(occursin.(r"usb"i,r))])

inst.query("*IDN?")
inst.write("*RST")

inst.query("c1:bswv?")
inst.write("c1:bswv wvtp, arb")
inst.write("c1:arwv name, SNR")

inst.write("c1:bswv amp, 2Vpp")
inst.write("c1:bswv frq, 75e3")
inst.write("c1:outp on,load,50")
inst.query("c1:outp?")

inst.query("c2:bswv?")
inst.write("c2:bswv wvtp, arb")
inst.write("c2:arwv name, SNR")

inst.write("c2:bswv amp, 2Vpp")
inst.write("c2:bswv frq, 75e3")
inst.write("c2:outp on,load,50")
inst.query("c2:outp?")


Chnl1 = MultipleRecord(gage)
Chnl2 = MultipleRecord(gage)
start(gage)
timedwait(()->get_status(gage)<1,10.0)
data1 = Chnl1(1) |> Array |> vec
data2 = Chnl2(2) |> Array |> vec
t = range(0,1.,length=16384)
voltage1 = to_voltage(data1,A["SampleOffset"],A["SampleRes"],C1["InputRange"],0)
voltage2 = to_voltage(data2,A["SampleOffset"],A["SampleRes"],C2["InputRange"],0)
