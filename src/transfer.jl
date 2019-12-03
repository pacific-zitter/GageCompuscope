function MultipleRecord(g::GageCard, chnl::Int)
    _acq = g.acquisition_config
    data_array = Array{Int16,2}(undef, _acq.SegmentSize, _acq.SegmentCount)
    _inp = IN_PARAMS_TRANSFERDATA(
        Channel = chnl,
        StartAddress = _acq.SampleOffset,
        Length = _acq.SegmentSize,
        pDataBuffer = pointer(data_array),
    )
    _out = OUT_PARAMS_TRANSFERDATA()
    MultipleRecord(g.gagehandle, data_array, _inp, _out)
end

Base.Array(m::MultipleRecord) = m.data_array

function Base.unsafe_convert(::Type{Ptr{G}}, g::G) where {G<:GageConfig}
    Base.unsafe_convert(Ptr{G}, Ref(g))
end

function (mult::MultipleRecord)()
    for i in axes(mult.data_array, 2)
        mult.input_gage.Segment = i
        mult.input_gage.pDataBuffer = pointer(view(mult.data_array, :, i))
        st = ccall(
            (:CsTransfer, csssm),
            Cint,
            (Cuint, Ref{IN_PARAMS_TRANSFERDATA}, Ptr{OUT_PARAMS_TRANSFERDATA}),
            mult.handle,
            mult.input_gage,
            mult.output_gage,
        )
    end
    mult
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

"""
    to_voltage(adc_code, sample_offset, resolution, full_scale_voltage,dc_offset)
"""
function to_voltage(
    adc_code,
    sample_offset,
    resolution,
    input_range,
    dc_offset,
)

    scale_factor = float(input_range) / float(CS_GAIN_2_V)
    out = @. ((sample_offset - adc_code) * inv(float(resolution)) *
              scale_factor) + (dc_offset * 1e-3)

end

function to_voltage!(
    output,
    adc_code,
    sample_offset,
    resolution,
    input_range,
    dc_offset,
)

    scale_factor = float(input_range) / float(CS_GAIN_2_V)
    @. output = ((sample_offset - adc_code) * inv(float(resolution)) *
                 scale_factor) + (dc_offset * 1e-3)

end
