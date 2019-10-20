using GageCompuscope
using GageCompuscope.LibGage

gage = GageCard(0)
struct STMSTATUS
end

struct Folio
    pbuffer::Ptr{Cvoid}
    size::Cuint
end

const FolioArray = Array{Folio,1}
struct FolioArrObj
    l::Cushort
    arr::NTuple{4,Folio}
end

Base.convert(::Type{FolioArrObj},x::FolioArray) = FolioArrObj(4,ntuple(i->x[i],4))


function regbuffers(handle,index,stmbufferlist,sema,status)
    ccall((:CsRegisterStreamingBuffers,:CsSsm),
    Cint,
        (Cuint,Cuchar,Ref{FolioArrObj},Ptr{Cvoid},Ref{STMSTATUS}),
        handle,index,stmbufferlist,sema,status)
end

mem = [zeros(Int16,8192) for i in 1:4]

blist = [Folio(pointer(mem[i]),8192) for i in 1:4]
q = STMSTATUS()
regbuffers(gage.gagehandle,0,blist,C_NULL,q)

CsGetErrorString(-45)
