
function getGageEvent(G::GageCard, eventType)
  if eventType === ACQ_EVENT_END_BUSY
    name = "XferEvent"
  elseif eventType === ACQ_EVENT_TRIGGERED
    name = "TriggerEvent"
  else
    error("Unsupported Event type.")
  end

    # Create an event from the win32 api.
  eventwin = ccall(
    (:CreateEventA, :kernel32),
    Ptr{Cvoid},
    (Ptr{Cvoid}, Cint, Cint, Cstring),
    C_NULL,
    1,
    0,
    name,
  )

  Q = Ref{Ptr{Cvoid}}(eventwin) # Wrap event for memory management.

    # Get the handle of the GageCard's event.
  ccall(
    (:CsGetEventHandle, csssm),
    Cuint,
    (Cuint, Cuint, Ptr{Cvoid}),
    G.gagehandle,
    eventType,
    Q,
  )
  return Q
end

const INFINITE = typemax(UInt32)
function win32wait(event, timeout = INFINITE)
  y = ccall(
    (:WaitForSingleObject, :kernel32),
    Cint,
    (Ptr{Cvoid}, Cuint),
    event[],
    timeout,
  )
end

function win32reset(event)
  ccall((:ResetEvent, "kernel32"), Cint, (Ptr{Cvoid},), event[])
end

dataComplete(g::GageCard) = (get_status(g) < 1);

# Adapted from julialang.discourse =============================================
function hybrid_sleep(sleep_time::Float64, threshold::Float64 = 0.0175)
  # ============================================================================
  # accurately sleep for sleep_time secs
  # ============================================================================
  #  if sleep_time is <= threshold, busy wait all of sleep_time
  #  if sleep_time is >  threshold, hybrid sleep as follows:
  #     1) actual_sleep = max(.001, sleep_time - threshold)
  #     2) Libc.systemsleep(actual_sleep)
  #     3) busy wait remaining time when 2) completes
  # -------------------------------------------------------------------------

  tics_per_sec = 1_000_000_000.0  #-- number of tics in one sec
  nano1 = time_ns()                            #-- beginning nano time
  nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final nano time
  min_actual_sleep = 0.001   #-- do not let the actual_sleep be less than this value
  max_sleep = 86_400_000.0   #-- maximum allowed sleep_time parm (100 days in secs)
  min_sleep = 0.000001000    #-- mininum allowed sleep_time parm (1 micro sec)

  #-- verify if sleep_time is within limits
  if sleep_time < min_sleep
    # @printf("parameter error:  sleep_time => %10.8f is less than %10.8f secs!!\n", sleep_time, min_sleep)
    println("sleep_ns aborted ==> specified sleep time is too low!")
    sleep(2.0)
    return -1.0   #-- parm error negative return
  end

  if sleep_time > max_sleep
    # @printf("parameter error:  sleep_time => %12.1f is greater than %10.1f secs!!\n", sleep_time, max_sleep)
    println("sleep_ns aborted ==> specified sleep time is too high!")
    sleep(2.0)
    return -2.0    #-- parm error negative return
  end

  #------ actual sleep
  if sleep_time > threshold  #-- sleep only if above threshold
    #-- actual_sleep_time must be at least min_actual_sleep
    actual_sleep_time = max(min_actual_sleep, sleep_time - threshold)
    Libc.systemsleep(actual_sleep_time)
  end

  #------ final busy wait
  nano3::UInt64 = time_ns()  #-- interim nano time for while loop
  while true
    nano3 >= nano2 && break   #-- break out if final nano time has been exceeded
    nano3 = time_ns()
  end

  seconds_over = (nano3 - nano2) / tics_per_sec  #-- seconds that sleep_time was exceeded
  return seconds_over
end #-- end of sleep_ns
