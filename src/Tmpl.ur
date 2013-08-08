
val st_ru :state = {Lang = "RU"}
val st_en :state = {Lang = "EN"}

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
           </body>
         </xml>)
  in xml end
