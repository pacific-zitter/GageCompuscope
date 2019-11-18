using GageCompuscope
using CBinding
using Libdl
gage = GageCard(true)
CsGetSystemCaps(gage.gagehandle,CAPS_MULREC,C_NULL,C_NULL)

free_system(gage)

ccall((:CsDrvTransferData))
