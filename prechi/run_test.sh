#!/bin/sh

make -C test
if [[ 0 < $? ]]; then
  echo "Make failed $?"
  exit $?
fi

if test -z "$CUTTER"; then
  #CUTTER="`make -s -C $BASE_DIR echo-cutter`"
  CUTTER="cutter"
fi

$CUTTER -s . "$@" test
