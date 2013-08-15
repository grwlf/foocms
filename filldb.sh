#!/bin/sh

FILE=`pandoc -f markdown -t html file.markdown | hexdump -ve '1/1 "%0.2X"'`

CSS=`hexdump -ve '1/1 "%0.2X"' style.css`

cat >fillscript.sql <<EOF
INSERT INTO uw_Lite_article (uw_id, uw_caption, uw_text ) VALUES (0, "Sample", X'$FILE' );
INSERT INTO uw_Lite_stylesheet(uw_id, uw_data) VALUES (0, X'$CSS');
EOF

# Create the database and give it the file as an input parameter.
sqlite3 FooCMS.db <fillscript.sql
