
fun main {} : transaction page  =
  b <- JQM_js.binary ();
  returnBlob b (blessMime "text/javascript")

