#ifndef PRECHI_H
#define PRECHI_H

#include <time.h>

typedef struct Prechi {
  int count;
  float *weights;
  int *counts;
  float target_mean;
  float target_variance;
  int solution_part_count;
  float solution_mean;
  float solution_variance;
  int *solution_counts;
  int *solution_spans;
  float *solution_boundaries;
  clock_t timeout;
} Prechi;

Prechi *prechi_create(const double *weights, const int *counts, int count);
Prechi *prechi_destroy(Prechi *prechi);

void prechi_solve(Prechi *prechi, int min_count, int timeout_seconds);

#endif
