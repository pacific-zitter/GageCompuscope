using Blink, Interact
using Lazy
using GageCompuscope

function initialize_app()
    bwin = Window()
    gage = GageCard(0)
end
choose_savepath = filepicker();
select_gagecard = dropdown(OrderedDict("CS140040U" => 393227));

#------------ Basic config
sample_rate = dropdown(
    OrderedDict("⭕ 100 kHz" => 10^5, "⭕ 1 MHz" => 10^6, "⭕ 10 MHz" => 10^7),
    label = "∿ Sample Rate",
);
numsamples_request = spinbox(1000:1:2^32, "Samples Requested?");
segment_count = spinbox(1:10000; label = "Samples per Acquisition");
trigger_level = spinbox(1:100; label = "Trigger Level ( % )");
ui2 = vbox(sample_rate, numsamples_request, segment_count, trigger_level);

# %% Action Panel
bstart = button("Start");
babort = button("Abort");
bforce = button("Force");
bcommit = button("Commit");
gagebuttons = vbox(bstart, babort, bforce, bcommit);

# %% Settings
acquisition
