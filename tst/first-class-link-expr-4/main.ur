(* 

Attempt to pass first-class function as a link expression. Trying to encode
links prior to passing them to the template. template is pure now.

Doesn't work due to XML Unification error.

*)

fun main' (l:lang) = let
  val reloader = fn (l':lang) => <xml><p><a link={main' l'}>Switch to {[l]}</a></p></xml>
  in return (template reloader l) end

and template reload (l:lang) =
   <xml>
     <head>
       <title>MultyLang page</title>
     </head>
     <body>
       <h1>The body</h1>
       <p>Current page is in {[l]}</p>
       <p>The content</p>
       <p>Other languages:</p>
       {reload "Ru"}
       {reload "En"} (* Compiles if one remove second call to reload *)
     </body>
   </xml>

fun main {} = main' "En"

