
con c_login_info = [Username = string, Password = string]

con c_user_record = [Email = string] ++ c_login_info

val withAuth : $(c_login_info) -> transaction page -> transaction page

val login : unit -> transaction page

val loginHandler : $(c_login_info) -> transaction page

