module GageCompuscope
using Reexport
using TimerOutputs
using Base: @kwdef

include(joinpath(@__DIR__, "..", "LibGage", "LibGage.jl"))
@reexport using .LibGage

include("gage_objects.jl")
include("gagecard.jl")
include("gageinterface.jl")
include("transfer.jl")
include("events.jl")
export getGageEvent, win32wait,win32reset,handle_events,dataComplete,hybrid_sleep
export GageCard,free_system,set_samplerate,set_segmentcount,set_cfg!,
      set_segmentsize,set_trigger!,set_channel!,get_status,cserror,start,abort,
      commit,force

export CsConfigBoardInfo,SystemInfo,AcquisitionCfg,ChannelCfg,TriggerCfg,
      MultipleRecord,NoNotify,dataReady,to_voltage


end
