abstract type CsConfig end
abstract type CsData end

@kwdef mutable struct BoardInfo <: CsConfig
    Size::UInt32 = size
    BoardIndex::UInt32
    BoardType::UInt32
    strSerialNumber::NTuple{32,UInt8}
    BaseBoardVersion::UInt32
    BaseBoardFirmwareVersion::UInt32
    AddonBoardVersion::UInt32
    AddonBoardFirmwareVersion::UInt32
    AddonFwOptions::UInt32
    BaseBoardFwOptions::UInt32
    AddonHwOptions::UInt32
    BaseBoardHwOptions::UInt32
end

@kwdef mutable struct SystemInfo <: CsConfig
    Size                ::UInt32 = sizeof(CSSYSTEMINFO)
    MaxMemory           ::Clonglong = 0
    SampleBits          ::UInt32 = 0
    SampleResolution    ::Int32 = 0
    SampleSize          ::UInt32 = 0
    SampleOffset        ::Int32 = 0
    BoardType           ::UInt32 = 0
    strBoardName        ::NTuple{32,UInt8} = ntuple(i->0x0,32)
    AddonOptions        ::UInt32 = 0
    BaseBoardOptions    ::UInt32 = 0
    TriggerMachineCount ::UInt32 = 0
    ChannelCount        ::UInt32 = 0
    BoardCount          ::UInt32 = 0
end

@kwdef mutable struct AcquisitionCfg <: CsConfig
    Size::UInt32 = sizeof(CSACQUISITIONCONFIG)
    SampleRate::Clonglong = 0
    ExtClk::UInt32 = 0
    ExtClkSampleSkip::UInt32 = 0
    Mode::UInt32 = 0
    SampleBits::UInt32 = 0
    SampleRes::Int32 = 0
    SampleSize::UInt32 = 0
    SegmentCount::UInt32 = 0
    Depth::Clonglong = 0
    SegmentSize::Clonglong = 0
    TriggerTimeout::Clonglong = 0
    TrigEnginesEn::UInt32 = 0
    TriggerDelay::Clonglong = 0
    TriggerHoldoff::Clonglong = 0
    SampleOffset::Int32 = 0
    TimeStampConfig::UInt32 = 0
end


@kwdef mutable struct ChannelCfg <: CsConfig
    Size::UInt32 = sizeof(CSCHANNELCONFIG)
    ChannelIndex::UInt32 = 0
    Term::UInt32 = 0
    InputRange::UInt32 = 0
    Impedance::UInt32 = 0
    Filter::UInt32 = 0
    DcOffset::Int32 = 0
    Calib::Int32 = 0
end

ChannelCfg(channel) = begin
    o = ChannelCfg()
    o.ChannelIndex = channel
    return o
end

@kwdef mutable struct TriggerCfg <: CsConfig
    Size::UInt32 = sizeof(TriggerCfg)
    TriggerIndex::UInt32 = 0
    Condition::UInt32 = 0
    Level::Int32 = 0
    Source::Int32 = 0
    ExtCoupling::UInt32 = 0
    ExtTriggerRange::UInt32 = 0
    ExtImpedance::UInt32 = 0
    Value1::Int32 = 0
    Value2::Int32 = 0
    Filter::UInt32 = 0
    Relation::UInt32 = 0
end

TriggerCfg(number) = begin
    o = TriggerCfg()
    o.TriggerIndex = number
    return o
end

@kwdef mutable struct InputParameters <: CsData
    Channel::Cushort
    Mode::Cuint = TxMODE_DEFAULT
    Segment::Cuint = 1
    StartAddress::Int64 = 0
    Length::Int64 = 0
    pDataBuffer::Ptr{Cvoid} = C_NULL
    # hNotifyEvent::Ptr{Ptr{Cvoid}}
end

# Base.convert(::Type{IN_PARAMS_TRANSFERDATA}, i::InputParamaters) =


@kwdef mutable struct OutputParameters <: CsData
    ActualStart::Clonglong = 0
    ActualLength::Clonglong = 0
    LowPart::Int32 = 0
    HighPart::Int32 = 0
end

@kwdef mutable struct InputExpert <: CsData
    Channel::UInt16 = 0
    Mode::UInt32 = 0
    StartSegment::UInt32 = 0
    SegmentCount::UInt32 = 0
    StartAddress::Clonglong = 0
    Length::Clonglong = 0
    pDataBuffer::Ptr{Cvoid} = C_NULL
    BufferLength::Clonglong = 0
end

@kwdef mutable struct OutputExpert
    DataFormat0::UInt32
    DataFormat1::UInt32
end

@kwdef mutable struct CallbackData
    Size::UInt32
    hSystem::UInt32
    ChannelIndex::UInt32
    Token::Int32
end

@kwdef mutable struct Timestamp
    Hour::UInt16
    Minute::UInt16
    Second::UInt16
    Point1Second::UInt16
end

@kwdef mutable struct SigFile
    Size::UInt32
    SampleRate::Clonglong
    RecordStart::Clonglong
    RecordLength::Clonglong
    RecordCount::UInt32
    SampleBits::UInt32
    SampleSize::UInt32
    SampleOffset::Int32
    SampleRes::Int32
    Channel::UInt32
    InputRange::UInt32
    DcOffset::Int32
    TimeStamp::CSTIMESTAMP
end

@kwdef mutable struct SigHeader
    cData::NTuple{512,UInt8}
end

@kwdef mutable struct SegmentTail
    TimeStamp::Clonglong
    Reserved0::Clonglong
    Reserved1::Clonglong
    Reserved2::Clonglong
end

@kwdef mutable struct StreamFileheader
    Size::UInt32
    FileVersion::UInt32
    BlockSize::UInt32
    HeaderSize::UInt32
    DataSize::Clonglong
    FooterSize::UInt32
    szBoardName::NTuple{32,UInt8}
    szSerialNumber::NTuple{32,UInt8}
    szUserDescription::NTuple{256,UInt8}
    Dataformat::UInt32
    u8NbOfChannels::UInt8
    u8NbOfTrigEn::UInt8
    AcqConfig::CSACQUISITIONCONFIG
end

@kwdef mutable struct StreamHeader
    Size::UInt32
    CardIndex::UInt16
    NbOfChannels::UInt32
    NbOfTriggers::UInt32
    TailSize::UInt32
    StartSegment::Culonglong
    SegmentOffset::Culonglong
    StartPoint::Culonglong
    EndPoint::Culonglong
    CSystemInfo::CSSYSTEMINFO
    szDescription::NTuple{256,UInt8}
    CsAcqConfig::CSACQUISITIONCONFIG
end

# @kwdef mutable struct TRIGGERED_INFO_STRUCT
#     Size::UInt32
#     StartSegment::UInt32
#     NumOfSegments::UInt32
#     BufferSize::UInt32
#     pBuffer::Ptr{Int16}
# end
#
# @kwdef mutable struct CSPECONFIG
#     Size::UInt32
#     Enable::UInt32
#     InputType::UInt32
#     EncodeMode::UInt32
#     Step::UInt32
#     Offset::UInt32
# end
#
# @kwdef mutable struct CS_STRUCT_DATAFORMAT_INFO
#     Size::UInt32
#     Signed::UInt32
#     Packed::UInt32
#     SampleBits::UInt32
#     SampleSize_Bits::UInt32
#     SampleOffset::Int32
#     i32SampleRes::Int32
# end
