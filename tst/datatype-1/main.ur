
datatype content = Article | Error 

type state = {Lang: string, Page : content }

val st_ru : state = {Lang = "RU", Page = Article }
val st_en : state = {Lang = "EN", Page = Article }

type lpage = state -> transaction page

type scheme = { Smain : lpage
              , Sreload : lpage
              , SomeTemplateArg : int
              }

fun template (s : scheme) (st : state) (transaction page) : transaction page =
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

fun cmsmap (st:state) = 
  case st.Page of
      Article =>
    | Error => template {Smain = main', Sreload = main', SomeTemplateArg = 0} st ("Site in " ^ st.Lang) 

fun main {} = main' st_en

