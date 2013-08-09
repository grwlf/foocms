(* 

Attempt to pass first-class function as a link expression. Trying to encode
links prior to passing them to the template. template now is pure.

Doesn't work

*)

datatype lang = Ru | En

fun lang2str l = case l of Ru => "ru" | En => "en"

fun main' (l:lang) = let
  val reloader = fn (l':lang) => <xml><p><a link={main' l'}>Switch to {[lang2str l']}</a></p></xml>
  in return (template reloader l) end

and template reload (l:lang) =
   <xml>
     <head>
       <title>MultyLang page</title>
     </head>
     <body>
       <h1>The body</h1>
       <p>Current page is in {[lang2str l]}</p>
       <p>The content</p>
       <p>Other languages:</p>
       {reload Ru}
       {reload En} (* Compiles if one remove second call to chlang *)
     </body>
   </xml>

fun main {} = main' En

