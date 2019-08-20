#include <stdlib.h>
#include "prechi_partition.h"

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
  return part;
}

PrechiPartition *prechi_partition_destroy(PrechiPartition *part) {
  free(part->sorted_offsets);
  free(part->spans);
  free(part->counts);
  free(part->weights);
  free(part);
  return NULL;
}

PrechiPartition *prechi_partition_copy(PrechiPartition *part) {
  PrechiPartition *copy = prechi_partition_create(part->size,
    part->weights, part->counts);
  for(int i = 0; i < part->size; ++i) {
    copy->spans[i] = part->spans[i];
    copy->sorted_offsets[i] = part->sorted_offsets[i];
  }
  return copy;
}

float compute_balanced_mean(PrechiPartition *part, int offset) {
  float left = part->spans[offset] * part->weights[offset];
  float right = part->spans[offset + 1] * part->weights[offset + 1];
  int new_span = part->spans[offset] + part->spans[offset + 1];
  return ((left + right) / new_span);
}

void do_join(PrechiPartition *part, int offset) {
  part->counts[offset] += part->counts[offset + 1];
  part->weights[offset] = compute_balanced_mean(part, offset);
  part->spans[offset] += part->spans[offset + 1];
  part->size -= 1;
  for(int i = offset + 1; i < part->size; ++i) {
    part->counts[i] = part->counts[i + 1];
    part->spans[i] = part->spans[i + 1];
    part->weights[i] = part->weights[i + 1];
  }
}

void prechi_partition_join(PrechiPartition *part, int offset) {
  if (0 <= offset && offset < part->size - 1) do_join(part, offset);
}

int prechi_partition_sorted_offset(PrechiPartition *part, int offset) {
  return part->sorted_offsets[offset];
}
