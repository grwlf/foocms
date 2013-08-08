
val st_ru = {Lang = "RU"}
val st_en = {Lang = "EN"}

fun template st s = let
  val b = s.Body st
  val xml = (<xml>
           <head>
             <title>{[s.Title]}</title>
           </head>
           <body>
             <h1> The body </h1>
             <hr/>
             {b}
             <hr/>
             <p>Current language is {[st.Lang]}</p>
             <a link={template st_ru s}>View in RU</a>
             <a link={template st_en s}>View in EN</a>
           </body>
         </xml>)
  in xml end
