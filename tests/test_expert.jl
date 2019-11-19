using GageCompuscope
using CBinding

gage = GageCard(true)
set_samplerate(gage,10e7)
set_segmentcount(gage,10)


@cstruct _in {
    channel::Int16
    mode::UInt32
    segment::UInt32
    startaddr::Int64
    nsamples::Int64
    data_buffer::Ptr{Int16}
    event::Ptr{Ptr{Cvoid}}
    }

@cstruct _out {
    actualstart::Int64
    actualsamples::Int64
    lowp::Int32
    highp::Int32
    }

pinput= _in()
poutput = _out()
buffer = zeros(Int16,8192)

hnote = Ptr[C_NULL]
pinput.channel=1;pinput.segment=1;pinput.startaddr=-1;pinput.nsamples=gage.acquisition_config.SegmentSize
pinput.data_buffer = Base.unsafe_convert(Ptr{Cshort},Base.RefArray(buffer))
pinput.event = pointer(hnote)


function async_transfer(hSystem,ii::_in,oo::_out)
    token = Ref{Cint}()
    status = ccall(
        (:CsTransferAS, :CsSsm),
        Cint,
        (
         Cuint,
         Ref{_in},
         Ref{_out},
         Ptr{Cint},
        ),
        hSystem,
        ii,
        oo,
        token
    )
    return status, token
end

@cstruct TransferResult {
        status::Int32
        bytessent::Int64
  }

function async_transfer_result(handle,channel)
    rstruct = TransferResult(undef)
    ccall((:CsDrvGetAsyncTransferDataResult,:CsDisp),
            Cint,
            (
                Cuint,
                Cuchar,
                Ref{TransferResult},
                Cint
            ),
            handle,
            channel,
            rstruct,
            0
            )

        rstruct
end
async_transfer(gage.gagehandle, pinput, poutput)

async_transfer_result(gage.gagehandle,1)
