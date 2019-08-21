#ifndef PRECHI_H
#define PRECHI_H

#include "config.h"
#include "prechi_partition.h"

typedef struct Prechi {
  int count;
  int *weights;
  int *counts;
} Prechi;

Prechi *prechi_create(int *weights, int *counts, int count);
Prechi *prechi_destroy(Prechi *prechi);

#endif
