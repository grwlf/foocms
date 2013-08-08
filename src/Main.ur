
fun main' st = let
  val s = { Body = fn st' =>
              <xml>
                <a link={Auth.login st'}>Login</a>
                <h1>zzzzz</h1>
              </xml>
          , Login = fn st' => Auth.login st'
          , Title = "main"
          }
  in return (Tmpl.template st s) end

fun main {} = main' {Lang = "EN"}

fun mainA {} = 
  return <xml>
           <head>
             <title>TheTitle</title>
           </head>
           <body>
             <h1> The body </h1>
             <hr/>
             Body
             <hr/>
           </body>
         </xml>
