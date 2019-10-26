using GageCompuscope
using GageCompuscope.LibGage
using Libdl
gage = GageCard(0)

Base.@kwdef mutable struct exIn
    Size::Cuint# size of this structure
    ActionId::Cuint# Must be EXFN_TRANSFER_RAWMULREC
    StartSegment::Cuint# Start segment number
    EndSegment::Cuint# End Segment number
    pBuffer::Ptr{Cvoid}# Buffer for Data
    BufferSize::Int64# Buffer Size in bytes
end

Base.@kwdef mutable struct exOut
    ActualBufferSize::Int64# Buffer Size in bytes
end

Base.@kwdef mutable struct TransferMulRec
    input::exIn
    output::exOut
end

const EXFN_RAWMULREC_TRANSFER = 9
r = Vector{Cushort}(undef, 8192)
hSystem, SegmentStart, SegmentCount, pRawDataBuffer, RawDataBufferSize = (gage.gagehandle, 1, 10, pointer(r), sizeof(r))
# function SaveMulRecRawData(
#     hSystem,
#     SegmentStart,
#     SegmentCount,
#     pRawDataBuffer,
#     RawDataBufferSize,
# )
sizeof(exIn) |> UInt

expert_params = TransferMulRec(exIn(Size = sizeof(TransferMulRec),
        ActionId = EXFN_RAWMULREC_TRANSFER,
        StartSegment = SegmentStart,
        EndSegment = SegmentStart + SegmentCount - 1,
        pBuffer = pRawDataBuffer,
        BufferSize = RawDataBufferSize,
    ),
    exOut(0),
)
ccall((:CsExpertCall, :CsSsm),
    Int32,
    (UInt32, Ptr{TransferMulRec}),
    hSystem,
    pointer_from_objref(expert_params),
) |> cserror
RawDataBufferSize = expert_params.output.ActualBufferSize#=*=#



SaveMulRecRawData(gage.gagehandle, 1, 10, pointer(r), sizeof(r))
