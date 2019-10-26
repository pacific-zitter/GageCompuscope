const EXFX_DISK_STREAM_MASK = 0x60000000

# DiskStream: Initialize the subsystem
const EXFN_DISK_STREAM_INITIALIZE = 10 | EXFX_DISK_STREAM_MASK
# DiskStream: Start capturing and transferring data
const EXFN_DISK_STREAM_START = 11 | EXFX_DISK_STREAM_MASK
# DiskStream: Retrieve whether or not we're finished
const EXFN_DISK_STREAM_STATUS = 12 | EXFX_DISK_STREAM_MASK
# DiskStream: Abort any pending captures, transfers or writes
const EXFN_DISK_STREAM_STOP = 13 | EXFX_DISK_STREAM_MASK
# DiskStream: Close the subsystem and clean up an allocated resources
const EXFN_DISK_STREAM_CLOSE = 14 | EXFX_DISK_STREAM_MASK
# DiskStream: Return the number of acquisitions performed so far
const EXFN_DISK_STREAM_ACQ_COUNT = 15 | EXFX_DISK_STREAM_MASK
# DiskStream: Return the number of completed file writes so far
const EXFN_DISK_STREAM_WRITE_COUNT = 16 | EXFX_DISK_STREAM_MASK
# DiskStream: Return the last error
const EXFN_DISK_STREAM_ERRORS = 17 | EXFX_DISK_STREAM_MASK
# DiskStream: Flag to enable timing statistics
const EXFN_DISK_STREAM_TIMING_FLAG = 18 | EXFX_DISK_STREAM_MASK
# DiskStream: Return the timing statistics, if available
const EXFN_DISK_STREAM_TIMING_STATS = 19 | EXFX_DISK_STREAM_MASK


Base.@kwdef mutable struct DiskStream
    # size of this structure
    size::Cuint
    # Must be one of the EXFN_DISK_STREAM_XXXX commands
    actionId::Cuint
    # Time (in milliseconds) to wait before forcing a trigger
    timeout::Cuint
    # Address at which to start transferring the data
    xferStart::Int64
    # Length of data (in samples) to transfer
    xferLen::Int64
    # Which segment to start transfer from (single record transfers should be set to 1)
    recStart::Cuint
    # How many segments to transfer (single record transfers should be set to 1)
    recCount::Cuint
    # How many acquisitions to perform
    acqNum::Cuint
    # Returns how many files will be created for each channel
    filesPerChannel::Cuint
    # Flag to determine if the trigger time stamp should be set in the header comment field
    timeStamp::Cint
    # Time (in milliseconds) in which to check whether or not all acquisitions and writes are finished
    statusTimeout::Cuint
    # Number of channels to transfer
    channelCount::Cuint
    # List of which channels to transfer, the first ChannelCount values in the array are used
    chanList::NTuple{16,Cushort}
    # Name of base folder to store files. Relative paths are stored below the current directory
    path::NTuple{256,Cchar}
end


function pathtoconstantarray(path)
    path = transcode(Cushort, path)
    ntuple(x->x <= length(path) ? path[x] : 0, 256)
end

function initialize_stream(g::GageCard; path = nothing)
    if !isnothing(path)
        savdir = normpath(path)
    else
        savdir = mktempdir(; prefix = "gingergage_", cleanup = true)
    end

    dcfg = DiskStream(
        ;
        size = sizeof(DiskStream),
        actionId = EXFN_DISK_STREAM_INITIALIZE,
        timeout = 0,
        xferStart = 0,
        xferLen = 0,
        recStart = 1,
        recCount = 1,
        acqNum = 1,
        filesPerChannel = 0,
        timeStamp = 0,
        statusTimeout = 0,
        channelCount = 2,
        chanList = ntuple(x->x, 16),
        path = ntuple(x->0x0, 256),)
    dcfg.path = pathtoconstantarray(mktempdir(; prefix = "gagegingerlab_"))
    st = CsExpertCall(gage.gagehandle, dcfg)
end
