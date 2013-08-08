

con c_login_info = [Username = string, Password = string]

con c_user_record = [Email = string] ++ c_login_info

table user : $([Id = int] ++ c_user_record)
  PRIMARY KEY Id

val st_ru : state = {Lang = "RU"}

val st_en : state = {Lang = "EN"}

val template : state -> scheme -> page = fn st s => let
  val b = s.Body st
  val l = s.Login st
  val xml = (<xml>
           <head>
             <title>{[s.Title]}</title>
           </head>
           <body>
             <h1>The body</h1>
             <a link={l}>Login</a>
             <hr/>
             {b}
             <hr/>
             <p>Current language is in {[st.Lang]}</p>
           </body>
         </xml>)
  in xml end

cookie userSession : $(c_login_info)

fun withAuth li page =
	re <- oneOrNoRows1( SELECT user.Id
                      FROM   user 
                      WHERE  user.Username = {[li.Username]} 
                      AND    user.Password = {[li.Password]} );
	case re of
    None => error <xml>Invalid Login</xml> |
	  Some _ => 
	  		setCookie userSession {
            Value = li
          , Expires = None
          , Secure = False
          };
        page

and login st = let
  val s : scheme =
    { Title = "Login to UrCMS"
    , Login = fn st' => login st'
    , Body = fn st' =>
        <xml>
          <form>
            <p>
              Username: <br/><textbox{#Username}/><br/>
              Password: <br/><password{#Password}/><br/>
              <submit value="Login" action={loginHandler}/>
            </p>
          </form>
        </xml>
    }
  in return (template st s) end

and loginHandler li =
  withAuth li (return
    <xml>
      <head><title>Logged in</title></head>
      <body>
        <h1>Logged in</h1>
      </body>
    </xml>)

fun main' st = let
  val s : scheme =
    { Title = "main"
    , Login = fn st' => login st'
    , Body = fn st' =>
              <xml>
                <h1>zzzzz</h1>
              </xml>
    }
  in return (template st s) end

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

