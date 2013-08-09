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
fun template (pmain : state -> transaction page) (reload : state -> transaction page) (st : state) b : transaction page =
  return <xml>
           <head>
             <title>MultiLang</title>
           </head>
           <body>
             <h1>A site supporting template and multiple languages</h1>
             <h5> Header </h5>
             <a link={pmain st}> Go to default place (keeps the language) </a>
             <hr/>
             <h2>Body</h2>
             {b}
             <hr/>
             <h5> Footer </h5>
             <a link={reload st_ru}>View in RU</a>
             <a link={reload st_en}>View in EN</a>
           </body>
         </xml>

fun article1 (st:state) = template (main') (article1) st
  (<xml><p>Article1 in {[st.Lang]}. See also <a link={article2 st}>article2</a></p></xml>) 

and article2 (st:state) = template (main') (article2) st
  (<xml><p>Article2 in {[st.Lang]}. See also <a link={main' st}>main</a></p></xml>) 

and main' (st:state) = template (main') (main') st
  (<xml><p>Site in {[st.Lang]}. Read <a link={article1 st}>an Article</a></p></xml>) 

fun main {} = main' st_en

