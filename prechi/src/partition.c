#include <stdio.h>
#include "partition.h"

void partition_echo(int *counts, int *weights, int n) {
  printf("COUNTS (%d): ", n);
  for (int i = 0; i < n; ++i) {
    printf(" %d ", counts[i]);
  }
  printf("WEIGHTS (%d): ", n);
  for (int i = 0; i < n; ++i) {
    printf(" %d ", weights[i]);
  }
}
