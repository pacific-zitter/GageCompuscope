# using GageCompuscope
# using CBinding

# gage = GageCard(true)

# siz = Ref{Int64}(0)
# h=Ref(0)
# h[]/ 1e6
# CsGetSystemCaps(gage.gagehandle,CAPS_STM_MAX_SEGMENTSIZE,h,siz)


# set_samplerate(gage, 10^7)
# set_segmentsize(gage, 10^7)
# set_segmentcount(gage, 5)
# set_trigger!(gage,1,1)
# gage.trigger_config[2].Source = 0
# CsSet(gage.gagehandle,CS_TRIGGER,gage.trigger_config[2]);commit(gage)
# gage.trigger_config[3].Source = 0
# CsSet(gage.gagehandle,CS_TRIGGER,gage.trigger_config[2]);commit(gage)

# CsDo(gage.gagehandle,ACTION_COMMIT)

# @cstruct _I {
#     Channel::Cushort
#     Mode::Cuint
#     Segment::Cuint
#     StartAddress::Clonglong
#     Length::Clonglong
#     pDataBuffer::Ptr{Cvoid}
#     hNotifyEvent::Ptr{Ptr{Cvoid}}
#   }

# data = Vector{Int16}(undef, 10^7)

# HH = [C_NULL]
# out = OUT_PARAMS_TRANSFERDATA(0, 0, 0, 0)
# _input = _I(Channel=1,Mode=TxMODE_DATA_ANALOGONLY,Segment=1,StartAddress= -1, Length=10^7,
#     pDataBuffer=pointer(data,1),hNotifyEvent=pointer_from_objref(HH))

# start(gage)
# get_status(gage)
# for i in 1:5
#     start(gage)
#     force(gage)
#     while get_status(gage) > 0
#         sleep(1e-3)
#     end
# end

# Base.unsafe_convert(::Type{Ptr{_I}},i::_I) = Base.unsafe_convert(Ptr{_I},Ref(i))

# token = Int32[0]
# ccall(
#     (:CsTransferAS,:CsSsm),
#     Cint,
#     (
#      Cuint,
#      Ref{_I},
#      Ref{OUT_PARAMS_TRANSFERDATA},
#      Ptr{Cvoid},
#     ),
#     gage.gagehandle,
#     _input,
#     out,
#     pointer(token)
# );

# bytes_transfered = Ref{Int64}()
# ccall(
#     (:CsGetTransferASResult,:CsSsm),
#     Cint,
#     (
#     Cuint,
#      Int32,
#      Ref{Int64},
#     ),
#     gage.gagehandle,
#     token[1],
#     bytes_transfered
# ) |> cserror
# CsFreeSystem(gage.gagehandle)
