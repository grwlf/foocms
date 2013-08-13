fun handler (src : transaction page) r = return <xml><body>
  <table>
    <tr> <th>A:</th> <td>{[r.A]}</td> </tr>
    <tr> <th>B:</th> <td>{[r.B]}</td> </tr>
    <tr> <th>C:</th> <td>{[r.C]}</td> </tr>
  </table>
  <a link={src}>Back</a>
</body></xml>

fun login (src : transaction page) = return <xml><body>
  <form>
    <table>
      <tr> <th>A:</th> <td><textbox{#A}/></td> </tr>
      <tr> <th>B:</th> <td><textbox{#B}/></td> </tr>
      <tr> <th>C:</th> <td><checkbox{#C}/></td> </tr>
      <tr> <th/> <td><submit action={handler src}/></td> </tr>
    </table>
  </form>
</body></xml>

fun template (back : transaction page) = return <xml><body>
  <a link={login back}>Login</a>
</body></xml>

fun pageA () = template (pageA ())
fun pageB () = template (pageB ())

fun main () = return <xml><body>
  <a link={pageA ()}>Page A</a>
  <a link={pageB ()}>Page B</a>
</body></xml>

