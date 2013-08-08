
type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

(* Is it xbody or no? *)
type insides = (xml ([Body = (), Dyn = (), MakeForm = ()]) ([]) ([]))

type scheme = {
    Title : string
  , Body : state -> transaction insides
  (* Reload the page in different language *)
  , Me : state -> transaction page
  }

fun main' st = template
    { Title = "main"
    , Body = fn st' => return
      <xml>
      <h2>Main body</h2>
      </xml>
    , Me = fn st' => main' st'
    } st

and template : scheme -> state -> transaction page = fn s st =>
  b <- s.Body st;
  return <xml>
           <head>
             <title>{[s.Title]}</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={main' st}> Login </a>
             <hr/>
             {b}
             <hr/>
             <p>Current language is in {[st.Lang]}</p>
             <a link={s.Me st_ru}>View in RU</a>
             <a link={s.Me st_en}>View in EN</a>
           </body>
         </xml>

fun main {} = main' st_en

