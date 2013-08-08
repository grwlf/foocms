
type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

fun main' st = template st (main') ("Site in" ^ st.Lang)

and template :
     state 
  -> (state -> transaction page) 
  -> string
  -> transaction page = fn st reload body =>
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={main' st}> Go to Main </a>
             <hr/>
             {[body]}
             <hr/>
             <a link={reload st_ru}>View in RU</a>
             <a link={reload st_en}>View in EN</a>
           </body>
         </xml>

fun main {} = main' st_en

