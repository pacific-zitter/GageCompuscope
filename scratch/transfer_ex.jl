using GageCompuscope
using GageCompuscope.LibGage

gage = GageCard(0)

Base.@kwdef mutable struct expertBuffer
    channel
    mode
    segment_start
    segment_count
    start_address
    signal_length
    data_buffer
    buffer_length
end

function expertBuffer(segment_start, nsegments, start_address, segsize, arr)
    expertBuffer(channel = 1,
        mode = TxMODE_DATA_INTERLEAVED,
        segment_start = segment_start,
        segment_count = nsegments,
        start_address = start_address,
        signal_length = segsize,
        data_buffer = pointer(arr),
        buffer_length = length(arr),
    )
end

db = Vector{UInt16}(undef, gage.acquisition_config.SegmentSize)
exB = expertBuffer(1, 1, -1, gage.acquisition_config.SampleSize, db)

mutable struct expertOutput
    top::Cuint
    bottom::Cuint
end

exO = expertOutput(0, 0)

i32Status = CsGetSystemCaps(gage.gagehandle, CAPS_TRANSFER_EX, C_NULL, 21)
cserror(i32Status)
