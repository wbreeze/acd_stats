#include <cutter.h>
#include "test_helper.h"
#include "test_partition.h"

typedef struct {
  float *weights;
  int *counts;
} TestData;

TestData *create_test_data(int count) {
  TestData *td = malloc(sizeof(TestData));
  td->weights = calloc(count, sizeof(float));
  td->counts = calloc(count, sizeof(int));
  for(int i = 0; i < count; ++i) {
    td->weights[i] = 55 + i * 5;
    td->counts[i] = i + 1;
  }
  return td;
}

void destroy_test_data(TestData *td) {
  free(td->counts);
  free(td->weights);
  free(td);
}

void test_partition_create(void) {
  int n = 17;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  cut_assert_not_null(part);

  cut_assert_equal_memory(td->weights, n, part->weights, n);
  cut_assert_equal_memory(td->counts, n, part->counts, n);
  assert_equal_array(1, part->spans, n);

  cut_assert_equal_int(n, part->size);

  part = prechi_partition_destroy(part);
  cut_assert_equal_pointer(NULL, part);
}

void test_partition_copy(void) {
  int n = 11;
  int span = 2;

  TestData *td = create_test_data(n);
  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  part->spans[0] = span;
  PrechiPartition *copy = prechi_partition_copy(part);
  cut_assert_equal_pointer(NULL, prechi_partition_destroy(part));

  cut_assert_equal_memory(td->weights, n, copy->weights, n);
  cut_assert_equal_memory(td->counts, n, copy->counts, n);
  cut_assert_equal_int(span, copy->spans[0]);
  cut_assert_equal_int(n, copy->size);

  cut_assert_equal_pointer(NULL, prechi_partition_destroy(copy));
}

void test_partition_join(void) {
  int n = 4;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  part->counts[1] = 2;
  part->counts[2] = 3;
  prechi_partition_join(part, 1);

  cut_assert_equal_int(n-1, part->size);
  assert_equal_float(62.5f, part->weights[1], 2);
  cut_assert_equal_int(5, part->counts[1]);
  cut_assert_equal_int(2, part->spans[1]);
}

void test_partition_join_bounds(void) {
  int n = 4;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  prechi_partition_join(part, -1);
  cut_assert_equal_int(n, part->size);
  prechi_partition_join(part, n-1);
  cut_assert_equal_int(n, part->size);
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
}
