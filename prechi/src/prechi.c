#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "prechi.h"
#include "prechi_partition.h"

Prechi *prechi_create(int *weights, int *counts, int count) {
  Prechi *prechi = (Prechi*)malloc(sizeof(Prechi));

  prechi->count = count;
  prechi->weights = (int *)calloc(count, sizeof(int));
  prechi->counts = (int *)calloc(count, sizeof(int));
  prechi->solution_part_count = 0;
  prechi->solution_counts = (int *)calloc(count, sizeof(int));
  prechi->solution_spans = (int *)calloc(count, sizeof(int));
  prechi->solution_boundaries = (float*)calloc(count, sizeof(float));
  for (int i = 0; i < count; ++i) {
    prechi->counts[i] = counts[i];
    prechi->weights[i] = weights[i];
  }

  return prechi;
}

Prechi *prechi_destroy(Prechi *prechi) {
  free(prechi->solution_boundaries);
  free(prechi->solution_spans);
  free(prechi->solution_counts);
  free(prechi->counts);
  free(prechi->weights);
  free(prechi);
  return NULL;
}

// Updates the solution
static void record_solution(Prechi *prechi, PrechiPartition *solution,
  int part_count, float mean, float variance)
{
  prechi->solution_part_count = part_count;
  prechi->solution_mean = mean;
  prechi->solution_variance = variance;
  for (int i = 0; i < part_count; ++i) {
    prechi->solution_counts[i] = solution->counts[i];
    prechi->solution_spans[i] = solution->spans[i];
  }
}

// Updates the solution if the one provided is "better"
static void record_if_improved(Prechi *prechi, PrechiPartition *solution)
{
  int part_count = solution->size;
  float mean = prechi_partition_mean(solution);
  float variance = prechi_partition_variance(solution, mean);
  if (prechi->solution_part_count < part_count) {
    record_solution(prechi, solution, part_count, mean, variance);
  } else {
    float mean_delta = fabsf(mean - prechi->target_mean);
    float variance_delta = fabsf(variance - prechi->target_variance);
    float best_mean_delta =
      fabsf(prechi->target_mean - prechi->solution_mean);
    float best_variance_delta =
      fabsf(prechi->target_variance - prechi->solution_variance);
    if (mean_delta + variance_delta < best_mean_delta + best_variance_delta) {
      record_solution(prechi, solution, part_count, mean, variance);
    }
  }
}

/*
 Returns 1 (true) to bound search, 0 (false) to continue
 Any solution with less than three parts is not useful.
 Any solution with fewer parts than one already found is not useful.
*/
static int bounded(Prechi *prechi, int reductions) {
  int part_count = prechi->count - reductions;
  return part_count <= 3 || part_count <= prechi->solution_part_count;
}

// Check the trial solution and record it, or advance after bound
static void advance_solution(Prechi *prechi, PrechiPartition *trial,
  int min_count, int reductions)
{
  if (min_count <= prechi_partition_minimum_count(trial)) {
    record_if_improved(prechi, trial);
  } else if (!bounded(prechi, reductions)) {
    for (int i = 0; i < trial->size - 1; ++i) {
      PrechiPartition *next_trial = prechi_partition_copy(trial);
      prechi_partition_join(next_trial,
        prechi_partition_sorted_offset(next_trial, i));
      advance_solution(prechi, next_trial, min_count, reductions + 1);
      next_trial = prechi_partition_destroy(next_trial);
    }
  }
}

static void compute_solution_intervals(Prechi *prechi) {
  int bin = 0;
  for(int i = 0; i < prechi->solution_part_count - 1; ++i) {
    bin += prechi->solution_spans[i];
    prechi->solution_boundaries[i] =
      prechi->weights[bin-1] +
      (prechi->weights[bin] - prechi->weights[bin-1]) / 2.0f;
  }
}

/*
 Solve the partitions problem.
 After this, the following apply:
 - solution_part_count has the number of parts in the partition
 - solution_counts has the counts for each part in the partition
 - solution_boundaries has the weights at the divisions between parts
 - solution_mean has the weighted mean of the partitioned data
 - solution_variance has the weighted variance of the partitioned data
 - solution_spans has the number of classes combined for each part
*/
void prechi_solve(Prechi *prechi, int min_count) {
  float *weights = (float *)calloc(prechi->count, sizeof(float));
  for(int i = 0; i < prechi->count; ++i) {
    weights[i] = prechi->weights[i];
  }
  PrechiPartition *trial = prechi_partition_create(prechi->count,
    weights, prechi->counts);
  free(weights);
  prechi->target_mean = prechi_partition_mean(trial);
  prechi->target_variance =
    prechi_partition_variance(trial, prechi->target_mean);

  advance_solution(prechi, trial, min_count, 0);

  prechi_partition_destroy(trial);
  compute_solution_intervals(prechi);
}
