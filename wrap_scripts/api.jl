# Julia wrapper for header: cb.h
# Automatically generated using Clang.jl


function EnterCriticalSection(lpCriticalSection)
    ccall((:EnterCriticalSection, kernel32), Cvoid, (LPCRITICAL_SECTION,), lpCriticalSection)
end

function LeaveCriticalSection(lpCriticalSection)
    ccall((:LeaveCriticalSection, kernel32), Cvoid, (LPCRITICAL_SECTION,), lpCriticalSection)
end

function TryEnterCriticalSection(lpCriticalSection)
    ccall((:TryEnterCriticalSection, kernel32), WINBOOL, (LPCRITICAL_SECTION,), lpCriticalSection)
end

function DeleteCriticalSection(lpCriticalSection)
    ccall((:DeleteCriticalSection, kernel32), Cvoid, (LPCRITICAL_SECTION,), lpCriticalSection)
end

function SetEvent(hEvent)
    ccall((:SetEvent, kernel32), WINBOOL, (HANDLE,), hEvent)
end

function ResetEvent(hEvent)
    ccall((:ResetEvent, kernel32), WINBOOL, (HANDLE,), hEvent)
end

function ReleaseSemaphore(hSemaphore, lReleaseCount, lpPreviousCount)
    ccall((:ReleaseSemaphore, kernel32), WINBOOL, (HANDLE, LONG, LPLONG), hSemaphore, lReleaseCount, lpPreviousCount)
end

function ReleaseMutex(hMutex)
    ccall((:ReleaseMutex, kernel32), WINBOOL, (HANDLE,), hMutex)
end

function WaitForSingleObjectEx(hHandle, dwMilliseconds, bAlertable)
    ccall((:WaitForSingleObjectEx, kernel32), DWORD, (HANDLE, DWORD, WINBOOL), hHandle, dwMilliseconds, bAlertable)
end

function WaitForMultipleObjectsEx(nCount, lpHandles, bWaitAll, dwMilliseconds, bAlertable)
    ccall((:WaitForMultipleObjectsEx, kernel32), DWORD, (DWORD, Ptr{HANDLE}, WINBOOL, DWORD, WINBOOL), nCount, lpHandles, bWaitAll, dwMilliseconds, bAlertable)
end

function OpenMutexW(dwDesiredAccess, bInheritHandle, lpName)
    ccall((:OpenMutexW, kernel32), HANDLE, (DWORD, WINBOOL, LPCWSTR), dwDesiredAccess, bInheritHandle, lpName)
end

function OpenEventA(dwDesiredAccess, bInheritHandle, lpName)
    ccall((:OpenEventA, kernel32), HANDLE, (DWORD, WINBOOL, LPCSTR), dwDesiredAccess, bInheritHandle, lpName)
end

function OpenEventW(dwDesiredAccess, bInheritHandle, lpName)
    ccall((:OpenEventW, kernel32), HANDLE, (DWORD, WINBOOL, LPCWSTR), dwDesiredAccess, bInheritHandle, lpName)
end

function OpenSemaphoreW(dwDesiredAccess, bInheritHandle, lpName)
    ccall((:OpenSemaphoreW, kernel32), HANDLE, (DWORD, WINBOOL, LPCWSTR), dwDesiredAccess, bInheritHandle, lpName)
end

function WaitOnAddress(Address, CompareAddress, AddressSize, dwMilliseconds)
    ccall((:WaitOnAddress, kernel32), WINBOOL, (Ptr{Cvoid}, PVOID, SIZE_T, DWORD), Address, CompareAddress, AddressSize, dwMilliseconds)
end

function WakeByAddressSingle(Address)
    ccall((:WakeByAddressSingle, kernel32), Cvoid, (PVOID,), Address)
end

function WakeByAddressAll(Address)
    ccall((:WakeByAddressAll, kernel32), Cvoid, (PVOID,), Address)
end

function InitializeCriticalSection(lpCriticalSection)
    ccall((:InitializeCriticalSection, kernel32), Cvoid, (LPCRITICAL_SECTION,), lpCriticalSection)
end

function InitializeCriticalSectionAndSpinCount(lpCriticalSection, dwSpinCount)
    ccall((:InitializeCriticalSectionAndSpinCount, kernel32), WINBOOL, (LPCRITICAL_SECTION, DWORD), lpCriticalSection, dwSpinCount)
