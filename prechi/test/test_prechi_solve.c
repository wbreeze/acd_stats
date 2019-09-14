#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi.h"

#define TIMEOUT_SECONDS 1

void test_prechi_solve_1(void) {
  int n = 5;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 2, 3, 5, 3, 2);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_timeout_seconds(prechi, TIMEOUT_SECONDS);
  prechi_solve(prechi);

  int expected_parts = 3;
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 2, 1, 2);
  assert_equal_int_arrays(
    td->counts, prechi->solution_spans, expected_parts);

  assert_equal_float(td->weights[1] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[2] + 2.5, prechi->solution_boundaries[1], 2);

  prechi_destroy(prechi);
  destroy_test_data(td);
}

void test_prechi_solve_2(void) {
  int n = 7;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 6, 8, 2);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_timeout_seconds(prechi, TIMEOUT_SECONDS);
  prechi_solve(prechi);

  int expected_parts = 3;
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 4, 1, 2);
  assert_equal_int_arrays(
    td->counts, prechi->solution_spans, expected_parts);

  assert_equal_float(td->weights[3] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[4] + 2.5, prechi->solution_boundaries[1], 2);

  prechi_destroy(prechi);
  destroy_test_data(td);
}

void test_prechi_solve_3(void) {
  int n = 9;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 6, 8, 1, 1, 1, 1, 1, 7, 5);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_timeout_seconds(prechi, TIMEOUT_SECONDS);
  prechi_solve(prechi);

  int expected_parts = 5;
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 1, 1, 5, 1, 1);
  assert_equal_int_arrays(
    td->counts, prechi->solution_spans, expected_parts);

  assert_equal_float(td->weights[0] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[1] + 2.5, prechi->solution_boundaries[1], 2);
  assert_equal_float(td->weights[6] + 2.5, prechi->solution_boundaries[2], 2);
  assert_equal_float(td->weights[7] + 2.5, prechi->solution_boundaries[3], 2);

  prechi_destroy(prechi);
  destroy_test_data(td);
}

void test_prechi_solve_timeout(void) {
  int n = 15;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 2, 1, 1, 1, 3, 1, 1, 1, 2, 3, 5, 1, 4, 2, 8);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_timeout_seconds(prechi, TIMEOUT_SECONDS);
  prechi_solve(prechi);

  cut_assert_true(prechi->did_timeout);

  int expected_parts = 6;
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for solution count check
  int_array_init(td->counts, expected_parts, 5, 5, 6, 6, 6, 8);
  assert_equal_int_arrays(
    td->counts, prechi->solution_counts, expected_parts);

  prechi_destroy(prechi);
  destroy_test_data(td);
}
