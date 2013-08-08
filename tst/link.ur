
val target : {A:string, B:int} -> unit -> transaction page = fn x unit =>
  return
    <xml>
      <body>
        Welcome!
        <p> {[x.A]} </p>
      </body>
    </xml>

fun main () =
  return
    <xml>
      <body>
        <a link={ target {A="RU",B=1} ()}>Go RU</a>
        <a link={ target {A="EN",B=0} ()}>Go EN</a>
      </body>
    </xml>
