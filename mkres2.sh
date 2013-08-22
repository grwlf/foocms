#!/bin/sh

msg() { echo $@ >&2 ; }
die() { exit 1 ; }
usage() { msg "Usage: `basename $0` TGT FILE1 FILE2 .." ; }

TGT=$1
shift
FILE="$@"

if ! test -n "$TGT" -a -d "$TGT"; then
  usage; msg "Target is not a directory" ; die
fi

test -z "$LD" && LD=ld
test -z "$CC" && CC=gcc

TMP=`mktemp -d`
msg "Working in $TMP"

ff=$FILE
msg "Processing $ff"

f=`basename $ff | sed 's/[\.-]/_/g' | sed 's/^\(.\)/\u\1/'`

(
cp $ff $TMP/${f} && cd $TMP && $LD -r -b binary -o $TMP/${f}.bin.o $f
)

cat >$TMP/${f}_c.urs <<EOF
val binary : unit -> transaction blob
EOF

cat >$TMP/${f}.urs <<EOF
val binary : unit -> transaction blob
val blob : unit -> transaction page
EOF

cat >$TMP/${f}.ur <<EOF
fun binary {} = ${f}_c.binary ()
fun blob {} : transaction page = 
  b <- ${f}_c.binary ();
  returnBlob b (blessMime "text/plain")
EOF

cat >$TMP/${f}.c <<EOF
// Thanks, http://stupefydeveloper.blogspot.ru/2008/08/cc-embed-binary-data-into-elf.html
#include <urweb.h>
#include <stdio.h>
extern int _binary_${f}_start;
extern int _binary_${f}_size;
uw_Basis_blob  uw_${f}_binary (uw_context ctx, uw_unit unit)
{
  uw_Basis_blob blob;
  blob.data = (char*)&_binary_${f}_start;
  blob.size = (size_t)&_binary_${f}_size;
  return blob;
}
EOF

cat >$TMP/${f}.h <<EOF
#include <urweb.h>
uw_Basis_blob uw_${f}_binary (uw_context ctx, uw_unit unit);
EOF

$CC -c -I ~/local/include/urweb -o $TMP/${f}.o $TMP/${f}.c

cat >$TMP/${f}.urp <<EOF
ffi ${f}_c
include ${f}.h
link ${f}.o
link ${f}.bin.o

${f}
EOF

mv -ft $TGT $TMP/*

