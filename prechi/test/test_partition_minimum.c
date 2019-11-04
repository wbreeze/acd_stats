#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi_partition.h"

void test_partition_minimum_one(void) {
  int n = 1;
  TestData *td = create_test_data(n);
  int count = 6;
  int_array_init(td->counts,  n, count);

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);
  int min = prechi_partition_minimum(part, 0);

  cut_assert_equal_int(count, min);

  prechi_partition_destroy(part);
  destroy_test_data(td);
}
