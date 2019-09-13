#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi_partition.h"

void test_partition_sort_minimum(void) {
  int n = 3;
  TestData *td = create_test_data(n);
  int min = 1;
  int_array_init(td->counts, n, min, min + 1, min);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  cut_assert_equal_int(min, prechi_partition_minimum(part, 0));
  cut_assert_equal_int(min, prechi_partition_minimum(part, 1));

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

void test_partition_sort_value(void) {
  int n = 3;
  TestData *td = create_test_data(n);
  int min = 1;
  int_array_init(td->counts, n, min, min + 1, min + 2);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  cut_assert_equal_int(2 * min + 1, prechi_partition_value(part, 0));
  cut_assert_equal_int(2 * min + 3, prechi_partition_value(part, 1));

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

// see that minimums and values at sorted_offsets increase
static void assert_sorted_offsets(PrechiPartition *part) {
  int ofs = prechi_partition_sorted_offset(part, 0);
  int prior_minimum = prechi_partition_minimum(part, ofs);
  int prior_value = prechi_partition_value(part, ofs);
  for (int i = 1; i < part->size - 1; ++i) {
    ofs = prechi_partition_sorted_offset(part, i);
    int minimum = prechi_partition_minimum(part, ofs);
    int value = prechi_partition_value(part, ofs);
    cut_assert_operator_int(prior_minimum, <=, minimum);
    if (prior_minimum == minimum) {
      cut_assert_operator_int(prior_value, <=, value);
    }
    prior_minimum = minimum;
    prior_value = value;
  }
}

void test_partition_sort_basic(void) {
  int n = 7;
  TestData *td = create_test_data(n);

  // arrange counts descending
  for (int i = 0; i < n; ++i) {
    td->counts[i] = n + 5 - i;
  }

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  assert_sorted_offsets(part);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}

static void assert_sort_all_joins(TestData *td, int n) {
  for (int i = 0; i < n-1; ++i) {
    PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
    prechi_partition_join(part, i);
    assert_sorted_offsets(part);
    prechi_partition_destroy(part);
  }
}

void test_partition_sort_join_1(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 7, 3, 1, 5, 11);
  assert_sort_all_joins(td, n);
  destroy_test_data(td);
}

void test_partition_sort_join_2(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 3, 5, 7, 11);
  assert_sort_all_joins(td, n);
  destroy_test_data(td);
}

void test_partition_sort_join_3(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 11, 7, 5, 3, 1);
  assert_sort_all_joins(td, n);
  destroy_test_data(td);
}

void test_partition_sort_join_4(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 7, 11, 5, 3);
  assert_sort_all_joins(td, n);
  destroy_test_data(td);
}

void test_partition_minimum_count(void) {
  int n = 9;
  int min = 4;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n,
    min+4, min+3, min+2, min+1, min+4, min+5, min, min+7, min+5);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  cut_assert_equal_int(min, prechi_partition_minimum_count(part, 0));
  cut_assert_equal_int(min, prechi_partition_minimum_count(part, 1));
  cut_assert_equal_int(min+1, prechi_partition_minimum_count(part, 2));
  cut_assert_equal_int(min+1, prechi_partition_minimum_count(part, 3));

  destroy_test_data(td);
  prechi_partition_destroy(part);
}
