#include <cutter.h>
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi.h"

void test_prechi_create(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);
  cut_assert_not_null(prechi);

  cut_assert_equal_int(n, prechi->count);
  assert_equal_float_arrays(td->weights, prechi->weights, n, 3);
  assert_equal_int_arrays(td->counts, prechi->counts, n);
  cut_assert_equal_int(0, prechi->solution_part_count);
  assert_same_value_array(0, prechi->solution_boundaries, n);
  assert_same_value_array(0, prechi->solution_spans, n);
  assert_same_value_array(0, prechi->solution_counts, n);

  prechi_destroy(prechi);
  destroy_test_data(td);
}
