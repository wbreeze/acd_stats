#ifndef TEST_PARTITION_H
#define TEST_PARTITION_H

#include "../src/prechi_partition.h"

typedef struct {
  float *weights;
  int *counts;
} TestData;

TestData *create_test_data(int count);
void destroy_test_data(TestData *td);

#endif
