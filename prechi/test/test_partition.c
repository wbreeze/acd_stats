#include <cutter.h>
#include "test_helper.h"
#include "test_partition.h"

void test_partition_create(void) {
  int n = 17;
  float fv = 0.125f;
  int iv = 1;

  PrechiPartition *part = prechi_partition_create(n);
  cut_assert_not_null(part);

  set_array(part->weights, fv, n);
  set_array(part->counts, iv, n);
  set_array(part->spans, iv, n);
  set_array(part->sorted_offsets, iv, n);

  assert_equal_array(fv, part->weights, n);
  assert_equal_array(iv, part->counts, n);
  assert_equal_array(iv, part->spans, n);
  assert_equal_array(iv, part->sorted_offsets, n);

  cut_assert_equal_int(n, part->size);

  part = prechi_partition_destroy(part);
  cut_assert_equal_pointer(NULL, part);
}

void test_partition_copy(void) {
  int n = 11;
  float fv = 0.625f;
  int iv = 1;

  PrechiPartition *part = prechi_partition_create(n);
  cut_assert_not_null(part);

  set_array(part->weights, fv, n);
  set_array(part->counts, iv, n);
  set_array(part->spans, iv, n);
  set_array(part->sorted_offsets, iv, n);

  PrechiPartition *copy = prechi_partition_copy(part);
  cut_assert_equal_pointer(NULL, prechi_partition_destroy(part));

  assert_equal_array(fv, copy->weights, n);
  assert_equal_array(iv, copy->counts, n);
  assert_equal_array(iv, copy->spans, n);
  assert_equal_array(iv, part->sorted_offsets, n);

  cut_assert_equal_int(n, copy->size);

  cut_assert_equal_pointer(NULL, prechi_partition_destroy(copy));
}

void test_partition_join(void) {
  int n = 4;
  PrechiPartition *part = prechi_partition_create(n);
  for(int i = 0; i < n; ++i) {
    part->weights[i] = 55 + i * 5;
    part->counts[i] = 2;
    part->spans[i] = 1;
  }
  prechi_partition_join(part, 1);

  cut_assert_equal_int(n-1, part->size);
  assert_equal_float(62.5f, part->weights[1], 2);
  cut_assert_equal_int(4, part->counts[1]);
  cut_assert_equal_int(2, part->spans[1]);
}

void test_partition_join_bounds(void) {
  int n = 4;
  PrechiPartition *part = prechi_partition_create(n);
  prechi_partition_join(part, -1);
  cut_assert_equal_int(n, part->size);
  prechi_partition_join(part, n);
  cut_assert_equal_int(n, part->size);
}

void test_partition_join_shift(void) {
  int n = 4;
  PrechiPartition *part = prechi_partition_create(n);
  for(int i = 0; i < n; ++i) {
    part->weights[i] = 55 + i * 5;
    part->counts[i] = 1;
    part->spans[i] = 1;
  }
  int last_span = 2;
  part->spans[n-1] = last_span;
  int last_count = 21;
  part->counts[n-1] = last_count;
  float last_weight = 67.5f;
  part->weights[n-1] = last_weight;

  prechi_partition_join(part, 0);

  cut_assert_equal_int(last_span, part->spans[n-2]);
  cut_assert_equal_int(last_count, part->counts[n-2]);
  assert_equal_float(last_weight, part->weights[n-2], 2);
}

void test_partition_join_balanced_mean(void) {
  int n = 4;
  PrechiPartition *part = prechi_partition_create(n);
  for(int i = 0; i < n; ++i) {
    part->weights[i] = 55 + i * 5;
    part->counts[i] = 4;
    part->spans[i] = 1;
  }

  // two times
  prechi_partition_join(part, 0);
  prechi_partition_join(part, 0);

  cut_assert_equal_int(2, part->size);
  cut_assert_equal_int(3, part->spans[0]);
  assert_equal_float(60.0f, part->weights[0], 1);
}
