(* 

Using first-class funcs as link expressions, packed in structure 'scheme'.

Still doesn't work: triggers 'Invalid link expression' error.

*)

type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

type scheme = { Smain : state -> transaction page
              , Sreload : state -> transaction page
              }

fun template (s : scheme) (st : state) (b:string) : transaction page =
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={s.Smain st}> Go to specific place (keeping the language) </a>
             <hr/>
             {[b]}
             <hr/>
             <a link={s.Sreload st_ru}>View in RU</a>
             <a link={s.Sreload st_en}>View in EN</a>
           </body>
         </xml>

fun main' (st:state) = template {Smain = main', Sreload = main'} st ("Site in " ^ st.Lang) 

fun main {} = main' st_en

