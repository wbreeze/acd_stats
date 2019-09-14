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
  int did_timeout;
  float timeout_seconds;
  int min_solution_part_count; // minimum number of partitions
  int min_count; // minimum count value in a partition
} Prechi;

Prechi *prechi_create(const double *weights, const int *counts, int count);
Prechi *prechi_destroy(Prechi *prechi);

void prechi_set_minimum_partition_count(Prechi *prechi, int min_count);
void prechi_set_minimum_count(Prechi *prechi, int min_count);
void prechi_set_timeout_seconds(Prechi *prechi, float seconds);

void prechi_solve(Prechi *prechi);

#endif
