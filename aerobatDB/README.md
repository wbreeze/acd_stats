# aerobatDB package

Aerobatic Contest Database Query Utilities

A collection of classes and functions for retrieving
and manipulating data frames from an aerobatic contest database (CDB).

For more information about the CDB see the source code project
[wbreeze/iaccdb](https://github.com/wbreeze/iaccdb).
Find it running, with data from aerobatic contests of the
International Aerobatic Club (IAC) in the United States at
[iac.org](https://iaccdb.iac.org/).

The CDB is organized in a very hierarchal manner:

- Contests contain categories which contain flight programs.
- Flight programs contain results for pilots and judges.
- Flight programs contain the detailed grading record of
  grades given by each judge to each pilot for each figure.

This package is limited to methods for querying the CDB and organizing the
results into data frames.  The CDB raw interface is a RESTful one that returns
JSON data strings.  The functions here provide a fairly thin layer over the
RESTful JSON interface.
