# Automatically generated using Clang.jl
@cenum _CSFILETYPES::UInt32 begin
    cftNone = 0
    cftBinaryData = 1
    cftSigFile = 2
    cftAscii = 3
end

const CsFileType = _CSFILETYPES

@cenum _CSFILEMODES::UInt32 begin
    cfmRead = 1
    cfmWrite = 2
    cfmReadWrite = 3
end

const CsFileMode = _CSFILEMODES

@cenum _CSFILEATTACH::UInt32 begin
    fmNew = 0
end

const CsFileAttach = _CSFILEATTACH

@cenum CsCaptureMode::UInt32 begin
    MemoryMode = 0
    StreamingMode = 1
end

@cenum CsDataPackMode::UInt32 begin
    DataUnpack = 0
    DataPacked_8 = 1
    DataPacked_12 = 2
end

const EVENT_Ptr{Cvoid} = Ptr{Cvoid}
const SEM_Ptr{Cvoid} = Ptr{Cvoid}
const MUTEX_Ptr{Cvoid} = Ptr{Cvoid}
const FILE_Ptr{Cvoid} = Ptr{Cvoid}

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

const PCSBOARDINFO = Ptr{CSBOARDINFO}

mutable struct ARRAY_BOARDINFO
    BoardCount::UInt32
    aBoardInfo::NTuple{1,CSBOARDINFO}
end

const PARRAY_BOARDINFO = Ptr{ARRAY_BOARDINFO}

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

CSSYSTEMINFO() = begin
    o = CSSYSTEMINFO(zeros(7)..., ntuple(x->0, 32), zeros(5)...)
    o.Size = sizeof(CSSYSTEMINFO)
    return o
end


const PCSSYSTEMINFO = Ptr{CSSYSTEMINFO}

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
    # SegmentCountHigh::Int32
end

CSACQUISITIONCONFIG() = begin
    o = CSACQUISITIONCONFIG(zeros(fieldcount(CSACQUISITIONCONFIG))...)
    o.Size = sizeof(CSACQUISITIONCONFIG)
    return o
end

const PCSACQUISITIONCONFIG = Ptr{CSACQUISITIONCONFIG}

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
CSCHANNELCONFIG(channel) = begin
    o = CSCHANNELCONFIG(zeros(fieldcount(CSCHANNELCONFIG))...)
    o.Size = sizeof(CSCHANNELCONFIG)
    o.ChannelIndex = channel
    return o
end
const PCSCHANNELCONFIG = Ptr{CSCHANNELCONFIG}

mutable struct ARRAY_CHANNELCONFIG
    ChannelCount::UInt32
    aChannel::NTuple{1,CSCHANNELCONFIG}
end

const PARRAY_CHANNELCONFIG = Ptr{ARRAY_CHANNELCONFIG}

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
CSTRIGGERCONFIG(number) = begin
    o = CSTRIGGERCONFIG(zeros(fieldcount(CSTRIGGERCONFIG))...)
    o.Size = sizeof(CSTRIGGERCONFIG)
    o.TriggerIndex = number
    return o
end

const PCSTRIGGERCONFIG = Ptr{CSTRIGGERCONFIG}

mutable struct ARRAY_TRIGGERCONFIG
    TriggerCount::UInt32
    aTrigger::NTuple{1,CSTRIGGERCONFIG}
end

const PARRAY_TRIGGERCONFIG = Ptr{ARRAY_TRIGGERCONFIG}

mutable struct CSSYSTEMCONFIG
    Size::UInt32
    pAcqCfg::PCSACQUISITIONCONFIG
    pAChannels::PARRAY_CHANNELCONFIG
    pATriggers::PARRAY_TRIGGERCONFIG
end

const PCSSYSTEMCONFIG = Ptr{CSSYSTEMCONFIG}

mutable struct CSSAMPLERATETABLE
    SampleRate::Clonglong
    strText::NTuple{32,UInt8}
end

const PCSSAMPLERATETABLE = Ptr{CSSAMPLERATETABLE}

mutable struct CSRANGETABLE
    InputRange::UInt32
    strText::NTuple{32,UInt8}
    Reserved::UInt32
end

const PCSRANGETABLE = Ptr{CSRANGETABLE}

