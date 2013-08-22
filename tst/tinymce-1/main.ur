
fun main {} =
  return <xml>
           <head>
             <title>MultyLang page</title>
           </head>
           <body onload={init {}}>
             <script>{[funtion f() { return 3 ; } ]}</script>
             <h1>The body</h1>
             <hr/>
             The body
             <hr/>
           </body>
         </xml>

and init {} =
  Tinymce.init {};
  return {}
  