end

function SetCriticalSectionSpinCount(lpCriticalSection, dwSpinCount)
    ccall((:SetCriticalSectionSpinCount, kernel32), DWORD, (LPCRITICAL_SECTION, DWORD), lpCriticalSection, dwSpinCount)
end

function WaitForSingleObject(hHandle, dwMilliseconds)
    ccall((:WaitForSingleObject, kernel32), DWORD, (HANDLE, DWORD), hHandle, dwMilliseconds)
end

function SleepEx(dwMilliseconds, bAlertable)
    ccall((:SleepEx, kernel32), DWORD, (DWORD, WINBOOL), dwMilliseconds, bAlertable)
end

function CreateMutexA(lpMutexAttributes, bInitialOwner, lpName)
    ccall((:CreateMutexA, kernel32), HANDLE, (LPSECURITY_ATTRIBUTES, WINBOOL, LPCSTR), lpMutexAttributes, bInitialOwner, lpName)
end

function CreateMutexW(lpMutexAttributes, bInitialOwner, lpName)
    ccall((:CreateMutexW, kernel32), HANDLE, (LPSECURITY_ATTRIBUTES, WINBOOL, LPCWSTR), lpMutexAttributes, bInitialOwner, lpName)
end

function CreateEventA(lpEventAttributes, bManualReset, bInitialState, lpName)
    ccall((:CreateEventA, kernel32), HANDLE, (LPSECURITY_ATTRIBUTES, WINBOOL, WINBOOL, LPCSTR), lpEventAttributes, bManualReset, bInitialState, lpName)
end

function CreateEventW(lpEventAttributes, bManualReset, bInitialState, lpName)
    ccall((:CreateEventW, kernel32), HANDLE, (LPSECURITY_ATTRIBUTES, WINBOOL, WINBOOL, LPCWSTR), lpEventAttributes, bManualReset, bInitialState, lpName)
end

function SetWaitableTimer(hTimer, lpDueTime, lPeriod, pfnCompletionRoutine, lpArgToCompletionRoutine, fResume)
    ccall((:SetWaitableTimer, kernel32), WINBOOL, (HANDLE, Ptr{LARGE_INTEGER}, LONG, PTIMERAPCROUTINE, LPVOID, WINBOOL), hTimer, lpDueTime, lPeriod, pfnCompletionRoutine, lpArgToCompletionRoutine, fResume)
end

function CancelWaitableTimer(hTimer)
    ccall((:CancelWaitableTimer, kernel32), WINBOOL, (HANDLE,), hTimer)
end

function OpenWaitableTimerW(dwDesiredAccess, bInheritHandle, lpTimerName)
    ccall((:OpenWaitableTimerW, kernel32), HANDLE, (DWORD, WINBOOL, LPCWSTR), dwDesiredAccess, bInheritHandle, lpTimerName)
end

function EnterSynchronizationBarrier(lpBarrier, dwFlags)
    ccall((:EnterSynchronizationBarrier, kernel32), WINBOOL, (LPSYNCHRONIZATION_BARRIER, DWORD), lpBarrier, dwFlags)
end

function InitializeSynchronizationBarrier(lpBarrier, lTotalThreads, lSpinCount)
    ccall((:InitializeSynchronizationBarrier, kernel32), WINBOOL, (LPSYNCHRONIZATION_BARRIER, LONG, LONG), lpBarrier, lTotalThreads, lSpinCount)
end

function DeleteSynchronizationBarrier(lpBarrier)
    ccall((:DeleteSynchronizationBarrier, kernel32), WINBOOL, (LPSYNCHRONIZATION_BARRIER,), lpBarrier)
end

function Sleep(dwMilliseconds)
    ccall((:Sleep, kernel32), Cvoid, (DWORD,), dwMilliseconds)
end

function SignalObjectAndWait(hObjectToSignal, hObjectToWaitOn, dwMilliseconds, bAlertable)
    ccall((:SignalObjectAndWait, kernel32), DWORD, (HANDLE, HANDLE, DWORD, WINBOOL), hObjectToSignal, hObjectToWaitOn, dwMilliseconds, bAlertable)
end
