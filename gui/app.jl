using Blink, Interact
    using Lazy
    using DataStructures: CircularBuffer
    using GageCompuscope
include("custom_widgets.jl")

function initialize_app()
    bwin = Window(; async = false)
    gage = GageCard(0)
    bwin, gage
end

bwin, gage = initialize_app()

#------------ Basic config
sample_rate = dropdown(
    OrderedDict("⭕ 100 kHz" => 10^5, "⭕ 1 MHz" => 10^6, "⭕ 10 MHz" => 10^7),
    label = "Sample Rate",
);
numsamples_request = spinbox(1000:1:2^32, label = "Samples Requested?");
segment_count = spinbox(1:10000; label = "v Samples per Acquisition");
trigger_level = spinbox(1:100; label = "Trigger Level ( % )");
ui1 = vbox(sample_rate, numsamples_request, segment_count, trigger_level);

# %% Action Panel
bstart = button("Start");
babort = button("Abort");
bforce = button("Force");
bcommit = button("Commit");
gagebuttons = vbox(bstart, babort, bforce, bcommit);

# %% Debug
note_buffer = CircularBuffer{String}(10)
dbg = widget(note_buffer);
sts = gagestatus(gage)
# %% Actions and UI interaction.
Interact.@on set_samplerate(gage, &sample_rate);
Interact.@on (&bstart; println(start(gage)));
Interact.@on (&babort; println(abort(gage)));


# %% Application layout.
application = vbox(hbox(pad(4px, ui1), pad(0.5em, gagebuttons),), dbg);

body!(bwin, application)
