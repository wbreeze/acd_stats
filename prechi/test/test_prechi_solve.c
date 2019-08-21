#include <cutter.h>
#include "array_init.h"
#include "test_helper.h"
#include "test_prechi.h"

void test_prechi_solve_1(void) {
  int n = 5;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 2, 3, 5, 3, 2);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  destroy_prechi_data(td);

  prechi_solve(prechi, 3);
  cut_assert_equal_int(3, prechi_partition_count(prechi));

  prechi_destroy(prechi);
}

void test_prechi_solve_2(void) {
  int n = 7;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 6, 8, 2);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  destroy_prechi_data(td);

  prechi_solve(prechi, 5);
  cut_assert_equal_int(3, prechi_partition_count(prechi));

  prechi_destroy(prechi);
}

void test_prechi_solve_3(void) {
  int n = 9;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 6, 8, 1, 1, 1, 1, 1, 7, 5);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  destroy_prechi_data(td);

  prechi_solve(prechi, 5);
  cut_assert_equal_int(5, prechi_partition_count(prechi));

  prechi_destroy(prechi);
}

void test_prechi_solve_no_solution(void) {
  int n = 7;
  PrechiTestData *td = create_prechi_data(n);
  int_array_init(td->counts, n, 1, 0, 4, 0, 4, 0, 1);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  destroy_prechi_data(td);

  prechi_solve(prechi, 5);
  cut_assert_equal_int(0, prechi_partition_count(prechi));

  prechi_destroy(prechi);
}
