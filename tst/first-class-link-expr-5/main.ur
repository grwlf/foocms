(* 

Using first-class funcs as link expressions.

Works with patched UrWeb

$ urweb -version
The Ur/Web compiler, version 20130421 + a3d795fbecb9+ tip

*)

type state = {Lang: string}

val st_ru : state = {Lang = "RU"}
val st_en : state = {Lang = "EN"}

(*
Note that argument order DOES matter. For example, we can't put (b:string)
between pmain and reload, because compiler refuses to calculate correct link
name in this case.
*)
fun template (pmain : state -> transaction page) (reload : state -> transaction page) (st : state) (b:string) : transaction page =
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={pmain st}> Go to specific place (keeping the language) </a>
             <hr/>
             {[b]}
             <hr/>
             <a link={reload st_ru}>View in RU</a>
             <a link={reload st_en}>View in EN</a>
           </body>
         </xml>


fun main' (st:state) = template (main') (main') st ("Site in " ^ st.Lang) 

fun main {} = main' st_en

