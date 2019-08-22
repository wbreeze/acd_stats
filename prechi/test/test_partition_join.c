#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi_partition.h"

void test_partition_join(void) {
  int n = 4;
  TestData *td = create_test_data(n);
  int_array_init(td->counts,  n, 1, 3, 5, 7);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  prechi_partition_join(part, 1);

  cut_assert_equal_int(n-1, part->size);
  assert_equal_float(62.5f, part->weights[1], 2);

  cut_assert_equal_int(1, part->counts[0]);
  cut_assert_equal_int(8, part->counts[1]);
  cut_assert_equal_int(7, part->counts[2]);
  cut_assert_equal_int(1, part->spans[0]);
  cut_assert_equal_int(2, part->spans[1]);
  cut_assert_equal_int(1, part->spans[2]);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_join_bounds(void) {
  int n = 4;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  prechi_partition_join(part, -1);
  cut_assert_equal_int(n, part->size);
  prechi_partition_join(part, n-1);
  cut_assert_equal_int(n, part->size);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_join_shift(void) {
  int n = 4;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
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

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_join_balanced_mean(void) {
  int n = 4;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  // two times
  prechi_partition_join(part, 0);
  prechi_partition_join(part, 0);

  cut_assert_equal_int(2, part->size);
  cut_assert_equal_int(3, part->spans[0]);
  assert_equal_float(60.0f, part->weights[0], 1);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}
