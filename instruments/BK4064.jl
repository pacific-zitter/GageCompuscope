module BK
using PyCall
pyvisa = pyimport_conda("pyvisa", "pyvisa", "conda-forge")
rm = pyvisa.ResourceManager()
r = rm.list_resources()
findfirst(occursin.(r"usb"i, r))
inst = rm.open_resource(r[findfirst(occursin.(r"usb"i, r))])


function setfgen()
    pyvisa = pyimport_conda("pyvisa", "pyvisa", "conda-forge")
    rm = pyvisa.ResourceManager()
    r = rm.list_resources()
    findfirst(occursin.(r"usb"i, r))
    inst = rm.open_resource(r[findfirst(occursin.(r"usb"i, r))])

    # Channel 1 output.
    inst.write("c1:outp on,load,50")
    inst.write("c1:bswv wvtp, sine")
    inst.write("c1:bswv amp, 1Vpp")
    # inst.write("c1:bswv frq, 75e3")
    inst.write("c1:bswv frq, 1e6")

    # Channel 2 output.
    inst.write("c2:outp on,load,50")
    inst.write("c2:bswv wvtp, SINE")
    inst.write("c2:bswv amp, 1Vpp")
    inst.write("c2:bswv frq, 75e3")
end
setfgen()
inst.query("c1:bswv?")

inst.query("c1:outp?")
end
