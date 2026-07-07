## CRAN comments for prova 1.0.0

Third submission. Corrections after reviewer's feedback (many thanks):

- The user's 'par' is now restored with 'on.exit()' *immediately* after being altered with 'par()': see lines 218-219 in file 'util_plotfunctions.R'. (Apologies for wasting reviewer's time by not following instructions properly!)

Previous corrections, left for reference:

- Removed redundant "Functions for..." from DESCRIPTION.

- Added \value to .Rd files for all functions (even those with no return value), including description of structure of returned object. Added appropriate links to classes for return objects of special class (e.g. "histogram" in 'hist.probability()').

- Added argument 'verbose =' to all functions that output information to console. Default for all is 'FALSE', so no messages to console unless the user explicitly asks for it. Only exception with 'verbose = TRUE' is the function 'learn()', from which users typically want information about remaining computation time. But also in this case no information at all is printed to console if the user sets 'verbose = FALSE'.
  
  Please note: 'cat()' and 'print()' in the internal function 'workerfun()' only print to temporary files, never to console, and they do so in a temporary, non-interactive R session spawned by 'parallel::parLapply()'.

- Cleaned code, added documentation, improved a vignette.

- Spellings signalled in CRAN automated check have been double-checked.

- URLs signalled in CRAN automated check have been checked, they work.

### R CMD check results

Linux (R-devel), Windows (win-builder, R-devel):

0 errors | 0 warnings | 1 note

### Reverse dependency check:

No reverse dependencies.
