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

(* Articles *)

style css_article

table article : { Id : int, Caption : string, Text : blob }
  PRIMARY KEY Id

task initialize = fn {} => 
  b <- Article_html.binary {};
  e <- tryDml (INSERT INTO article (Id, Caption, Text) VALUES (0, "Sample", {[b]}));
  return {}

(* CSS *)

fun css {} : transaction page =
  b <- Style_css.binary ();
  returnBlob b (blessMime "text/css")

(* Languages *)

datatype lang = RU | EN | FR
val show_lang = mkShow (fn l => case l of
  RU => "ru" | FR => "fr" | EN => "en")

(* Content types *)

datatype content = Greetings | Article of int | Error

datatype form = Login of content | View of content

datatype state = ST of {Lang: lang, Page : form}
val defstate : state = ST {Lang = EN, Page = View Greetings }

fun unstate (st:state) = case st of ST st => st

fun mapstate (f:{Lang: lang, Page : form} -> {Lang: lang, Page : form}) (st:state) : state = case st of ST st => ST (f st)

fun mapcontent f = mapstate (fn st => {Lang=st.Lang, Page=(f st.Page)})
val greet = mapcontent (fn _ => (View Greetings))
(* val article = mapcontent (fn _ => (View (Article 0))) *)
val article' n = mapcontent (fn _ => (View (Article n)))

fun maplang f = mapstate (fn st => {Lang=(f st.Lang), Page=st.Page})
val lang_ru = maplang (fn _ => RU)
val lang_en = maplang (fn _ => EN)
val lang_fr = maplang (fn _ => FR)

val login = mapcontent (fn c => case c of View c => Login c | Login c => Login c)
val unlogin = mapcontent (fn c => case c of View c => View c | Login c => View c)

(* Main part *)

type scheme = { SomeTemplateArg : int
              , AnotherTemplateArg : bool
              }

style css_topmenu

fun template (s : scheme) (st : state) (tb : transaction xbody) : transaction page =
  b <- tb;
  return <xml>
           <head>
             <title>MultyLang page</title>
             <link rel="stylesheet" typ="text/css" href={url (css ())}/>
           </head>
           <body onload={JQM_wrapper.init css_topmenu}>

             <h1>The body</h1>

             <div class={css_topmenu}>
               <ul>
                   <li><a link={main ()} title="Меню 1">Меню 1</a>
                       <ul>
                          <li><a link={main ()} title="Элемент 1.1">Элемент 1.1</a></li>
                          <li><a link={main ()} title="Элемент 1.2">Элемент 1.2</a></li>
                          <li><a link={main ()} title="Элемент 1.3">Элемент 1.3</a></li>
                       </ul>
                   </li>
                   <li><a link={main ()} title="Меню 2">Меню 2</a>
                       <ul>
                          <li><a link={main ()} title="Элемент 2.1">Элемент 2.1</a></li>
                          <li><a link={main ()} title="Элемент 2.2">Элемент 2.2</a></li>
                          <li><a link={main ()} title="Элемент 2.3">Элемент 2.3</a></li>
                       </ul>
                   </li>
                   <li><a link={main ()} title="Меню 3">Меню 3</a>
                       <ul>
                          <li><a link={main ()} title="Элемент 3.1">Элемент 3.1</a></li>
                          <li><a link={main ()} title="Элемент 3.2">Элемент 3.2</a></li>
                          <li><a link={main ()} title="Элемент 3.3">Элемент 3.3</a></li>
                       </ul>
                   </li>
               </ul>      
             </div>
             <a link={sitemap (greet st)}> Main </a>
             <h6>(the site is in {[(unstate st).Lang]})</h6>
             <hr/>
             {b}
             <hr/>
             <a link={sitemap (lang_ru st)}>View in RU</a>
             <a link={sitemap (lang_en st)}>View in EN</a>
             <a link={sitemap (lang_fr st)}>View in FR</a>
             <a link={sitemap (login st)}>Login</a>
           </body>
         </xml>

and sitemap (st:state) =
  case (unstate st).Page of
    View c => (case c of
      Greetings =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          return <xml>
            Greetings!
            Read an <a link={sitemap (article' 0 st)}>article</a>
          </xml>)
      |Article n =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = True} st (
          r <- oneOrNoRows1(
            SELECT article.Text FROM article WHERE article.Id = 0);
          case r of
            None => return <xml>No such article</xml>
            |Some a =>
              t <- return (Process.blobXml a.Text);
              return <xml><div class={css_article}>{t}</div></xml>
          )
     |Error =>
        template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
          return <xml>
            Error haha
          </xml>
          ))
    |Login c =>
      let

        fun login_form {} =
          <xml>
            <form>
              Username: <br/><textbox{#Login}/><br/>
              Password: <br/><password{#Pass}/><br/>
              <submit value="Login" action={handler st}/>
            </form>
          </xml>

        and handler (st:state) frm = template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
          re <- oneOrNoRows1(
            SELECT user.Id FROM user WHERE user.Login = {[frm.Login]} AND user.Pass = {[frm.Pass]} );
          case re of
            None => return
              <xml>
                Invalid Login
                <hr/>
                {login_form {}}
              </xml>
            |Some u =>
              setCookie userSession { Value = (frm ++ {Id=u.Id}), Expires = None, Secure = False};
              return <xml>
                Login succeeded. Go <a link={sitemap (unlogin st)}>next</a>
              </xml>)
      in template {SomeTemplateArg = 0, AnotherTemplateArg = False} st (
        return <xml>
          Login, please
          {login_form {}}
        </xml>)
      end

and page (n:int) = sitemap (article' n defstate)

and main {} = sitemap defstate

fun jqm_main a = JQM.main a

