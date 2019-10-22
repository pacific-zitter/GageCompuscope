using GageCompuscope
using GageCompuscope.LibGage

gage = GageCard(0)


Base.@kwdef mutable struct DiskStream
    size::Cuint# size of this structure
    actionId::Cuint# Must be one of the EXFN_DISK_STREAM_XXXX commands
    timeout::Cuint# Time (in milliseconds) to wait before forcing a trigger
    xferStart::Clonglong# Address at which to start transferring the data
    xferLen::Clonglong# Length of data (in samples) to transfer
    recStart::Cuint# Which segment to start transfer from (single record transfers should be set to 1)
    recCount::Cuint# How many segments to transfer (single record transfers should be set to 1)
    acqNum::Cuint# How many acquisitions to perform
    filesPerChannel::Cuint                 # Returns how many files will be created for each channel
    timeStamp::Cint# Flag to determine if the trigger time stamp should be set in the header comment field
    statusTimeout::Cuint# Time (in milliseconds) in which to check whether or not all acquisitions and writes are finished
    channelCount::Cuint# Number of channels to transfer
    chanList::NTuple{16,Cushort}# List of which channels to transfer, the first ChannelCount values in the array are used
#TODO: This  if you pass an object pointer    # path::NTuple{256,Cwchar_t} # Name of base folder to store files. Relative paths are stored below the current directory

end

dcfg = DiskStream(
    ;
    size = sizeof(DiskStream),
    actionId = 10 | 0x60000000,
    timeout = 0,
    xferStart = 0,
    xferLen = 0,
    recStart = 1,
    recCount = 1,
    acqNum = 1,
    filesPerChannel = 1,
    timeStamp = 0,
    statusTimeout = 0,
    channelCount = 2,
    chanList = ntuple(x -> x, 16),
    path = ntuple(x -> Cushort(0), 256),
)

function pathtoconstantarray(path)
    path = transcode(Cushort, path)
    ntuple(x -> x <= length(path) ? path[x] : 0, 256)
end
dcfg.path = pathtoconstantarray(raw"C:\\Users\\pacific-zitter")

st = CsExpertCall(gage.gagehandle, pointer_from_objref(dcfg))

for i=1:1024
    dcfg.size = i
    st = CsExpertCall(gage.gagehandle, pointer_from_objref(dcfg))
    println(cserror(st),i)
end
println(cserror(st))
