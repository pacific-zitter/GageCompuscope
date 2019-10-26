
#------------------------------------------------------------------------------
# Transfer Functions.
#------------------------------------------------------------------------------
function Base.unsafe_convert(::Type{Ptr{LibGage.IN_PARAMS_TRANSFERDATA}},
    m::LibGage.IN_PARAMS_TRANSFERDATA,
)
    Base.unsafe_convert(Ptr{LibGage.IN_PARAMS_TRANSFERDATA}, Ref(m))
end

"""
# Initiate Transfer
    a unique token is generated for every transfer event. This can be used to
        check the status of a previously initiated transfer, and can actually be
        called from any thread.
"""
function initiate_transfer(g::GageCard, transfer::Transfer)
    notify_event = [C_NULL]

    # The gage api seems to mess with this pointer and causes access violation.
    # this appears to at least stop that error.
    transfer.input.hNotifyEvent = pointer_from_objref(notify_event)

    token = Ref{Cint}()
    status = CsTransferAS(g.gagehandle, transfer.input, transfer.output, token)

    return token
end

function poll_transferstatus(g::GageCard, token)
    bytes_transfered = Ref{Int64}()
    st = CsGetTransferASResult(g.gagehandle, token, bytes_transfered)
    return st, bytes_transfered
end
