
type state = {Lang: string}

type scheme = {
    Title : string
  , Login : state -> transaction page
  , Body : state -> xbody
  }

(* val main' : state -> transaction page *)

val main : unit -> transaction page

val mainA : unit -> transaction page
