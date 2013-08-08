
type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

(* Is it xbody or no? *)
type insides = (xml ([Body = (), Dyn = (), MakeForm = ()]) ([]) ([]))

type scheme = {
    Title : string
  , Login : state -> transaction page
  , Body : state -> transaction insides
  }

val template : scheme -> state -> transaction page = fn s st => let
  val l = (s.Login st) in
  b <- s.Body st;
  return <xml>
           <head>
             <title>{[s.Title]}</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={l}> Login </a>
             <hr/>
             {b}
             <hr/>
             <p>Current language is in {[st.Lang]}</p>
           </body>
         </xml>
         end

fun main' st = template
    { Title = "main"
    , Login = fn st' => main' st'
    , Body = fn st' => return
      <xml>
      <h2>Main body</h2>
      </xml>
    } st

fun main {} = main' st_en

