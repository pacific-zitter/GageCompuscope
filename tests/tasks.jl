using GageCompuscope
  using JLD2, FileIO
  using Dates

begin #Settings and structure initialization.
    gage = GageCard()

    A = gage.acquisition_config

    A.SampleRate = 1e8
    A.Depth = A.SegmentSize = 1e5
    A.Mode = CS_MODE_SINGLE
    A.SegmentCount = 100

    CsSet(gage)
    commit(gage)

    note = [C_NULL]
    M = MultipleRecord(gage)
    M.input_gage.hNotifyEvent = Ref(C_NULL)[]
end


begin # Setup folder and make a unique filename.
    holderfolder = mkpath(joinpath(homedir(),".gingercode"))
    date = now()
    r = Dates.format(date,dateformat"yyyymmdd-HMM")
    image_filename = "trefm"*r*".jld2"
    imgio = jldopen(joinpath(holderfolder,image_filename),"w")
    imgio["parameters"] = gage
end

function getData(g::GageCard, m::MultipleRecord)
    CsTransfer(m,g)
    return m.data_array
end


canacquire = Base.Condition()
cntr = Ref(0)
@async while true
    wait(canacquire)
    cntr[]+=1
    @info "CAN ACQUIRE $(cntr[])"
end

begin # Channels and communication.
    lines = Channel(32)
    [put!(lines, i) for i = 1:32]
    donebusy = Channel(32)
    data = Channel{Array{Int16,2}}(32)
end

begin # Task definitions
    function datacomplete(g::GageCard)
        !(get_status(g) > 0)
    end

    function acquire_data(g::GageCard)
        while true
            @info "acquire"
            l = take!(lines)
            start(g)
            timedwait(() -> datacomplete(g), 10.0)
            put!(donebusy, l)
            wait(canacquire)
        end
    end

    function transferData(g::GageCard, m::MultipleRecord)
        while true
            tok = take!(donebusy)
            @info "Xferdata $tok"
            darray = getData(g, m)
            put!(data, darray)
            notify(canacquire)
        end
    end

    function saveData()
        line_number = Ref(0)
        while true
            d = take!(data)
            line_number[] += 1
            lstr = lpad(string(line_number[]), 4, "0")

            imgio["image/line"*lstr] = d
        end
    end
end

xtask = @async transferData(gage, M)

stask = @async saveData()

h1 = @async acquire_data(gage)

close(lines)
close(data)
close(donebusy)
close(imgio)


abort(gage)

q = load(joinpath(holderfolder,image_filename))

ll= q["image/line0001"]
mline=ll[:,1]

plot(mline)

free_system(gage)
