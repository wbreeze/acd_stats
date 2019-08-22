#ifndef TEST_HELPER_H
#define TEST_HELPER_H

#include <math.h>

#define float_approx(value, precision) \
  ((int)((value) * pow(10, precision)))

#define assert_equal_float(expected, have, precision) \
  cut_assert_equal_int(float_approx(expected, precision), \
    float_approx(have, precision))

#define assert_same_value_array(expected_value, have, count) {\
  int i; \
  for(i = 0; i < count && expected_value == have[i]; ++i); \
  if (i < count) cut_fail("Unequal array at index %d", i); \
}

#define assert_equal_int_arrays(expected, have, count) { \
  int i; \
  for(i = 0; i < count && expected[i] == have[i]; ++i); \
  if (i < count) cut_fail("Unequal array at index %d", i); \
}

#define assert_equal_float_arrays(expected, have, count, precision) { \
  int i; \
  for(i = 0; i < count && \
    float_approx(expected[i], precision) == float_approx(have[i], precision); \
    ++i); \
  if (i < count) cut_fail("Unequal array at index %d", i); \
}

#endif
