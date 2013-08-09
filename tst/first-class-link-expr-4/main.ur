(* 

Attempt to pass first-class function as a link expression. Trying to encode
links prior to passing them to the template. template is pure now.

Doesn't work as is due to XML Unification error.

Does work if remove all calls to reload but one

Does work if place template's definition after the main' (need to change 'fun' to 'and')

*)

fun template (reload : lang -> atag) (l:lang) : page =
   <xml>
     <head>
       <title>MultyLang page</title>
     </head>
     <body>
       <h1>The body</h1>
       <p>Current page is in {[l]}</p>
       <p>The content</p>
       <p>Other languages:</p>
       {reload "En"}
       {reload "Fr"}
       {reload "Ru"}
     </body>
   </xml>

fun main' (l:lang) : transaction page = let
  val reloader = fn (l':lang) => <xml><p><a link={main' l'}>Switch to {[l']}</a></p></xml>
  in return (template reloader l) end

fun main {} : transaction page = main' "En"

