
table user : $([Id = int] ++ c_user_record)
  PRIMARY KEY Id

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

and login st = return (Tmpl.template st
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
  })

and loginHandler li =
  withAuth li (return
    <xml>
      <head><title>Logged in</title></head>
      <body>
        <h1>Logged in</h1>
      </body>
    </xml>)

