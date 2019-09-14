#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi.h"

void test_prechi_join_zeros(void) {
  int n = 14;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 5, 0, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0, 5);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_solve(prechi, 5, 1);

  cut_assert_false(prechi->did_timeout);
  cut_assert_equal_int(4, prechi->solution_part_count);
}
