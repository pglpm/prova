# Worker function called by .learnalt()

This worker function is defined outside of learn() in order to avoid
import of spurious objects into the parallel workers, and from the
parallel workes into the main R session, with waste of memory.
Alternative version that use Geyer's methods to compute ESS and MCSE,
for development use.

## Usage

``` r
.workerfunalt(
  acore,
  dirname,
  dashnameroot,
  avoidzeroW,
  initmethod,
  constants,
  datapoints,
  vn,
  showAlphatraces,
  Alphatoslice,
  Ktoslice,
  RWtoslice,
  changeSamplerOrder,
  minchainspercore,
  coreswithextrachain,
  nchains,
  maxhours,
  timestart0,
  showsamplertimes,
  startupMCiterations,
  maxMCiterations,
  showKtraces,
  ncomponents,
  plottraces,
  Qlo,
  Qhi,
  Qerror,
  minESS,
  initES,
  nsamplesperchain,
  minMCiterations,
  printtimediff,
  family,
  mainlog,
  verbose,
  ncores
)
```
