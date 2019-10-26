
include("defines_gage.jl")
include("common_gage.jl")
const _csget = (CSACQUISITIONCONFIG = CS_ACQUISITION,
    CSTRIGGERCONFIG = CS_TRIGGER,
    CSCHANNELCONFIG = CS_CHANNEL,
    CSSYSTEMINFO = CS_BOARD_INFO,)

function CsInitialize()
    ccall((:CsInitialize, :CsSsm), Int32, ())
end

function CsGetSystem(phSystem,
    u32BoardType,
    u32Channels,
    u32SampleBits,
    i16Index,
)
    ccall((:CsGetSystem, :CsSsm),
        Int32,
        (Ptr{UInt32}, UInt32, UInt32, UInt32, Int16),
        phSystem,
        u32BoardType,
        u32Channels,
        u32SampleBits,
        i16Index,
    )
end

function CsFreeSystem(handle)
    ccall((:CsFreeSystem, :CsSsm), Int32, (UInt32,), handle)
end

function CsGet(hSystem, nIndex, nConfig, pData::Ptr{T}) where {T}
    ccall((:CsGet, :CsSsm),
        Int32,
        (UInt32, Int32, Int32, Ptr{T}),
        hSystem,
        nIndex,
        nConfig,
        pData,
    )
end

function CsGet(hSystem, nIndex, nConfig, pData::T) where {T}
    ccall((:CsGet, :CsSsm),
        Int32,
        (UInt32, Int32, Int32, Ref{T}),
        hSystem,
        nIndex,
        nConfig,
        pData,
    )
end

function CsGet(hSystem, pData::T) where {T}
    G = typeof(pData) |> (x,)->split(string(x), '.')[end] |> Symbol
    idx = getfield(_csget, G)
    ccall((:CsGet, :CsSsm),
        Int32,
        (UInt32, Int32, Int32, Ref{T}),
        hSystem,
        idx,
        CS_CURRENT_CONFIGURATION,
        pData,
    )
end

function CsSet(hSystem, nIndex, pData::T) where {T}
    ccall((:CsSet, :CsSsm),
        Int32,
        (UInt32, Int32, Ref{T}),
        hSystem,
        nIndex,
        pData,
    )
end

function CsGetSystemInfo(hSystem, pSystemInfo)
    ccall((:CsGetSystemInfo, :CsSsm),
        Int32,
        (UInt32, Ref{CSSYSTEMINFO}),
        hSystem,
        pSystemInfo,
    )
end
CsGetSystemInfo(info) = CsGetSystemInfo(gagehandle[], info)

function CsGetSystemCaps(hSystem, CapsId, pBuffer, BufferSize)
    ccall((:CsGetSystemCaps, :CsSsm),
        Int32,
        (UInt32, UInt32, Ptr{Cvoid}, Ref{Cuint}),
        hSystem,
        CapsId,
        pBuffer,
        BufferSize,
    )
end

function CsDo(hSystem, i16Operation)
    ccall((:CsDo, :CsSsm), Int32, (UInt32, Int16), hSystem, i16Operation)
end

function CsTransfer(hSystem, pInData, outData)
    ccall((:CsTransfer, :CsSsm),
        Int32,
        (UInt32, Ref{IN_PARAMS_TRANSFERDATA}, Ref{OUT_PARAMS_TRANSFERDATA}),
        hSystem,
        pInData,
        outData,
    )
end

function CsTransfer_threadcall(hSystem, pInData, outData)
    @threadcall(
        (:CsTransfer, :CsSsm),
        Int32,
        (UInt32, Ptr{IN_PARAMS_TRANSFERDATA}, Ptr{OUT_PARAMS_TRANSFERDATA}),
        hSystem,
        pInData,
        outData,
    )
end

function CsTransferEx(hSystem, pInData, outData)
    ccall((:CsTransferEx, :CsSsm),
        Int32,
        (UInt32, Ptr{IN_PARAMS_TRANSFERDATA_EX}, Ptr{OUT_PARAMS_TRANSFERDATA_EX}),
        hSystem,
        pInData,
        outData,
    )
end

function CsGetEventHandle(hSystem, u32EventType, phEvent)
    ccall((:CsGetEventHandle, :CsSsm),
        Int32,
        (UInt32, UInt32, Ref{Threads.Event}),
        hSystem,
        u32EventType,
        phEvent,
    )
end
function event_handle(handle, eventtype, eventhandle)
    Base.@threadcall(
        (:CsGetEventHandle, :CsSsm),
        Int32,
        (UInt32, UInt32, Ptr{Threads.Event}),
        handle,
        eventtype,
        eventhandle,
    )
end



function CsGetStatus(hSystem)
    ccall((:CsGetStatus, :CsSsm), Int32, (UInt32,), hSystem)
end


function CsGetErrorString(i32ErrorCode)
    buffer = Vector{UInt8}(undef, 256)
    ccall((:CsGetErrorStringA, :CsSsm),
        Int32,
        (Int32, Cstring, Cint),
        i32ErrorCode,
        pointer(buffer),
        256,
    )
    unsafe_string(pointer(buffer))
end

function CsTransferAS(hSystem, pInData, pOutParams, pToken)
    pin = Ref(pInData)
    ccall((:CsTransferAS, :CsSsm),
        Int32,
        (UInt32,
         Ptr{Cvoid},
         Ptr{OUT_PARAMS_TRANSFERDATA},
         Ptr{Int32},),
        hSystem,
        pin,
        pOutParams,
        pToken,
    )
end

function CsGetTransferASResult(hSystem, nChannelIndex, pi64Results)
    ccall((:CsGetTransferASResult, :CsSsm),
        Int32,
        (UInt32, Cint, Ptr{Int64}),
        hSystem,
        nChannelIndex,
        pi64Results,
    )
end

function CsRegisterCallbackFnc(hSystem, u32Event, pCallBack)
    ccall((:CsRegisterCallbackFnc, :CsSsm),
        Int32,
        (UInt32, UInt32, LPCsEventCallback),
        hSystem,
        u32Event,
        pCallBack,
    )
end

function CsExpertCall(hSystem, pFunctionParams::T) where T
    ccall((:CsExpertCall, :CsSsm),
        Int32,
        (UInt32, Ref{T}),
        hSystem,
        pFunctionParams,
    )
end
