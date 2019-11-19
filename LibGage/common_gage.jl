abstract type GageConfig end

mutable struct CSBOARDINFO
    Size::UInt32
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
mutable struct CSSYSTEMINFO
    Size::UInt32
    MaxMemory::Clonglong
    SampleBits::UInt32
    SampleResolution::Int32
    SampleSize::UInt32
    SampleOffset::Int32
    BoardType::UInt32
    strBoardName::NTuple{32,UInt8}
    AddonOptions::UInt32
    BaseBoardOptions::UInt32
    TriggerMachineCount::UInt32
    ChannelCount::UInt32
    BoardCount::UInt32
end

mutable struct CSACQUISITIONCONFIG
    Size::UInt32
    SampleRate::Clonglong
    ExtClk::UInt32
    ExtClkSampleSkip::UInt32
    Mode::UInt32
    SampleBits::UInt32
    SampleRes::Int32
    SampleSize::UInt32
    SegmentCount::UInt32
    Depth::Clonglong
    SegmentSize::Clonglong
    TriggerTimeout::Clonglong
    TrigEnginesEn::UInt32
    TriggerDelay::Clonglong
    TriggerHoldoff::Clonglong
    SampleOffset::Int32
    TimeStampConfig::UInt32
end

mutable struct CSCHANNELCONFIG
    Size::UInt32
    ChannelIndex::UInt32
    Term::UInt32
    InputRange::UInt32
    Impedance::UInt32
    Filter::UInt32
    DcOffset::Int32
    Calib::Int32
end

mutable struct CSTRIGGERCONFIG
    Size::UInt32
    TriggerIndex::UInt32
    Condition::UInt32
    Level::Int32
    Source::Int32
    ExtCoupling::UInt32
    ExtTriggerRange::UInt32
    ExtImpedance::UInt32
    Value1::Int32
    Value2::Int32
    Filter::UInt32
    Relation::UInt32
end

Base.@kwdef mutable struct IN_PARAMS_TRANSFERDATA
    Channel::Cushort = 1
    Mode::Cuint = TxMODE_DEFAULT
    Segment::Cuint = 1
    StartAddress::Clonglong = 0
    Length::Clonglong = 0
    pDataBuffer::Ptr{Cvoid} = C_NULL
    hNotifyEvent::Ptr{Cvoid} = C_NULL
end

Base.@kwdef mutable struct OUT_PARAMS_TRANSFERDATA
    ActualStart::Clonglong = 0
    ActualLength::Clonglong = 0
    LowPart::Int32 = 0
    HighPart::Int32 = 0
end

mutable struct IN_PARAMS_TRANSFERDATA_EX
    Channel::UInt16
    Mode::UInt32
    StartSegment::UInt32
    SegmentCount::UInt32
    StartAddress::Clonglong
    Length::Clonglong
    pDataBuffer::Ptr{Cvoid}
    BufferLength::Clonglong
end

mutable struct OUT_PARAMS_TRANSFERDATA_EX
    DataFormat0::UInt32
    DataFormat1::UInt32
end

mutable struct CALLBACK_DATA
    Size::UInt32
    hSystem::UInt32
    ChannelIndex::UInt32
    Token::Int32
end

mutable struct CSTIMESTAMP
    Hour::UInt16
    Minute::UInt16
    Second::UInt16
    Point1Second::UInt16
end

mutable struct CSSIGSTRUCT
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

mutable struct CSDISKFILEHEADER
    cData::NTuple{512,UInt8}
end

mutable struct CSSEGMENTTAIL
    TimeStamp::Clonglong
    Reserved0::Clonglong
    Reserved1::Clonglong
    Reserved2::Clonglong
end

mutable struct STREAMING_FILEHEADER
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

mutable struct STMHEADER
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

mutable struct TRIGGERED_INFO_STRUCT
    Size::UInt32
    StartSegment::UInt32
    NumOfSegments::UInt32
    BufferSize::UInt32
    pBuffer::Ptr{Int16}
end

mutable struct CSPECONFIG
    Size::UInt32
    Enable::UInt32
    InputType::UInt32
    EncodeMode::UInt32
    Step::UInt32
    Offset::UInt32
end

mutable struct CS_STRUCT_DATAFORMAT_INFO
    Size::UInt32
    Signed::UInt32
    Packed::UInt32
    SampleBits::UInt32
    SampleSize_Bits::UInt32
    SampleOffset::Int32
    i32SampleRes::Int32
end
