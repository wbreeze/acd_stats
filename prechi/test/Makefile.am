ACLOCAL_AMFLAGS = -I tools/m4

TESTS = ./run_test.sh

noinst_LTLIBRARIES = libtest_prechi.la

libtest_prechi_la_CPPFLAGS = $(CUTTER_CFLAGS)
libtest_prechi_la_LDFLAGS = -module -rpath $(libdir) \
  -avoid-version -no-undefined
libtest_prechi_la_LIBADD = $(CUTTER_LIBS)

SRC_FILES = \
../src/prechi.h ../src/prechi.c \
../src/prechi_partition.h ../src/prechi_partition.c

libtest_prechi_la_SOURCES = $(SRC_FILES) \
  array_init.h array_init.c \
  test_data.h test_data.c \
  test_partition_create.c \
  test_partition_join.c \
  test_partition_mean.c \
  test_partition_sort.c \
  test_prechi.h test_prechi.c \
  test_prechi_collapse_zero.c \
  test_prechi_no_solution.c \
  test_prechi_solve.c
