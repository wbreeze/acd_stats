#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_partition.h"

void test_partition_mean_1(void) {
  int n = 3;
  TestData *td = create_test_data(n);
  float weight = 20.0f;
  float diff = 10.0f;
  td->weights[0] = weight - diff;
  td->weights[1] = weight;
  td->weights[2] = weight + diff;
  int_array_init(td->counts, n, 1, 1, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  destroy_test_data(td);

  float mean = prechi_partition_mean(part);
  assert_equal_float(weight, mean, 3);
  assert_equal_float((2 * diff * diff)/3,
    prechi_partition_variance(part, mean), 3);

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

  float mean = prechi_partition_mean(part);
  assert_equal_float(weight, mean, 3);
  assert_equal_float(0, prechi_partition_variance(part, mean), 3);

  prechi_partition_destroy(part);
}

void test_partition_mean_3(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 1, 1, 1, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  float mean = prechi_partition_mean(part);
  assert_equal_float(td->weights[2], mean, 3);
  assert_equal_float((2 * (25.0f + 100.0f))/5,
    prechi_partition_variance(part, mean), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_mean_4(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 3, 5, 3, 1);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  float mean = prechi_partition_mean(part);
  assert_equal_float(td->weights[2], mean, 3);
  assert_equal_float((6 * 25.0f + 2 * 100.0f)/13,
    prechi_partition_variance(part, mean), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_mean_zero(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 0, 0, 0, 0, 0);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  float mean = prechi_partition_mean(part);
  assert_equal_float(0, mean, 3);
  assert_equal_float(0, prechi_partition_variance(part, mean), 3);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}
