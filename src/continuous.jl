using GageCompuscope
using GageCompuscope.LibGage
using Observables


gage = GageCard(0)

acquisition = gage.acquisition_config
channel = gage.channel_config
triggers = gage.trigger_config

set_cfg!(gage,:channel)

xfer = Transfer(gage)
