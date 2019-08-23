#include <stdio.h> //DEBUG
#include <R.h>
#include <Rinternals.h>
#include "prechi.h"

/*
 R wrapper for Prechi#prechi_solve
 grade_values is a vector of integers with increasing value
 grade_counts is a same size vector of integer counts
 min_size is the minimum number of counts needed for any given grade,
   usually 5.
 The return is a list with:
   grade_counts: vector of clustered, integer counts
   boundaries: vector of real number partition boundaries
*/
SEXP pre_chi_cluster_neighbors(
  SEXP grade_values, SEXP grade_counts, SEXP min_size)
{
  int n = length(grade_values);
  printf("%d parts\n", n);
  const double *grades = REAL_RO(grade_values);
  const int *counts = INTEGER_RO(grade_counts);
  int minimum_count = INTEGER_RO(min_size)[0];

  printf("\nCounts: ");
  for(int i = 0; i < n; ++i) {
    printf("%2d ", counts[i]);
  }
  printf("\nGrades: ");
  for(int i = 0; i < n; ++i) {
    printf("%5.2f ", grades[i]);
  }
  printf("\nMinimum count: %d\n", minimum_count);

  // dummy return to see if this compiles
  return allocVector(REALSXP, 1);
}
