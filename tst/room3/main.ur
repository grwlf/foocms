(* 

Attempt to pass first-class function as a link expression does not work even
with finite datatypes.

Compiler errors

[grwlf@greyblade ~/proj/foocms/tst/room3 ]$ urweb -dbms sqlite app
/home/grwlf/proj/foocms/tst/room3/main.ur:23:22: (to 23:31) Invalid Link expression
Expression UNBOUND_2 Ru
/home/grwlf/proj/foocms/tst/room3/main.ur:24:22: (to 24:31) Invalid Link expression
Expression UNBOUND_2 En

*)

datatype lang = Ru | En

fun lang2str l = case l of Ru => "ru" | En => "en"

fun main' (l:lang) = template (main') ("Site in " ^ (lang2str l)) l

and template :
     (lang -> transaction page) 
  -> string
  -> lang 
  -> transaction page = fn reload b l =>
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={main' l}> Go to some place (keeping the language) </a>
             <hr/>
             {[b]}
             <hr/>
             <a link={reload Ru}>View in RU</a>
             <a link={reload En}>View in EN</a>
           </body>
         </xml>

fun main {} = main' En

