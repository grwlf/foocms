
type state = {Lang: string}

type scheme = {
    Body : state -> xbody
  , Login : state -> transaction xbody
  , Title : string
  }

val template : state -> scheme -> page
