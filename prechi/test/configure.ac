AC_INIT([prechi], 1.0.1)
AC_PREREQ([2.69])
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi

AC_CONFIG_SRCDIR([src/prechi.c])
AC_CONFIG_MACRO_DIRS([m4])
AM_PROG_AR
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
LT_INIT

CC=`"${R_HOME}/bin/R" CMD config CC`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
AC_PROG_CC

AC_CHECK_CUTTER
AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h])
AC_FUNC_MALLOC

AC_CONFIG_HEADERS([src/config.h])
AC_CONFIG_FILES([
  Makefile
  src/Makefile
  test/Makefile
])
AC_OUTPUT
