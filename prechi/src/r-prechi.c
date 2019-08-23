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
  Rprintf("Input has %d parts.\n", n);
  const double *grades = REAL_RO(grade_values);
  const int *counts = INTEGER_RO(grade_counts);
  int minimum_count = INTEGER_RO(min_size)[0];

  Rprintf("Minimum count: %d\n", minimum_count);
  Rprintf("Counts: ");
  for(int i = 0; i < n; ++i) {
    Rprintf("%2d ", counts[i]);
  }
  Rprintf("\nGrades: ");
  for(int i = 0; i < n; ++i) {
    Rprintf("%5.2f ", grades[i]);
  }

  Prechi *prechi = prechi_create(grades, counts, n);
  prechi_solve(prechi, minimum_count);

  int rct = prechi->solution_part_count;
  Rprintf("\nRESULT has %d parts.\n", rct);
  Rprintf("Boundaries: ");
  for(int i = 0; i < rct - 1; ++i) {
    Rprintf("%5.2f ", prechi->solution_boundaries[i]);
  }
  Rprintf("\nCounts: ");
  for(int i = 0; i < rct; ++i) {
    Rprintf("%d ", prechi->solution_counts[i]);
  }
  Rprintf("\nTarget Mean: %5.2f, Variance: %6.2f\n",
    prechi->target_mean, prechi->target_variance);
  Rprintf("Solution Mean: %5.2f, Variance: %6.2f\n",
    prechi->solution_mean, prechi->solution_variance);

  prechi_destroy(prechi);

  // dummy return to see if this compiles
  return allocVector(REALSXP, 1);
}

static const R_CallMethodDef PreChiEntries[] = {
  {"pre_chi_cluster_neighbors", (DL_FUNC)&pre_chi_cluster_neighbors, 3},
  {NULL, NULL, 0}
};

void R_init_prechi(DllInfo *dll) {
  R_registerRoutines(dll, NULL, PreChiEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE); // .Call(pre_chi_cluster_neighbors, ...)
}
