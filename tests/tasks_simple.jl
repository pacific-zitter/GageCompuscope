using GageCompuscope
 using JLD2
 using Dates

gage = GageCard()

function makegingerfile()
    folder = mkpath(joinpath(homedir(),".gingercode"))
    date = now()
    r = Dates.format(date,dateformat"yyyymmdd-HMM")
    image_filename = "trefm"*r*".jld2"
    return joinpath(folder,image_filename)
end

savname = makegingerfile()

A = gage.acquisition_config
A.Depth = A.SegmentSize = 16384
A.SegmentCount = 1920
A.Mode = CS_MODE_SINGLE
A.SampleRate = 2e8

C1 = gage.channel_config[1]
CsSet(gage); commit(gage)

newData = Channel{Int}()
gstatus = Ref(0)
function handlefail(g::GageCard, status)
    status < 0 && error(cserror(status),"Gage System has been released.")
end


function acquire(Gage::GageCard)
    # ccall((:CsLock,csssm),Cint,(Cuint,Cint),Gage.gagehandle,1)
    acqcount = Ref(0)
    while true
        st = start(Gage)
        handlefail(Gage,st)
        force(gage)
        while !(dataReady(Gage))
            gstatus[] = get_status(gage)
            # force(Gage) # For continuous acquisition.
        end
        put!(newData,1)
        @info "put"
        acqcount[] += 1
        @info acqcount[]
    end
end

function getData(g::GageCard,M::MultipleRecord)
    CsTransfer(g, M)
    return M.data_array
end

function transfer_thread(Gage::GageCard,channel_number)
    M = MultipleRecord(Gage)
    M.input_gage.Channel = channel_number; M.input_gage.h
    jldopen(savname,"a+") do jfile
    while true
        @info "waiting for data"
        take!(newData)
        @info "got data"

        d = getData(Gage)
        y=gensym(:line)

        jfile["image/$y-$(objectid(Gage))"] = d
    end
    end
end


function mainloop()
    for i=1:4
        Threads.@async transfer_thread(gage,1)
    end
    h = Threads.@async acquire(gage)
end

m1 = @sync mainloop()

close(newData)
