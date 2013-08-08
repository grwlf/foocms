
fun template body =
  b <- body;
  return <xml>
    <head>
    </head>
    <body>
    {b}
    </body>
  </xml>
