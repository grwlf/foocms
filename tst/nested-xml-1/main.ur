(* works *)

fun subtemplate1 {} = <xml><div>Box</div></xml>

and subtemplate2 s = <xml><div>{[s]}</div></xml>

and subtemplate3 {} = <xml><p><a link={main {}}>ToMain</a></p></xml>

and subtemplate4 t = <xml><p><a link={template t}>ToTemplate</a></p></xml>

and template c = let
  val subtemplate5 = fn t => <xml><p><a link={template t}>ToTemplate from Let</a></p></xml>
  in
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <p>{[c]}</p>
             <p>Menu:</p>
             the text
             {subtemplate1 {}}
             {subtemplate1 {}}
             {subtemplate2 "aaa"}
             {subtemplate2 "bbb"}
             {subtemplate3 {}}
             {subtemplate3 {}}
             {subtemplate4 "111"}
             {subtemplate4 "222"}
             {subtemplate5 "subt5-1"}
             {subtemplate5 "222"}
           </body>
         </xml>
  end

and main {} = template "The content"

