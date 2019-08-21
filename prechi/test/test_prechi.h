#ifndef TEST_PRECHI_H
#define TEST_PRECHI_H

#include "../src/prechi.h"

typedef struct {
  int *weights;
  int *counts;
} PrechiTestData;

PrechiTestData *create_prechi_data(int count);
void destroy_prechi_data(PrechiTestData *td);

#endif
