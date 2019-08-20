#include <cutter.h>
#include "test_helper.h"
#include "test_partition.h"

void test_partition_sort_basic(void) {
  int n = 7;
  TestData *td = create_test_data(n);

  // arrange counts descending
  for (int i = 0; i < n; ++i) {
    td->counts[i] = n + 5 - i;
  }

  PrechiPartition *part = prechi_partition_create(n, td->weights, td->counts);

  // see that offsets descend (highest first)
  int prior_ofs = prechi_partition_sorted_offset(part, 0);
  for (int i = 1; i < n - 1; ++i) {
    int sofs = prechi_partition_sorted_offset(part, i);
    cut_assert_operator_int(prior_ofs, >, sofs);
    prior_ofs = sofs;
  }

  prechi_partition_destroy(part);
  destroy_test_data(td);
}
