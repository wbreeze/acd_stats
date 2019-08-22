#ifndef TEST_DATA_H
#define TEST_DATA_H

#include "../src/prechi_partition.h"

typedef struct {
  float *weights;
  int *counts;
} TestData;

TestData *create_test_data(int count);
void destroy_test_data(TestData *td);

#endif
