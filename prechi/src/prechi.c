#include <stdlib.h>
#include "prechi.h"

Prechi *prechi_create(int *weights, int *counts, int count) {
  Prechi *prechi = (Prechi*)malloc(sizeof(Prechi));

  prechi->count = count;
  prechi->weights = (int *)calloc(count, sizeof(int));
  memcpy(prechi->weights, weights, count);
  prechi->counts = (int *)calloc(count, sizeof(int));
  memcpy(prechi->counts, counts, count);

  return prechi;
}

Prechi *prechi_destroy(Prechi *prechi) {
  free(prechi->counts);
  free(prechi->weights);
  free(prechi);
  return NULL;
}
