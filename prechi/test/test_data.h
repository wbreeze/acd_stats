#ifndef TEST_DATA_H
#define TEST_DATA_H

typedef struct {
  float *weights;
  int *counts;
  double *dweights;
} TestData;

TestData *create_test_data(int count);
void destroy_test_data(TestData *td);

#endif
