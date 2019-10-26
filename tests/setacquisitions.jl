using GageCompuscope
using GageCompuscope.LibGage
using Lazy

acq = CSACQUISITIONCONFIG()
channel = CSCHANNELCONFIG(1)
trigger = CSTRIGGERCONFIG(1)

# %% Exposed Acquisition configuration.
function set_samplerate(acqconfig)
    acqconfig
end
set_datalength()
set_acqmode()

# %% Exposed channel configuration.
function input_impedance(channel_index, impedance)
    @switch impedance begin
        "low"
        1
        "high"
        2
    end
end

function input_range(channel_index, )
    body
end

# %% Triggers
const trigger_conditions = Dict("rising" => CS_TRIG_COND_POS_SLOPE,
    "falling" => CS_TRIG_COND_NEG_SLOPE,
    "pulse_width" => CS_TRIG_COND_PULSE_WIDTH,
)
const trigger_sources = Dict("1" => CS_TRIG_SOURCE_CHAN_1,
    "2" => CS_TRIG_SOURCE_CHAN_2,
    "external" => CS_TRIG_SOURCE_EXT,
    "off" => CS_TRIG_SOURCE_DISABLE,
)

function trigger_on(trigger_number, source, level; condition = "rising")

end
