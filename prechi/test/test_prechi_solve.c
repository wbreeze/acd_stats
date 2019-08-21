#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_prechi.h"

void test_prechi_solve_1(void) {
  int n = 5;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 2, 3, 5, 3, 2);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);

  int expected_parts = 3;
  prechi_solve(prechi, 5);
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 2, 1, 2);
  int array_size = expected_parts * sizeof(int);
  cut_assert_equal_memory(
    td->counts, array_size, prechi->solution_spans, array_size);

  assert_equal_float(td->weights[1] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[2] + 2.5, prechi->solution_boundaries[1], 2);

  prechi_destroy(prechi);
  destroy_prechi_data(td);
}

void test_prechi_solve_2(void) {
  int n = 7;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 6, 8, 2);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);

  int expected_parts = 3;
  prechi_solve(prechi, 5);
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 4, 1, 2);
  int array_size = expected_parts * sizeof(int);
  cut_assert_equal_memory(
    td->counts, array_size, prechi->solution_spans, array_size);

  assert_equal_float(td->weights[3] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[4] + 2.5, prechi->solution_boundaries[1], 2);

  prechi_destroy(prechi);
  destroy_prechi_data(td);
}

void test_prechi_solve_3(void) {
  int n = 9;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 6, 8, 1, 1, 1, 1, 1, 7, 5);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);

  int expected_parts = 5;
  prechi_solve(prechi, 5);
  cut_assert_equal_int(expected_parts, prechi->solution_part_count);

  //re-use counts for span check
  int_array_init(td->counts, expected_parts, 1, 1, 5, 1, 1);
  int array_size = expected_parts * sizeof(int);
  cut_assert_equal_memory(
    td->counts, array_size, prechi->solution_spans, array_size);

  assert_equal_float(td->weights[0] + 2.5, prechi->solution_boundaries[0], 2);
  assert_equal_float(td->weights[1] + 2.5, prechi->solution_boundaries[1], 2);
  assert_equal_float(td->weights[6] + 2.5, prechi->solution_boundaries[2], 2);
  assert_equal_float(td->weights[7] + 2.5, prechi->solution_boundaries[3], 2);

  prechi_destroy(prechi);
  destroy_prechi_data(td);
}

void test_prechi_solve_no_solution(void) {
  int n = 7;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 4, 0, 1);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  destroy_prechi_data(td);

  prechi_solve(prechi, 5);
  cut_assert_equal_int(0, prechi->solution_part_count);

  prechi_destroy(prechi);
}
