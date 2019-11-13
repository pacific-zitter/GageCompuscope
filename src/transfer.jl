@kwdef struct TransferData{T}
    input::InputParameters = InputParameters()
    output::OutputParameters = OutputParameters()
    data::Array{T}
    segrng::Base.OneTo
end

function TransferData{T}(gage::GageCard, requested_chnl) where {T}
    inp = InputParameters(
        Channel = requested_chnl,
        Segment = 1,
        StartAddress = gage.acquisition_config.SampleOffset,
        Length = gage.acquisition_config.SegmentSize,
    )

    tx = TransferData{T}(
        input = inp,
        data = Vector{Int16}(undef, inp.Length),
        segrng = 1:gage.acquisition_config.SegmentCount,
    )
    tx.input.pDataBuffer = pointer(tx.data)
    tx
end

# function InputParamaters(g::GageCard, requested_channel)
#     inp = InputParamaters(Channel = requested_channel,)
#     aq = g.acquisition_config
#     inp.Channel = 1
#     inp.Mode = TxMODE_DEFAULT
#     inp.Segment = 1
#     inp.StartAddress = aq.SampleOffset
#     inp.Length = aq.SegmentSize
#     xfer.segment_buffer = Vector{Int16}(undef, aq.SegmentSize)
#     inp.pDataBuffer = pointer(xfer.segment_buffer)
#     return xfer
# end

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


@kwdef mutable struct _IN
    		u32Size::UInt32
    		u32ActionId::UInt32	= 0
    		u32StartSegment::UInt32 = 0
    		u32EndSegment::UInt32 = 0
    		pBuffer::Ptr{Cvoid}	= C_NULL
    		i64BufferSize::Int64 = 0
end

@kwdef mutable struct _OUT
		i64ActualBufferSize::Int64	# Buffer Size in bytes
end

@kwdef mutable struct MultipleRecord
	inp::_IN
	outp::_OUT
end
