#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_data.h"
#include "../src/prechi.h"

void test_prechi_solve_no_solution(void) {
  int n = 7;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 4, 0, 1);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_solve(prechi);
  cut_assert_equal_int(0, prechi->solution_part_count);
  assert_equal_float(0, prechi->solution_mean, 1);
  assert_equal_float(0, prechi->solution_variance, 1);

  destroy_test_data(td);
  prechi_destroy(prechi);
}

void test_prechi_solve_no_solution_six_bins(void) {
  int n = 7;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 4, 4, 1, 5, 5, 5);
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_minimum_partition_count(prechi, 6);
  prechi_solve(prechi);

  cut_assert_equal_int(0, prechi->solution_part_count);
  assert_equal_float(0, prechi->solution_mean, 1);
  assert_equal_float(0, prechi->solution_variance, 1);

  destroy_test_data(td);
  prechi_destroy(prechi);
}

void test_prechi_solve_no_solution_one_part(void) {
  int n = 9;
  TestData *td = create_test_data(n);
  int_array_init(td->counts, n, 1, 0, 0, 0, 0, 0, 0, 0, 0);
  for(int i = 0; i < n; ++i) {
    td->weights[i] = td->dweights[i] = 42 + i * 5;
  }
  Prechi *prechi = prechi_create(td->dweights, td->counts, n);

  prechi_set_minimum_partition_count(prechi, 6);
  prechi_set_minimum_count(prechi, 6);
  prechi_set_timeout_seconds(prechi, 3);
  prechi_solve(prechi);

  cut_assert_equal_int(0, prechi->solution_part_count);
  assert_equal_float(0, prechi->solution_mean, 1);
  assert_equal_float(0, prechi->solution_variance, 1);

  destroy_test_data(td);
  prechi_destroy(prechi);
}
