#infdef PRECHI_H
#define PRECHI_H
#include "config.h"
#include "prechi_partition.h"

typedef struct Prechi {
  int count;
  int *weights;
  int *counts;
  PrechiPartition *solution;
} Prechi;

#endif
