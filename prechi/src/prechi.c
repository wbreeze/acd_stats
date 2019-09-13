#include <math.h>
#include <stdio.h> // DEBUG printf
#include <stdlib.h>
#include <string.h>
#include "prechi.h"
#include "prechi_partition.h"

/*
 Create the data structure for solving the cluster neighbors problem.
 weights: of the "categories" They are grade values. The values should
   be increasing, each greater than the prior, as in sorted.
 counts: of occurrences of each category.
 count: how many grade values are represented with counts

 When taking weighted average, the weights are the values and the counts
 are the weights.

 R keeps double precision. So we accept double for the weights. Then
 we downcast that to float, because that's good enough. Good enough because
 in this application the weights are integral anyway. We need to represent
 1/2, 1/3, 1/4, 1/5, ... 1/n for small number of n as weights of joined
 parts. This decision is sparing in use of memory where the amount of
 memory isn't all that much to begin with. It could be revisited.
*/
Prechi *prechi_create(const double *weights, const int *counts, int count) {
  Prechi *prechi = (Prechi*)malloc(sizeof(Prechi));

  prechi->count = count;
  prechi->weights = (float *)calloc(count, sizeof(float));
  prechi->counts = (int *)calloc(count, sizeof(int));
  prechi->target_mean = 0.0f;
  prechi->target_variance = 0.0f;
  prechi->solution_part_count = 0;
  prechi->solution_mean = 0.0f;
  prechi->solution_variance = 0.0f;
  prechi->solution_counts = (int *)calloc(count, sizeof(int));
  prechi->solution_spans = (int *)calloc(count, sizeof(int));
  prechi->solution_boundaries = (float*)calloc(count, sizeof(float));

  for (int i = 0; i < count; ++i) {
    prechi->counts[i] = counts[i];
    prechi->weights[i] = (float)weights[i];
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
    printf("%d, ", prechi->solution_counts[i]);
  }
  printf("\n");
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

/*
 Returns 1 (true) to bound trials, 0 (false) to continue
 We don't try partitions beyond the limit, nor those which have
 elements on both sides at or exceeding the minimum count required.
*/
static int trial_bound(PrechiPartition *trial, int offset, int min_count) {
  return(
    trial->size - 1 <= offset ||
    min_count <= prechi_partition_minimum_count(trial, offset)
  );
}

// Check the trial solution and record it, or advance after bound
static void advance_solution(Prechi *prechi, PrechiPartition *trial,
  int min_count, int reductions)
{
  if (min_count <= prechi_partition_minimum_count(trial, 0)) {
    record_if_improved(prechi, trial);
  } else if (!bounded(prechi, reductions)) {
    for (int i = 0; !trial_bound(trial, i, min_count); ++i) {
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
