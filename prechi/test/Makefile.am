TESTS = run_test.sh
TESTS_ENVIRONMENT = NO_MAKE=yes CUTTER="$(CUTTER)"

noinst_LTLIBRARIES = test_prechi.la

test_prechi_la_CPPFLAGS = $(CUTTER_CFLAGS) -I $(top_srcdir)/src

test_prechi_la_LIBADD = $(CUTTER_LIBS) $(top_builddir)/src/libprechi.la

AM_LDFLAGS = -module -rpath $(libdir) -avoid-version -no-undefined

test_prechi_la_SOURCES = \
  array_init.h array_init.c \
  test_partition.h test_partition.c \
  test_partition_access.c \
  test_partition_create.c \
  test_partition_join.c \
  test_partition_sort.c \
  test_prechi.h test_prechi.c \
  test_prechi_solve.c
