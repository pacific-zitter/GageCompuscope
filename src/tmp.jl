
using LanguageServer

import SymbolServer


srv=LanguageServer.LanguageServerInstance(stdin,stdout,true)

srv.runlinter = true

@async run(srv)
