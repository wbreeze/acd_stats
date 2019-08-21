#ifndef PRECHI_PARTITION_H
#define PRECHI_PARTITION_H
#include "config.h"

typedef struct PrechiPartition {
  int size;
  float *weights;
  int *counts;
  int *spans;
  int *sorted_offsets;
} PrechiPartition;

PrechiPartition *prechi_partition_create(int size, float *weights, int *counts);
PrechiPartition *prechi_partition_destroy(PrechiPartition *part);
PrechiPartition *prechi_partition_copy(PrechiPartition *part);

void prechi_partition_join(PrechiPartition *part, int offset);

int prechi_partition_sorted_offset(PrechiPartition *part, int offset);
int prechi_partition_value(PrechiPartition *part, int offset);
int prechi_partition_boundary_count(PrechiPartition *part);
int prechi_partition_minimum_count(PrechiPartition *part);
const int *prechi_partition_counts(PrechiPartition *part);
const int *prechi_partition_spans(PrechiPartition *part);
float prechi_partition_mean(PrechiPartition *part);
float prechi_partition_variance(PrechiPartition *part, float mean);

#endif
