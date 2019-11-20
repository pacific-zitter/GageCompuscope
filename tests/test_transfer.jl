using GageCompuscope
using JLD2, FileIO
using TimerOutputs
const to = TimerOutput()
gage = GageCard(true)

set_samplerate(gage, 1e7)
set_segmentsize(gage, 16384)
set_segmentcount(gage, 10)
set_trigger!(gage, 1, 15)
set_trigger!(gage, 2, 0, "off")
set_trigger!(gage, 3, 0, "off")
data = MultipleRecord(gage)
const TIMEOUT = 10.0

start(gage)
get_status(gage)
Array(g::MultipleRecord) = g.data_array

fpath = ENV["USERPROFILE"]

Base.unsafe_convert(::Type{Ptr{G}}, x::G) where {G<:GageConfig} =
  Base.unsafe_convert(Ptr{G}, Ref(x))

start(gage)
done_busy()
@time CsTransfer(data, gage)

# jlpath = jldopen(joinpath(fpath, "eg.jld2"), "w+")


done_busy() = get_status(gage) == 0


function dox(gage, data)
  for i = 1:50
    @info i
    @timeit to "start" start(gage)
    @timeit to "wait for ready" begin
      @timeit to "wait" timedwait(done_busy,1.0)
    end
    @timeit to "transfer" begin
      @timeit to "cstransfer" CsTransfer(data, gage)
    end
    # lnum = lpad(string(i), 4, "0")
    # jlpath["image/line$lnum"] = Array(data)
  end
end

dox(gage, data)

print_timer(to)



close(fpath)
r = load(joinpath("eg.jld2"))
free_system(gage)
