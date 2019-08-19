#include <cutter.h>
#include "test_helper.h"
#include "test_partition.h"

void test_partition_create(void) {
  int n = 17;
  float fv = 0.125f;
  int iv = 1;

  PrechiPartition *part = prechi_partition_create(n);
  cut_assert_not_null(part);

  set_array(part->boundaries, fv, n);
  set_array(part->counts, iv, n);
  set_array(part->spans, iv, n);

  assert_equal_array(fv, part->boundaries, n);
  assert_equal_array(iv, part->counts, n);
  assert_equal_array(iv, part->spans, n);

  cut_assert_equal_int(n, part->size);
  cut_assert_equal_int(0, part->removed_count);

  part = prechi_partition_destroy(part);
  cut_assert_equal_pointer(NULL, part);
}

void test_partition_copy(void) {
  int n = 11;
  float fv = 0.625f;
  int iv = 1;
  int rc = 2;

  PrechiPartition *part = prechi_partition_create(n);
  cut_assert_not_null(part);

  set_array(part->boundaries, fv, n);
  set_array(part->counts, iv, n);
  set_array(part->spans, iv, n);
  part->removed_count = rc;

  PrechiPartition *copy = prechi_partition_copy(part);
  cut_assert_equal_pointer(NULL, prechi_partition_destroy(part));

  assert_equal_array(fv, copy->boundaries, n);
  assert_equal_array(iv, copy->counts, n);
  assert_equal_array(iv, copy->spans, n);

  cut_assert_equal_int(n, copy->size);
  cut_assert_equal_int(rc, copy->removed_count);

  cut_assert_equal_pointer(NULL, prechi_partition_destroy(copy));
}

void test_blank(void) {
  const int n = 8;
  int counts[n] = {1,2,0,4,8,6,0,3};
  int weights[n] = {65, 70, 75, 80, 85, 90, 95, 100};
  cut_assert_equal_int(counts[0], 1);
}
