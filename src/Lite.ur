(* Users *)

datatype role = Admin | User | Employee | Guest
val show_role = mkShow (fn l => case l of
  Admin => "Admin" | User => "User" | Employee => "Employee" | Guest => "Guest")

con c_user_cookie = [Id = int, Login = string, Pass = string]
con c_user_profile = c_user_cookie ++ [Role = serialized role]

type user_cookie = $(c_user_cookie)
type user_profile = $(c_user_profile)
table user : $(c_user_profile)
  PRIMARY KEY Id

cookie userSession : user_cookie

(* Languages *)

datatype lang = RU | EN | FR
val show_lang = mkShow (fn l => case l of
  RU => "ru" | FR => "fr" | EN => "en")

(* Content types *)

datatype content = Greetings | Article | Error

datatype state = ST of {Lang: lang, Page : content}

val defstate = ST {Lang = EN, Page = Greetings }

fun chlang (s:state) (l:lang) : state = case s of ST s => ST ((s -- #Lang) ++ { Lang = l })
fun chcont (s:state) (c:content) : state = case s of ST s => ST ((s -- #Page) ++ { Page = c })
fun lang_ru s = chlang s RU
fun lang_en s = chlang s EN
fun lang_fr s = chlang s FR
fun unstate (st:state) = case st of ST st => st
fun greet s = chcont s Greetings


type foopage = state -> transaction page

(* Templates *)
fun flip f a b = f b a

type scheme = { Self : foopage
              , SomeTemplateArg : int
              , AnotherTemplateArg : bool
              }

fun for s : scheme = s ++ { SomeTemplateArg = 0, AnotherTemplateArg = False }

fun template (s : scheme) (st : state) (tb : transaction xbody) : transaction page =
  b <- tb;
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={s.Self (greet st)}> Main </a>
             <h6>(the site is in {[(unstate st).Lang]})</h6>
             <hr/>
             {b}
             <hr/>
             <a link={s.Self (lang_ru st)}>View in RU</a>
             <a link={s.Self (lang_en st)}>View in EN</a>
             <a link={s.Self (lang_fr st)}>View in FR</a>
           </body>
         </xml>

fun sitemap (st:state) =
  case (unstate st).Page of
      Greetings =>
        template {Self = sitemap, SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          return <xml>
            Greetings!
            <a link={login st}>Login</a> or read an <a link={sitemap (chcont st Article)}>article</a>
          </xml>)
    | Article =>
        template {Self = sitemap, SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          return <xml>
            An article
            <a link={login st}>Login</a>
          </xml>)
    | Error =>
        template {Self = sitemap, SomeTemplateArg = 0, AnotherTemplateArg = False} st (
          return <xml>
            Error haha
          </xml>
        )

and login (st:state) =
  let
    fun handler (st:state) frm = template {Self = flip handler frm, SomeTemplateArg = 0, AnotherTemplateArg = False} st (
      re <- oneOrNoRows1( SELECT user.Id
                          FROM   user 
                          WHERE  user.Login = {[frm.Login]} AND user.Pass = {[frm.Pass]} );
      case re of
        None => return <xml>Invalid Login</xml> |
        Some u =>
          setCookie userSession { Value = (frm ++ {Id=u.Id}), Expires = None, Secure = False};
          return <xml>
            Login succeeded. Go <a link={sitemap st}>next</a>
          </xml>)
  in template {Self = login, SomeTemplateArg = 0, AnotherTemplateArg = False} st (
    return <xml>
      Login please
      <form>
        <p>
          Username: <br/><textbox{#Login}/><br/>
          Password: <br/><password{#Pass}/><br/>
          <submit value="Login" action={handler st}/>
        </p>
      </form>
    </xml>)
  end

fun main {} = sitemap defstate

fun dummy {} = return <xml>custom xml</xml>

