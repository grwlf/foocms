
con user_base = [Login = string, Pass = string] 
type user_info = $(user_base)
table user : $(user_base ++ [Id = int])
  PRIMARY KEY Id

cookie userSession : user_info


datatype lang = RU | EN | FR
val show_lang = mkShow (fn l => case l of
  RU => "ru" | FR => "fr" | EN => "en")


datatype content s = Greetings | Article | Error | Login of s

datatype state = ST of {Lang: lang, Page : content state}

val defstate = ST {Lang = EN, Page = Greetings }

fun chlang (s:state) (l:lang) : state = case s of ST s => ST ((s -- #Lang) ++ { Lang = l })
fun chcont (s:state) (c:content state) : state = case s of ST s => ST ((s -- #Page) ++ { Page = c })
fun lang_ru s = chlang s RU
fun lang_en s = chlang s EN
fun lang_fr s = chlang s FR
fun unstate (st:state) = case st of ST st => st
fun askLogin (st:state) :state = ST {Lang=(unstate st).Lang,Page=(Login (st))}
fun greet s = chcont s Greetings


type lpage = state -> transaction page

type scheme = { SomeTemplateArg : int
              , AnotherTemplateArg : bool
              }

fun template (s : scheme) (st : state) (tb : transaction xbody) : transaction page =
  b <- tb;
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={sitemap (greet st)}> Main </a>
             <h6>(the site is in {[(unstate st).Lang]})</h6>
             <hr/>
             {b}
             <hr/>
             <a link={sitemap (lang_ru st)}>View in RU</a>
             <a link={sitemap (lang_en st)}>View in EN</a>
             <a link={sitemap (lang_fr st)}>View in FR</a>
           </body>
         </xml>

and sitemap (st:state) =
  case (unstate st).Page of
      Greetings =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          return <xml>
            Greetings!
            <a link={sitemap (askLogin st)}>Login</a>
          </xml>) 
    | Article =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          return <xml>
            An article
            <a link={sitemap (askLogin st)}>Login</a>
          </xml>) 
    | Error =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
          return <xml>
            Error haha
          </xml>
        )
    | Login x =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
          return <xml>
            Login please
            <form>
              <p>
                Username: <br/><textbox{#Login}/><br/>
                Password: <br/><password{#Pass}/><br/>
                <submit value="Login" action={login x}/>
              </p>
            </form>
          </xml>
        )

and login (st:state) frm = template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
  return <xml>
    Login succeeded. Go <a link={sitemap st}>next</a>
  </xml>)


fun main {} = sitemap defstate

fun dummy {} = return <xml>custom xml</xml>

