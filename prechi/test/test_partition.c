#include <cutter.h>
#include "partition.h"

void test_partition_echo(void)
{
  const int n = 8;
  int counts[n] = {1,2,0,4,8,6,0,3};
  int weights[n] = {65, 70, 75, 80, 85, 90, 95, 100};

  partition_echo(counts, weights, n);

  cut_assert_equal_int(counts[0], 1);
}
