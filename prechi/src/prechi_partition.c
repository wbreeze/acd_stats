#include <stdlib.h>
#include "prechi_partition.h"

PrechiPartition *prechi_partition_create(int size) {
  PrechiPartition *part = (PrechiPartition *)malloc(sizeof(PrechiPartition));
  part->size = size;
  part->boundaries = (float *)calloc(size, sizeof(float));
  part->counts = (int *)calloc(size, sizeof(int));
  part->spans = (int *)calloc(size, sizeof(int));
  part->removed_count = 0;
  return part;
}

PrechiPartition *prechi_partition_copy(PrechiPartition *part) {
  return NULL;
}

PrechiPartition *prechi_partition_destroy(PrechiPartition *part) {
  free(part->spans);
  free(part->counts);
  free(part->boundaries);
  free(part);
  return NULL;
}
