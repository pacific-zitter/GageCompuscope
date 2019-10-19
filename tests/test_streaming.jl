using GageCompuscope

gage = GageCard(0)

set_samplerate(gage, 10^7)
set_segmentsize(gage, 10000)
set_segmentcount(gage,100)
xfer = Transfer(gage)


begin
    start(gage)
    while get_status(gage) > 0
        sleep(1e-2)
    end
    @info "Starting Transfer."

    d = @async transfer_data(gage,xfer)
    start(gage)

    r= fetch(d)
end

function until_ready(g::GageCard;timeout=10.0)
    status = get_status(gage)
    t1 = time()
    while status > 0
        sleep(1e-2)
        time() - t1 > timeout && break
        status = get_status(gage)
    end
end

until_ready(gage)
free_system(gage)
