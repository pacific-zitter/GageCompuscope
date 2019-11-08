#==============================================================================
Better names for raw GaGeAPI functions. Should be exactly equivalent to
associated function.
==============================================================================#
gageInit() = CsInitialize()

getGagecard(phSystem, u32BoardType, u32Channels, u32SampleBits, i16Index) =
    CsGetSystem(phSystem, u32BoardType, u32Channels, u32SampleBits, i16Index)

freeGagecard(handle) = CsFreeSystem(handle)

gageGet(hSystem, nIndex, nConfig, pData) =
    CsGet(hSystem, nIndex, nConfig, pData)

gageSet(hSystem, nIndex, pData) = CsSet(hSystem, nIndex, pData)

gageDo(hSystem, i16Operation) = CsDo(hSystem, i16Operation)

gageTransfer(hSystem, pInData, outData) = CsTransfer(hSystem, pInData, outData)


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
    pin = Ref(pInData)
    ccall(
        (:CsTransferAS, :CsSsm),
        Int32,
        (UInt32, Ptr{Cvoid}, Ptr{OUT_PARAMS_TRANSFERDATA}, Ptr{Int32}),
        hSystem,
        pin,
        pOutParams,
        pToken,
    )
end

function CsGetTransferASResult(hSystem, nChannelIndex, pi64Results)
    ccall(
        (:CsGetTransferASResult, :CsSsm),
        Int32,
        (UInt32, Cint, Ptr{Int64}),
        hSystem,
        nChannelIndex,
        pi64Results,
    )
end

function CsRegisterCallbackFnc(hSystem, u32Event, pCallBack)
    ccall(
        (:CsRegisterCallbackFnc, :CsSsm),
        Int32,
        (UInt32, UInt32, LPCsEventCallback),
        hSystem,
        u32Event,
        pCallBack,
    )
end

function CsExpertCall(hSystem, pFunctionParams::T) where {T}
    ccall(
        (:CsExpertCall, :CsSsm),
        Int32,
        (UInt32, Ref{T}),
        hSystem,
        pFunctionParams,
    )
end
