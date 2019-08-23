#!/bin/sh

export BASE_DIR="`dirname $0`"

make || exit 1

if test -z "$CUTTER"; then
  #CUTTER="`make -s -C $BASE_DIR echo-cutter`"
  CUTTER="cutter"
fi

$CUTTER -s $BASE_DIR "$@" $BASE_DIR
