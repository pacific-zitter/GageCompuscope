# Julia wrapper for header: CsPrototypes.h
# Automatically generated using Clang.jl


function CsInitialize()
    ccall((:CsInitialize, CsSsm), int32, ())
end

function CsGetSystem(phSystem, u32BoardType, u32Channels, u32SampleBits, i16Index)
    ccall((:CsGetSystem, CsSsm), int32, (Ptr{CSHANDLE}, uInt32, uInt32, uInt32, int16), phSystem, u32BoardType, u32Channels, u32SampleBits, i16Index)
end

function CsFreeSystem(arg1)
    ccall((:CsFreeSystem, CsSsm), int32, (CSHANDLE,), arg1)
end

function CsGet(hSystem, nIndex, nConfig, pData)
    ccall((:CsGet, CsSsm), int32, (CSHANDLE, int32, int32, Ptr{Cvoid}), hSystem, nIndex, nConfig, pData)
end

function CsSet(hSystem, nIndex, pData)
    ccall((:CsSet, CsSsm), int32, (CSHANDLE, int32, Ptr{Cvoid}), hSystem, nIndex, pData)
end

function CsGetSystemInfo(hSystem, pSystemInfo)
    ccall((:CsGetSystemInfo, CsSsm), int32, (CSHANDLE, PCSSYSTEMINFO), hSystem, pSystemInfo)
end

function CsGetSystemCaps(hSystem, CapsId, pBuffer, BufferSize)
    ccall((:CsGetSystemCaps, CsSsm), int32, (CSHANDLE, uInt32, Ptr{Cvoid}, Ptr{uInt32}), hSystem, CapsId, pBuffer, BufferSize)
end

function CsDo(hSystem, i16Operation)
    ccall((:CsDo, CsSsm), int32, (CSHANDLE, int16), hSystem, i16Operation)
end

function CsTransfer(hSystem, pInData, outData)
    ccall((:CsTransfer, CsSsm), int32, (CSHANDLE, PIN_PARAMS_TRANSFERDATA, POUT_PARAMS_TRANSFERDATA), hSystem, pInData, outData)
end

function CsTransferEx(hSystem, pInData, outData)
    ccall((:CsTransferEx, CsSsm), int32, (CSHANDLE, PIN_PARAMS_TRANSFERDATA_EX, POUT_PARAMS_TRANSFERDATA_EX), hSystem, pInData, outData)
end

function CsGetEventHandle(hSystem, u32EventType, phEvent)
    ccall((:CsGetEventHandle, CsSsm), int32, (CSHANDLE, uInt32, Ptr{EVENT_HANDLE}), hSystem, u32EventType, phEvent)
end

function CsGetStatus(hSystem)
    ccall((:CsGetStatus, CsSsm), int32, (CSHANDLE,), hSystem)
end

function CsGetErrorStringA(i32ErrorCode, lpBuffer, nBufferMax)
    ccall((:CsGetErrorStringA, CsSsm), int32, (int32, LPSTR, Cint), i32ErrorCode, lpBuffer, nBufferMax)
end

function CsGetErrorStringW(i32ErrorCode, lpBuffer, nBufferMax)
    ccall((:CsGetErrorStringW, CsSsm), int32, (int32, Ptr{Cwchar_t}, Cint), i32ErrorCode, lpBuffer, nBufferMax)
end

function CsTransferAS(hSystem, pInData, pOutParams, pToken)
    ccall((:CsTransferAS, CsSsm), int32, (CSHANDLE, PIN_PARAMS_TRANSFERDATA, POUT_PARAMS_TRANSFERDATA, Ptr{int32}), hSystem, pInData, pOutParams, pToken)
end

function CsGetTransferASResult(hSystem, nChannelIndex, pi64Results)
    ccall((:CsGetTransferASResult, CsSsm), int32, (CSHANDLE, int32, Ptr{int64}), hSystem, nChannelIndex, pi64Results)
end

function CsStmAllocateBuffer(CsHandle, nCardIndex, u32BufferSize, pVa)
    ccall((:CsStmAllocateBuffer, CsSsm), int32, (CSHANDLE, uInt16, uInt32, Ptr{PVOID}), CsHandle, nCardIndex, u32BufferSize, pVa)
end

function CsStmFreeBuffer(CsHandle, nCardIndex, pVa)
    ccall((:CsStmFreeBuffer, CsSsm), int32, (CSHANDLE, uInt16, PVOID), CsHandle, nCardIndex, pVa)
end

function CsStmTransferToBuffer(CsHandle, nCardIndex, pBuffer, u32TransferSize)
    ccall((:CsStmTransferToBuffer, CsSsm), int32, (CSHANDLE, uInt16, PVOID, uInt32), CsHandle, nCardIndex, pBuffer, u32TransferSize)
end

function CsStmGetTransferStatus(CsHandle, nCardIndex, u32WaitTimeoutMs, u32ErrorFlag, u32ActualSize, Reserved)
    ccall((:CsStmGetTransferStatus, CsSsm), int32, (CSHANDLE, uInt16, uInt32, Ptr{uInt32}, Ptr{uInt32}, PVOID), CsHandle, nCardIndex, u32WaitTimeoutMs, u32ErrorFlag, u32ActualSize, Reserved)
end

function CsRegisterCallbackFnc(hSystem, u32Event, pCallBack)
    ccall((:CsRegisterCallbackFnc, CsSsm), int32, (CSHANDLE, uInt32, LPCsEventCallback), hSystem, u32Event, pCallBack)
end

function CsExpertCall(hSystem, pFunctionParams)
    ccall((:CsExpertCall, CsSsm), int32, (CSHANDLE, PVOID), hSystem, pFunctionParams)
end

function CsConvertToSigHeader(pHeader, pSigStruct, szComment, szName)
    ccall((:CsConvertToSigHeader, CsSsm), int32, (PCSDISKFILEHEADER, PCSSIGSTRUCT, Ptr{TCHAR}, Ptr{TCHAR}), pHeader, pSigStruct, szComment, szName)
end

function CsConvertFromSigHeader(pHeader, pSigStruct, szComment, szName)
    ccall((:CsConvertFromSigHeader, CsSsm), int32, (PCSDISKFILEHEADER, PCSSIGSTRUCT, Ptr{TCHAR}, Ptr{TCHAR}), pHeader, pSigStruct, szComment, szName)
end

function CsRetrieveChannelFromRawBuffer(pMulrecRawDataBuffer, i64RawDataBufferSize, u32SegmentId, ChannelIndex, i64Start, i64Length, pNormalizedDataBuffer, i64TrigTimeStamp, i64ActualStart, i64ActualLength)
    ccall((:CsRetrieveChannelFromRawBuffer, CsSsm), int32, (PVOID, int64, uInt32, uInt16, int64, int64, PVOID, Ptr{int64}, Ptr{int64}, Ptr{int64}), pMulrecRawDataBuffer, i64RawDataBufferSize, u32SegmentId, ChannelIndex, i64Start, i64Length, pNormalizedDataBuffer, i64TrigTimeStamp, i64ActualStart, i64ActualLength)
end
