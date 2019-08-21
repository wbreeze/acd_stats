#ifndef PRECHI_H
#define PRECHI_H

#include "config.h"

typedef struct Prechi {
  int count;
  int *weights;
  int *counts;
  int solution_part_count;
  int *solution_counts;
  int *solution_spans;
  float *solution_boundaries;
} Prechi;

Prechi *prechi_create(int *weights, int *counts, int count);
Prechi *prechi_destroy(Prechi *prechi);

void prechi_solve(Prechi *prechi, int min_count);
int prechi_partition_count(Prechi *prechi);

#endif
