abstract type CsConfig end
abstract type CsData end

@kwdef mutable struct BoardInfo <: CsConfig
    Size::UInt32 = 0
    BoardIndex::UInt32 = 0
    BoardType::UInt32 = 0
    strSerialNumber::NTuple{32,UInt8}
    BaseBoardVersion::UInt32 = 0
    BaseBoardFirmwareVersion::UInt32 = 0
    AddonBoardVersion::UInt32 = 0
    AddonBoardFirmwareVersion::UInt32 = 0
    AddonFwOptions::UInt32 = 0
    BaseBoardFwOptions::UInt32 = 0
    AddonHwOptions::UInt32 = 0
    BaseBoardHwOptions::UInt32 = 0
end

@kwdef mutable struct SystemInfo <: CsConfig
    Size::UInt32 = sizeof(CSSYSTEMINFO)
    MaxMemory::Clonglong = 0
    SampleBits::UInt32 = 0
    SampleResolution::Int32 = 0
    SampleSize::UInt32 = 0
    SampleOffset::Int32 = 0
    BoardType::UInt32 = 0
    strBoardName::NTuple{32,UInt8} = ntuple(i -> 0x0, 32)
    AddonOptions::UInt32 = 0
    BaseBoardOptions::UInt32 = 0
    TriggerMachineCount::UInt32 = 0
    ChannelCount::UInt32 = 0
    BoardCount::UInt32 = 0
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

@kwdef struct MultipleRecord
    handle::Cuint
    data_array::Array{Int16,2}
    input_gage::IN_PARAMS_TRANSFERDATA
    output_gage::OUT_PARAMS_TRANSFERDATA
end

@kwdef mutable struct InputExpert <: CsData
    Channel::UInt16 = 0
    Mode::UInt32 = 0
    StartSegment::UInt32 = 0
    SegmentCount::UInt32 = 0
    StartAddress::Clonglong = 0
    Length::Clonglong = 0
    pDataBuffer::Ptr{Cshort} = C_NULL
    BufferLength::Clonglong = 0
    notify_event::Ptr{Cvoid} = C_NULL
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


function Base.convert(::Type{CSACQUISITIONCONFIG},x::AcquisitionCfg)
    a = Int64[]
    foreach(fieldnames(AcquisitionCfg)) do f_name
        push!(a,getfield(x,f_name))
    end
    CSACQUISITIONCONFIG(a...)
end
function Base.convert(::Type{CSCHANNELCONFIG},x::ChannelCfg)
    a = Int64[]
    foreach(fieldnames(ChannelCfg)) do f_name
        push!(a,getfield(x,f_name))
    end
    CSCHANNELCONFIG(a...)
end
function Base.convert(::Type{CSTRIGGERCONFIG},x::TriggerCfg)
    a = Int64[]
    foreach(fieldnames(TriggerCfg)) do f_name
        push!(a,getfield(x,f_name))
    end
    CSTRIGGERCONFIG(a...)
end
