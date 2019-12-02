using TimerOutputs
using GageCompuscope

gage = GageCard()

A = gage.acquisition_config
C1 = gage.channel_config[1]
C2 = gage.channel_config[2]

A["SegmentSize"] = A["Depth"] = 1e6
A["SegmentCount"] = 100
A["Mode"] = CS_MODE_DUAL

C2.InputRange = C1.InputRange = CS_GAIN_2_V
C2.Filter = C1.Filter = CS_FILTER_ON
CsSet(gage)
commit(gage)


Chnl1 = MultipleRecord(gage)
Chnl2 = MultipleRecord(gage)
shouldstop = Ref(false)
to = TimerOutput()
const vb1 = similar(Chnl1.data_array, Float64)
const vb2 = similar(Chnl2.data_array, Float64)

dataComplete(g::GageCard) = (get_status(g) < 1);
begin
    tstart = time()
    t1 = @async while true
        @timeit to "Acquire Data." begin
            start(gage)
            timedwait(() -> dataComplete(gage), 10.0, pollint = 1e-3)
        end
        @timeit to "Transfer." begin
            @timeit to "Channel 1" data1 = Chnl1(1)
            @timeit to "Channel 2" data2 = Chnl2(2)
        end
        @timeit to "Voltage Conversion." begin
            @timeit to "v1" GageCompuscope.to_voltage!(
                vb1,
                data1.data_array,
                A["SampleOffset"],
                A["SampleRes"],
                C1["InputRange"],
                0,
            )
            @timeit to "v2" GageCompuscope.to_voltage!(
                vb2,
                data2.data_array,
                A["SampleOffset"],
                A["SampleRes"],
                C2["InputRange"],
                0,
            )
        end
        time()-tstart > 360. && break
         shouldstop[] && break
    end
end #endbegin
sizeof(Chnl1.data_array) * inv(1e6)*inv(200e-3)
time()-tstart[]
istaskstarted(t1)
shouldstop[] = true
print_timer(to)

tasks = Vector{Task}(undef,4)
for i=1:4
    t1 = @async while true
            data1 = Chnl1(1)
            GageCompuscope.to_voltage!(
            vbb1,
                data1.data_array,
                A["SampleOffset"],
                A["SampleRes"],
                C1["InputRange"],
                0,
            )
    end
end

t1 = @async while true
    @timeit to "Acquire Data." begin
        start(gage)
        timedwait(() -> dataComplete(gage), 10.0, pollint = 1e-3)
    end
end
