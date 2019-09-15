#include <R.h>
#include <Rinternals.h>
#include <math.h>
#include "prechi.h"

/*
 R wrapper for Prechi#prechi_solve
 grade_values is a vector of integers with increasing value
 grade_counts is a same size vector of integer counts
 min_size is the minimum number of counts needed for any given grade,
   usually 5.
 max_seconds is a timeout in seconds. Sending zero will result in a
   one hour timeout. The algorithm returns the current result at the
   timeout, or the first result found after the timeout.
 min_parts_count is the minimum number of partitions required for the solution
 The return is a list with:
   grade_counts: vector of clustered, integer counts
   boundaries: vector of real number partition boundaries
*/
SEXP pre_chi_cluster_neighbors(
  SEXP grade_values, SEXP grade_counts, SEXP min_size, SEXP max_seconds,
  SEXP min_parts_count)
{
  int n = length(grade_values);
  const double *grades = REAL_RO(grade_values);
  const int *counts = INTEGER_RO(grade_counts);
  int minimum_count = INTEGER_RO(min_size)[0];
  int maximum_seconds = INTEGER_RO(max_seconds)[0];
  int minimum_parts = INTEGER_RO(min_parts_count)[0];

  Prechi *prechi = prechi_create(grades, counts, n);
  prechi_set_minimum_partition_count(prechi, minimum_parts);
  prechi_set_minimum_count(prechi, minimum_count);
  prechi_set_timeout_seconds(prechi, maximum_seconds);
  prechi_solve(prechi);

  int part_ct = prechi->solution_part_count;
  int prct = 0;

  // Set-up the returned list
  SEXP rv = PROTECT(allocVector(VECSXP, 8)); ++prct;
  SEXP names = PROTECT(allocVector(STRSXP, 8)); ++prct;
  SET_STRING_ELT(names, 0, mkChar("count"));
  SET_STRING_ELT(names, 1, mkChar("boundaries"));
  SET_STRING_ELT(names, 2, mkChar("counts"));
  SET_STRING_ELT(names, 3, mkChar("target_mean"));
  SET_STRING_ELT(names, 4, mkChar("target_variance"));
  SET_STRING_ELT(names, 5, mkChar("solution_mean"));
  SET_STRING_ELT(names, 6, mkChar("solution_variance"));
  SET_STRING_ELT(names, 7, mkChar("did_timeout"));
  setAttrib(rv, R_NamesSymbol, names);

  // Set count on returned list
  SEXP count = PROTECT(allocVector(INTSXP, 1)); ++prct;
  INTEGER(count)[0] = part_ct;
  SET_VECTOR_ELT(rv, 0, count);

  // Set boundaries on returned list
  SEXP boundaries = PROTECT(allocVector(REALSXP, part_ct + 1)); ++prct;
  double *pb = REAL(boundaries);
  pb[0] = -INFINITY;
  for(int i = 0; i < part_ct - 1; ++i) {
    pb[i+1] = (double)prechi->solution_boundaries[i];
  }
  pb[part_ct] = INFINITY;
  SET_VECTOR_ELT(rv, 1, boundaries);

  // Set counts on returned list
  SEXP solution_counts = PROTECT(allocVector(INTSXP, part_ct)); ++prct;
  int *pc = INTEGER(solution_counts);
  for(int i = 0; i < part_ct; ++i) {
    pc[i] = prechi->solution_counts[i];
  }
  SET_VECTOR_ELT(rv, 2, solution_counts);

  // Set target_mean on returned list
  SEXP target_mean = PROTECT(allocVector(REALSXP, 1)); ++prct;
  REAL(target_mean)[0] = prechi->target_mean;
  SET_VECTOR_ELT(rv, 3, target_mean);

  // Set target_variance on returned list
  SEXP target_variance = PROTECT(allocVector(REALSXP, 1)); ++prct;
  REAL(target_variance)[0] = prechi->target_variance;
  SET_VECTOR_ELT(rv, 4, target_variance);

  // Set solution_mean on returned list
  SEXP solution_mean = PROTECT(allocVector(REALSXP, 1)); ++prct;
  REAL(solution_mean)[0] = prechi->solution_mean;
  SET_VECTOR_ELT(rv, 5, solution_mean);

  // Set solution_variance on returned list
  SEXP solution_variance = PROTECT(allocVector(REALSXP, 1)); ++prct;
  REAL(solution_variance)[0] = prechi->solution_variance;
  SET_VECTOR_ELT(rv, 6, solution_variance);

  // Set timeout indicator on returned list
  SEXP timeout = PROTECT(allocVector(LGLSXP, 1)); ++prct;
  LOGICAL(timeout)[0] = prechi->did_timeout != 0;
  SET_VECTOR_ELT(rv, 7, timeout);

  prechi_destroy(prechi);
  UNPROTECT(prct);
  return rv;
}

static const R_CallMethodDef PreChiEntries[] = {
  {"pre_chi_cluster_neighbors", (DL_FUNC)&pre_chi_cluster_neighbors, 5},
  {NULL, NULL, 0}
};

void R_init_prechi(DllInfo *dll) {
  R_registerRoutines(dll, NULL, PreChiEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE); // .Call(pre_chi_cluster_neighbors, ...)
}
