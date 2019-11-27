
function MultipleRecord(g::GageCard)
    _acq = g.acquisition_config
    data_array = Array{Int16,2}(undef, _acq.SegmentSize, _acq.SegmentCount)
    _inp = IN_PARAMS_TRANSFERDATA(
        StartAddress = _acq.SampleOffset,
        Length = _acq.SegmentSize,
        pDataBuffer = pointer(data_array)
    )
    _out = OUT_PARAMS_TRANSFERDATA()
    MultipleRecord(g.gagehandle, data_array, _inp, _out)
end

function Base.unsafe_convert(::Type{Ptr{G}}, g::G) where {G<:GageConfig}
    Base.unsafe_convert(Ptr{G}, Ref(g))
end
function LibGage.CsTransfer(g::GageCard, r::MultipleRecord)
    for (i, d) in enumerate(eachcol(r.data_array))
        r.input_gage.Segment = i
        r.input_gage.pDataBuffer = pointer(d)
        ccall(
            (:CsTransfer, csssm),
            Cint,
            (UInt32, Ptr{IN_PARAMS_TRANSFERDATA}, Ptr{OUT_PARAMS_TRANSFERDATA}),
            g.gagehandle,
            r.input_gage,
            r.output_gage,
        )
    end
end

function dataReady(g::GageCard)
    !(get_status(g) > 0)
end

"""
    acquire
Arm the GageCard trigger, wait for an acquisition to complete, and transfer that
acquisition to the Transfer structure.
"""
# function acquire(gage::GageCard, xfer::Transfer)
#     start(gage)
#     while CsGetStatus(gage.gagehandle) > 0
#     end
#     CsTransfer(gage.gagehandle, xfer.input, xfer.output)
#     nothing
# end

"""
    transfer_data
Transfer onboard memory. Simple method.
"""
# function transfer_data(g::GageCard, xfer::Transfer)
#     CsTransfer_threadcall(g.gagehandle, xfer.input, xfer.output)
# end

"""
    until_ready
Queries the driver until the status returns ready.
"""
# function until_ready(g::GageCard; timeout = 10.0)
#     status = get_status(g)
#     t1 = time()
#     laststatus = 0
#     while status > 0
#         sleep(1e-2)
#         time() - t1 > timeout && break
#         status = get_status(g)
#     end
# end
