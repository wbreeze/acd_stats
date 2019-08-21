#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_partition.h"

void test_partition_mean_1(void) {
  int n = 3;
  TestData *td = create_test_data(n);
  float weight = 20.0f;
  td->weights[0] = weight - 10;
  td->weights[1] = weight;
  td->weights[2] = weight + 10;
  int_array_init(td->counts, n, 1, 1, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  destroy_test_data(td);

  assert_equal_float(weight, prechi_partition_mean(part), 3);

  prechi_partition_destroy(part);
}

void test_partition_mean_2(void) {
  int n = 3;
  TestData *td = create_test_data(n);
  float weight = 5.0f;
  td->weights[0] = weight;
  td->weights[1] = weight;
  td->weights[2] = weight;
  int_array_init(td->counts, n, 3, 7, 5);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  destroy_test_data(td);

  assert_equal_float(weight, prechi_partition_mean(part), 3);

  prechi_partition_destroy(part);
}

void test_partition_mean_3(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 1, 1, 1, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  assert_equal_float(td->weights[2], prechi_partition_mean(part), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_mean_4(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 3, 5, 3, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  assert_equal_float(td->weights[2], prechi_partition_mean(part), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_mean_zero(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 0, 0, 0, 0, 0);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  assert_equal_float(0, prechi_partition_mean(part), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}
