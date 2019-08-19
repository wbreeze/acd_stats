#ifndef PRECHI_PARTITION_H
#define PRECHI_PARTITION_H
#include "config.h"

typedef struct PrechiPartition {
  int size;
  float *weights;
  int *counts;
  int *spans;
  int removed_count;
  float mean;
  float variance;
} PrechiPartition;

PrechiPartition *prechi_partition_create(int size);
PrechiPartition *prechi_partition_destroy(PrechiPartition *part);
PrechiPartition *prechi_partition_copy(PrechiPartition *part);

void prechi_partition_join(PrechiPartition *part, int offset);

#endif
