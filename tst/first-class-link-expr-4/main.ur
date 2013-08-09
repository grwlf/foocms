(* 

Attempt to pass first-class function as a link expression. Trying to encode
links prior to passing them in the template

[grwlf@greyblade ~/proj/foocms/tst/first-class-link-expr-4 ]$ urweb -dbms sqlite app  -dumpTypes
/home/grwlf/proj/foocms/tst/first-class-link-expr-4/main.ur:30:3: (to 31:15) Unification failure
Expression:
Basis.join [<UNIF:U411::{Unit}>] [<UNIF:U412::{Type}>] [[]]
 [<UNIF:U414::{Type}>]
 (Basis.cdata [<UNIF:U411::{Unit}>] [<UNIF:U412::{Type}>] "\n")
 (Basis.join [<UNIF:U411::{Unit}>] [<UNIF:U412::{Type}>] [[]]
   [<UNIF:U414::{Type}>]
   (Basis.cdata [<UNIF:U411::{Unit}>] [<UNIF:U412::{Type}>]
     "             ")
   (Basis.join [<UNIF:U411::{Unit}>] [<UNIF:U412::{Type}>]
     [<UNIF:U414::{Type}>] [[]] (lnk l)
     (Basis.join [<UNIF:U411::{Unit}>]
       [<UNIF:U412::{Type}> ++ <UNIF:U414::{Type}>] [[]] [[]]
       (Basis.cdata [<UNIF:U411::{Unit}>]
         [<UNIF:U412::{Type}> ++ <UNIF:U414::{Type}>] "\n")
       (Basis.cdata [<UNIF:U411::{Unit}>]
         [<UNIF:U412::{Type}> ++ <UNIF:U414::{Type}>] "           "))))
  Have con:
xml <UNIF:U411::{Unit}> <UNIF:U412::{Type}> <UNIF:U414::{Type}>
  Need con:
xml <UNIF:U411::{Unit}> (<UNIF:U412::{Type}> ++ <UNIF:U414::{Type}>)
 <UNIF:U406::{Type}>
Constructor occurs check failed
Have:  <UNIF:U412::{Type}>
Need:  <UNIF:U412::{Type}> ++ <UNIF:U414::{Type}>

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

