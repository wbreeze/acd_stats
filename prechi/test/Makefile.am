TESTS = run_test.sh
TESTS_ENVIRONMENT = NO_MAKE=yes CUTTER="$(CUTTER)"

noinst_LTLIBRARIES = test_prechi.la

test_prechi_la_CPPFLAGS = $(CUTTER_CFLAGS) -I $(top_srcdir)/src

test_prechi_la_LIBADD = $(CUTTER_LIBS) $(top_builddir)/src/libprechi.la

AM_LDFLAGS = -module -rpath $(libdir) -avoid-version -no-undefined

test_prechi_la_SOURCES = \
  test_partition.h, test_partition.c
