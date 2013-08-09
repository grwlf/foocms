(* 

Using first-class funcs as link expressions, packed in structure 'scheme'.

Still doesn't work: triggers 'Invalid link expression' error.

*)

type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

type lpage = state -> transaction page

type scheme = { Smain : lpage
              , Sreload : lpage
              , SomeTemplateArg : int
              }

fun ugly_template (s_main : lpage) (s_reload : lpage) (st : state) (b:string) : transaction page =
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={s_main st}> Go to specific place (keeping the language) </a>
             <hr/>
             {[b]}
             <hr/>
             <a link={s_reload st_ru}>View in RU</a>
             <a link={s_reload st_en}>View in EN</a>
           </body>
         </xml>

fun template (sch : scheme) st b = ugly_template sch.Smain sch.Sreload st b

fun main' (st:state) = template {Smain = main', Sreload = main', SomeTemplateArg = 0} st ("Site in " ^ st.Lang) 

fun main {} = main' st_en

