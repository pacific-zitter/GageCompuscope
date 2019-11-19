const _csget = Dict(
    CSACQUISITIONCONFIG => CS_ACQUISITION,
    CSTRIGGERCONFIG => CS_TRIGGER,
    CSCHANNELCONFIG => CS_CHANNEL,
    CSSYSTEMINFO => CS_BOARD_INFO,
)

function CsInitialize()
    ccall((:CsInitialize, :CsSsm), Int32, ())
end

function CsGetSystem(
    phSystem,
    u32BoardType,
    u32Channels,
    u32SampleBits,
    i16Index,
)
    ccall(
        (:CsGetSystem, :CsSsm),
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

function CsGet(hSystem, nIndex, nConfig, pData::T) where {T}
    ccall(
        (:CsGet, :CsSsm),
        Int32,
        (UInt32, Int32, Int32, Ref{T}),
        hSystem,
        nIndex,
        nConfig,
        pData,
    )
end

function CsSet(hSystem, nIndex, pData::T) where {T}
    ccall(
        (:CsSet, :CsSsm),
        Int32,
        (UInt32, Int32, Ref{T}),
        hSystem,
        nIndex,
        pData,
    )
end

function CsGetSystemInfo(hSystem, pSystemInfo::T) where {T}
    ccall(
        (:CsGetSystemInfo, :CsSsm),
        Int32,
        (UInt32, Ref{T}),
        hSystem,
        pSystemInfo,
    )
end
CsGetSystemInfo(info) = CsGetSystemInfo(gagehandle[], info)

function CsGetSystemCaps(hSystem, CapsId, pBuffer, BufferSize)
    ccall(
        (:CsGetSystemCaps, :CsSsm),
        Cint,
        (Cuint, Cuint, Ptr{Cvoid}, Ref{Cuint}),
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
    ccall(
        (:CsTransfer, :CsSsm),
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
    ccall(
        (:CsTransferEx, :CsSsm),
        Int32,
        (
         UInt32,
         Ptr{IN_PARAMS_TRANSFERDATA_EX},
         Ptr{OUT_PARAMS_TRANSFERDATA_EX},
        ),
        hSystem,
        pInData,
        outData,
    )
end

function CsGetEventHandle(hSystem, u32EventType, phEvent)
    ccall(
        (:CsGetEventHandle, :CsSsm),
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
    ccall(
        (:CsGetErrorStringA, :CsSsm),
        Int32,
        (Int32, Cstring, Cint),
        i32ErrorCode,
        pointer(buffer),
        256,
    )
    unsafe_string(pointer(buffer))
end

function CsTransferAS(hSystem, pInData, pOutParams, pToken)
    ccall(
        (:CsTransferAS, :CsSsm),
        Int32,
        (UInt32, Ptr{Cvoid}, Ptr{Cvoid}, Ref{Int32}),
        hSystem,
        pInData,
        pOutParams,
        pToken,
    )
end

function CsGetTransferASResult(hSystem, nChannelIndex, pi64Results)
    ccall(
        (:CsGetTransferASResult, :CsSsm),
        Int32,
        (UInt32, Ref{Cint}, Ptr{Int64}),
        hSystem,
        nChannelIndex,
        pi64Results,
    )
end

function CsRegisterCallbackFnc(hSystem, u32Event, pCallBack)
    ccall(
        (:CsRegisterCallbackFnc, :CsSsm),
        Int32,
        (UInt32, UInt32, Ptr{Cvoid}),
        hSystem,
        u32Event,
        pCallBack,
    )
end

function CsExpertCall(hSystem, pFunctionParams)
    ccall(
        (:CsExpertCall, :CsSsm),
        Int32,
        (UInt32, Ptr{Cvoid}),
        hSystem,
        pFunctionParams,
    )
end