mutable struct CSIMPEDANCETABLE
    Imdepdance::UInt32
    strText::NTuple{32,UInt8}
    Reserved::UInt32
end

const PCSIMPEDANCETABLE = Ptr{CSIMPEDANCETABLE}

mutable struct CSCOUPLINGTABLE
    Coupling::UInt32
    strText::NTuple{32,UInt8}
    Reserved::UInt32
end

const PCSCOUPLINGTABLE = Ptr{CSCOUPLINGTABLE}

mutable struct CSFILTERTABLE
    LowCutoff::UInt32
    HighCutoff::UInt32
end

const PCSFILTERTABLE = Ptr{CSFILTERTABLE}

mutable struct IN_PARAMS_TRANSFERDATA
    Channel::Cushort
    Mode::Cuint
    Segment::Cuint
    StartAddress::Int64
    Length::Int64
    pDataBuffer::Ptr{Cvoid}
    hNotifyEvent::Ptr{Ptr{Cvoid}}
end
IN_PARAMS_TRANSFERDATA() =
    IN_PARAMS_TRANSFERDATA(0, 0, 0, 0, 0, Ptr{Cvoid}(), C_NULL)
IN_PARAMS_TRANSFERDATA(a::Array) = IN_PARAMS_TRANSFERDATA(a[1:end - 1]..., C_NULL)
mutable struct AsyncTransfer
    Channel::Cushort
    Mode::Cuint
    Segment::Cuint
    StartAddress::Int64
    Length::Int64
    pDataBuffer::Ptr{Cvoid}
end
AsyncTransfer() = AsyncTransfer(0, 0, 0, 0, 0, Ptr{Cvoid}())
AsyncTransfer(a::Array) = AsyncTransfer(a[1:end - 1]..., C_NULL)
const PIN_PARAMS_TRANSFERDATA = Ptr{IN_PARAMS_TRANSFERDATA}

mutable struct OUT_PARAMS_TRANSFERDATA
    ActualStart::Clonglong
    ActualLength::Clonglong
    LowPart::Int32
    HighPart::Int32
end
OUT_PARAMS_TRANSFERDATA() = OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)

const POUT_PARAMS_TRANSFERDATA = Ptr{OUT_PARAMS_TRANSFERDATA}

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

const PCALLBACK_DATA = Ptr{CALLBACK_DATA}
const LPCsEventCallback = Ptr{Cvoid}

mutable struct CSTIMESTAMP
    Hour::UInt16
    Minute::UInt16
    Second::UInt16
    Point1Second::UInt16
end

const PCSTIMESTAMP = Ptr{CSTIMESTAMP}

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

const PCSSIGSTRUCT = Ptr{CSSIGSTRUCT}

mutable struct CSDISKFILEHEADER
    cData::NTuple{512,UInt8}
end

const PCSDISKFILEHEADER = Ptr{CSDISKFILEHEADER}

mutable struct CSSEGMENTTAIL
    TimeStamp::Clonglong
    Reserved0::Clonglong
    Reserved1::Clonglong
    Reserved2::Clonglong
end

const PCSSEGMENTTAIL = Ptr{CSSEGMENTTAIL}

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

const PSTREAMING_FILEHEADER = Ptr{STREAMING_FILEHEADER}

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

const PSTMHEADER = Ptr{STMHEADER}

mutable struct TRIGGERED_INFO_STRUCT
    Size::UInt32
    StartSegment::UInt32
    NumOfSegments::UInt32
    BufferSize::UInt32
    pBuffer::Ptr{Int16}
end

const PTRIGGERED_INFO_STRUCT = Ptr{TRIGGERED_INFO_STRUCT}

mutable struct CSPECONFIG
    Size::UInt32
    Enable::UInt32
    InputType::UInt32
    EncodeMode::UInt32
    Step::UInt32
    Offset::UInt32
end

const PCSPECONFIG = Ptr{CSPECONFIG}

mutable struct CS_STRUCT_DATAFORMAT_INFO
    Size::UInt32
    Signed::UInt32
    Packed::UInt32
    SampleBits::UInt32
    SampleSize_Bits::UInt32
    SampleOffset::Int32
    i32SampleRes::Int32
end

const PCS_STRUCT_DATAFORMAT_INFO = Ptr{CS_STRUCT_DATAFORMAT_INFO}
