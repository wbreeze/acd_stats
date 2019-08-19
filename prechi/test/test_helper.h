#ifndef TEST_HELPER_H
#define TEST_HELPER_H

#include <string.h>

#define set_array(array, value, count) \
  for(int i = 0; i < count; ++i) array[i] = value;

#define assert_equal_array(expected_value, have, count) {\
  int i; \
  for(i = 0; i < count && expected_value == have[i]; ++i); \
  if (i < count) cut_fail("Unequal array at index %d", i); \
}

#define copy_int_array(dest, src, count) \
  memcpy(dest, src, (count) * sizeof(int))

#define clear_int_array(array, count) \
  memset(array, 0, (count) * sizeof(int))

#define copy_float_array(dest, src, count) \
  memcpy(dest, src, (count) * sizeof(float))

#define clear_float_array(array, count) \
  memset(array, 0, (count) * sizeof(float))

#endif
