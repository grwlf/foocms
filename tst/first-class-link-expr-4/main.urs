
type lang = string

type atag = xml ([Body = (), Dyn = (), MakeForm = ()]) ([]) ([])

val template : (lang -> atag) -> lang -> page

val main' : lang -> transaction page

val main : unit -> transaction page


