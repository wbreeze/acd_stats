#include <cutter.h>
#include "test_helper.h"
#include "test_prechi.h"

PrechiTestData *create_prechi_data(int count) {
  PrechiTestData *td = malloc(sizeof(PrechiTestData));
  td->weights = (int *)calloc(count, sizeof(int));
  td->counts = (int *)calloc(count, sizeof(int));
  for(int i = 0; i < count; ++i) {
    td->weights[i] = 55 + i * 5;
    td->counts[i] = 1;
  }
  return td;
}

void destroy_prechi_data(PrechiTestData *td) {
  free(td->counts);
  free(td->weights);
  free(td);
}

void test_prechi_create(void) {
  int n = 5;
  PrechiTestData *td = create_prechi_data(n);
  Prechi *prechi = prechi_create(td->weights, td->counts, n);
  cut_assert_not_null(prechi);

  cut_assert_equal_int(n, prechi->count);
  int size = n * sizeof(int);
  cut_assert_equal_memory(td->weights, size, prechi->weights, size);
  cut_assert_equal_memory(td->counts, size, prechi->counts, size);
  cut_assert_equal_int(0, prechi->solution_part_count);
  assert_equal_array(0, prechi->solution_boundaries, n);
  assert_equal_array(0, prechi->solution_spans, n);
  assert_equal_array(0, prechi->solution_counts, n);

  prechi_destroy(prechi);
  destroy_prechi_data(td);
}
