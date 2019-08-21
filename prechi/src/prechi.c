#include <math.h>
#include <stdio.h> //DEBUG
#include <stdlib.h>
#include <string.h>
#include "prechi.h"
#include "prechi_partition.h"

Prechi *prechi_create(int *weights, int *counts, int count) {
  Prechi *prechi = (Prechi*)malloc(sizeof(Prechi));

  prechi->count = count;
  int size = count * sizeof(int);
  prechi->weights = (int *)calloc(count, sizeof(int));
  memcpy(prechi->weights, weights, size);
  prechi->counts = (int *)calloc(count, sizeof(int));
  memcpy(prechi->counts, counts, size);
  prechi->solution_part_count = 0;
  prechi->solution_counts = (int *)calloc(count, sizeof(int));
  prechi->solution_spans = (int *)calloc(count, sizeof(int));
  prechi->solution_boundaries = (float*)calloc(count, sizeof(float));

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
  memcpy(prechi->solution_counts,
    prechi_partition_counts(solution), part_count);
  memcpy(prechi->solution_spans,
    prechi_partition_spans(solution), part_count);
}

// Updates the solution if the one provided is "better"
static void record_if_improved(Prechi *prechi, PrechiPartition *solution)
{
  int part_count = prechi_partition_boundary_count(solution) + 1;
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

// Returns 1 (true) to bound search, 0 (false) to continue
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
    for (int i = 0; i < prechi_partition_boundary_count(trial); ++i) {
      PrechiPartition *next_trial = prechi_partition_copy(trial);
      prechi_partition_join(next_trial,
        prechi_partition_sorted_offset(next_trial, i));
      advance_solution(prechi, next_trial, min_count, reductions + 1);
      next_trial = prechi_partition_destroy(next_trial);
    }
  }
}

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
}

int prechi_partition_count(Prechi *prechi) {
  return prechi->solution_part_count;
}
