#include <cutter.h>
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi_partition.h"

void test_partition_create(void) {
  int n = 17;
  TestData *td = create_test_data(n);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  cut_assert_not_null(part);

  assert_equal_float_arrays(td->weights, part->weights, n, 3);
  assert_equal_int_arrays(td->counts, part->counts, n);
  assert_same_value_array(1, part->spans, n);

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

  assert_equal_float_arrays(td->weights, copy->weights, n, 3);
  assert_equal_int_arrays(td->counts, copy->counts, n);
  cut_assert_equal_int(span, copy->spans[0]);
  cut_assert_equal_int(n, copy->size);

  cut_assert_equal_pointer(NULL, prechi_partition_destroy(copy));
}
