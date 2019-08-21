#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_partition.h"

void test_partition_boundary_count(void) {
  int n = 9;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  destroy_test_data(td);

  cut_assert_equal_int(n-1, prechi_partition_boundary_count(part));

  prechi_partition_destroy(part);
}

void test_partition_minimum_count(void) {
  int n = 9;
  int min = 4;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n,
    min+4, min+3, min+2, min+1, min+4, min+5, min, min+7, min+5);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  destroy_test_data(td);

  cut_assert_equal_int(min, prechi_partition_minimum_count(part));

  prechi_partition_destroy(part);
}

void test_partition_counts(void) {
  int n = 9;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  int size = n * sizeof(int);
  cut_assert_equal_memory(
    td->counts, size, prechi_partition_counts(part), size);

  destroy_test_data(td);
  prechi_partition_destroy(part);
}

void test_partition_spans(void) {
  int n = 9;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  assert_equal_array(1, prechi_partition_spans(part), n);

  destroy_test_data(td);
  prechi_partition_destroy(part);
}
