#include <stdlib.h>
#include "prechi_partition.h"

/*
 Return "value" given the partition at a given offset.
 The value is used to sort the partitions by in order of interest.
 We favor removing ones in which the bins on either side have smaller counts.
*/
int prechi_partition_value(PrechiPartition *part, int offset) {
  int value;
  if (part->counts[offset] < part->counts[offset + 1]) {
    value = part->counts[offset];
  } else {
    value = part->counts[offset + 1];
  }
  return value;
}

/*
 Sort the partition offsets into sorted_offsets by increasing value.
 We use insertion sort to arrange the offsets based on the values.
*/
static void sort_partitions(PrechiPartition *part) {
  int *values = (int *)calloc(part->size, sizeof(int));
  for(int ofs = 0; ofs < part->size - 1; ++ofs) {
    values[ofs] = prechi_partition_value(part, ofs);
  }

  int *sofs = part->sorted_offsets;
  for(int i = 0; i < part->size - 1; ++i) {
    int j;
    for(j = i; 0 < j && values[i] < values[sofs[j-1]]; --j) {
      sofs[j] = sofs[j-1];
    }
    sofs[j] = i;
  }

  free(values);
}

/*
 Allocate and initialize a partition given
 weights and counts in the partitions.
*/
PrechiPartition *prechi_partition_create(
    int size, float *weights, int *counts) {
  PrechiPartition *part = (PrechiPartition *)malloc(sizeof(PrechiPartition));
  part->size = size;
  part->weights = (float *)calloc(size, sizeof(float));
  part->counts = (int *)calloc(size, sizeof(int));
  part->spans = (int *)calloc(size, sizeof(int));
  part->sorted_offsets = (int *)calloc(size, sizeof(int));
  for(int i = 0; i < part->size; ++i) {
    part->weights[i] = weights[i];
    part->counts[i] = counts[i];
    part->spans[i] = 1;
  }
  sort_partitions(part);
  return part;
}

/*
 Return memory for a partition to the heap.
*/
PrechiPartition *prechi_partition_destroy(PrechiPartition *part) {
  free(part->sorted_offsets);
  free(part->spans);
  free(part->counts);
  free(part->weights);
  free(part);
  return NULL;
}

/*
 Return a copy of the given partition
*/
PrechiPartition *prechi_partition_copy(PrechiPartition *part) {
  PrechiPartition *copy = prechi_partition_create(part->size,
    part->weights, part->counts);
  for(int i = 0; i < part->size; ++i) {
    copy->spans[i] = part->spans[i];
    copy->sorted_offsets[i] = part->sorted_offsets[i];
  }
  return copy;
}

static float compute_balanced_mean(PrechiPartition *part, int offset) {
  float left = part->spans[offset] * part->weights[offset];
  float right = part->spans[offset + 1] * part->weights[offset + 1];
  int new_span = part->spans[offset] + part->spans[offset + 1];
  return ((left + right) / new_span);
}

static void do_join(PrechiPartition *part, int offset) {
  part->counts[offset] += part->counts[offset + 1];
  part->weights[offset] = compute_balanced_mean(part, offset);
  part->spans[offset] += part->spans[offset + 1];
  part->size -= 1;
  for(int i = offset + 1; i < part->size; ++i) {
    part->counts[i] = part->counts[i + 1];
    part->spans[i] = part->spans[i + 1];
    part->weights[i] = part->weights[i + 1];
  }
  sort_partitions(part);
}

/*
Join two partitions at boundary offset. There are part->size - 1
boundaries. The boundary with offset zero occurs between the first
and second partition.

This function produces a side-effect on part. Assuming the offset is
valid, after the call, the part has one fewer partitions. The two
partitions on either side of the offset are one. In the combined
partition:
- the count is the sum of counts
- the weight is the average by spans and weights
- the span is the sum of the spans of the joined partitions.
The sorted_offsets are updated to keep partitions in order of increasing count.

offset is in range 0 <= offset < part->size - 1
*/
void prechi_partition_join(PrechiPartition *part, int offset) {
  if (0 <= offset && offset < part->size - 1) do_join(part, offset);
}

/*
Returns the sorted partition offset given an ordinal offset.
This enables traversal of the partitions in sorted order.

offset is in range 0 <= offset < part->size - 1

If the offset given is out of range, the function returns zero.
*/
int prechi_partition_sorted_offset(PrechiPartition *part, int offset) {
  int sofs = 0;
  if (0 <= offset && offset < part->size - 1) {
    sofs = part->sorted_offsets[offset];
  }
  return sofs;
}
