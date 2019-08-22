#include <stdlib.h>
#include "test_data.h"

TestData *create_test_data(int count) {
  TestData *td = malloc(sizeof(TestData));
  td->weights = calloc(count, sizeof(float));
  td->counts = calloc(count, sizeof(int));
  td->dweights = calloc(count, sizeof(double));
  for(int i = 0; i < count; ++i) {
    td->weights[i] = td->dweights[i] = 55 + i * 5;
    td->counts[i] = i + 1;
  }
  return td;
}

void destroy_test_data(TestData *td) {
  free(td->dweights);
  free(td->counts);
  free(td->weights);
  free(td);
}
