# Package index

## Learn from data

- [`learn()`](https://pglpm.github.io/prova/reference/learn.md) : Monte
  Carlo computation of posterior probability distribution

- [`learntExample`](https://pglpm.github.io/prova/reference/learntExample.md)
  :

  Example `learnt` object produced by learn()

## Calculate probabilities & statistics

- [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) : Calculate
  posterior probabilities
- [`qPr()`](https://pglpm.github.io/prova/reference/qPr.md) : Calculate
  quantiles
- [`vrtgrid()`](https://pglpm.github.io/prova/reference/vrtgrid.md) :
  Create a grid of values for a variate

## Generate synthetic datapoints

- [`rPr()`](https://pglpm.github.io/prova/reference/rPr.md) : Generate
  datapoints

## Quantify associations between variates

- [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
  : Calculate mutual information between groups of joint variates

## Plot & print

- [`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md)
  : Plot numeric or character values
- [`hist(`*`<mi>`*`)`](https://pglpm.github.io/prova/reference/hist.mi.md)
  : Plot the revisability of an object of class "MI" as a histogram
- [`hist(`*`<probability>`*`)`](https://pglpm.github.io/prova/reference/hist.probability.md)
  : Plot the revisability of an object of class "probability" as a
  histogram
- [`plot(`*`<probability>`*`)`](https://pglpm.github.io/prova/reference/plot.probability.md)
  : Plot an object of class "probability"
- [`plotquantiles()`](https://pglpm.github.io/prova/reference/plotquantiles.md)
  : Plot pairs of quantiles
- [`print(`*`<mi>`*`)`](https://pglpm.github.io/prova/reference/print.mi.md)
  : Print an object of class "MI" (mutual information)
- [`print(`*`<probability>`*`)`](https://pglpm.github.io/prova/reference/print.probability.md)
  : Print an object of class "probability"

## Handle metadata and data files

- [`metadataExample`](https://pglpm.github.io/prova/reference/metadataExample.md)
  : Example metadata file

- [`metadatatemplate()`](https://pglpm.github.io/prova/reference/metadatatemplate.md)
  : Metadata and helper function for metadata

- [`pwrite.csv()`](https://pglpm.github.io/prova/reference/prova.data.md)
  [`pread.csv()`](https://pglpm.github.io/prova/reference/prova.data.md)
  :

  Write and read CSV files in **Prova**

## Internal functions

For developers (beware!)

- [`.Pcheckpoints()`](https://pglpm.github.io/prova/reference/dot-Pcheckpoints.md)
  : Calculate joint frequencies for MCMC-monitoring checkpoints
- [`.buildauxmetadata()`](https://pglpm.github.io/prova/reference/dot-buildauxmetadata.md)
  : Build augmented metadata file
- [`.cleanup()`](https://pglpm.github.io/prova/reference/dot-cleanup.md)
  : Cleanup a learn()-output directory
- [`.combineYX()`](https://pglpm.github.io/prova/reference/dot-combineYX.md)
  : Calculate probabilities, quantiles, etc, for all Y and X
  combinations
- [`.createQfunction()`](https://pglpm.github.io/prova/reference/dot-createQfunction.md)
  : Calculate and save transformation function for ordinal variates
- [`.denorm()`](https://pglpm.github.io/prova/reference/dot-denorm.md) :
  Utility function to improve accuracy
- [`.fftNGS()`](https://pglpm.github.io/prova/reference/dot-fftNGS.md) :
  Find optimal FFT size
- [`.funAC()`](https://pglpm.github.io/prova/reference/dot-funAC.md) :
  Compute autocovariance
- [`.funESS3()`](https://pglpm.github.io/prova/reference/dot-funESS3.md)
  : Compute ESS
- [`.funMCEQ()`](https://pglpm.github.io/prova/reference/dot-funMCEQ.md)
  : Calculate credibility quantiles on estimated quantile
- [`.funMCSELD()`](https://pglpm.github.io/prova/reference/dot-funMCSELD.md)
  : Calculate MC standard error using LaplacesDemon's batch means
- [`.joinPtraces()`](https://pglpm.github.io/prova/reference/dot-joinPtraces.md)
  : Join '\_\_\_\_tempPtraces-' files
- [`.learnbind()`](https://pglpm.github.io/prova/reference/dot-learnbind.md)
  : Bind 3D arrays by first dimension
- [`.lprobsargsyx()`](https://pglpm.github.io/prova/reference/dot-lprobsargsyx.md)
  : Prepare arguments for util_lprobsyx from data
- [`.lprobsbase()`](https://pglpm.github.io/prova/reference/dot-lprobsbase.md)
  : Calculate collection of log-probabilities for different components
  and samples
- [`.lprobsmi()`](https://pglpm.github.io/prova/reference/dot-lprobsmi.md)
  : Calculate and combine log-probabilities to compute entropies
- [`.mcjoin()`](https://pglpm.github.io/prova/reference/dot-mcjoin.md) :
  Concatenate mcsample objects
- [`.mcsubset()`](https://pglpm.github.io/prova/reference/dot-mcsubset.md)
  : Eliminate samples from mcsamples object
- [`.plotFsamples()`](https://pglpm.github.io/prova/reference/dot-plotFsamples.md)
  : Plot one-dimensional posterior probabilities
- [`.prepPcheckpoints()`](https://pglpm.github.io/prova/reference/dot-prepPcheckpoints.md)
  : Format datapoints used for MCMC monitoring
- [`.prsubset()`](https://pglpm.github.io/prova/reference/dot-prsubset.md)
  : Subset variates of an object of class "probability"
- [`.qYXcont()`](https://pglpm.github.io/prova/reference/dot-qYXcont.md)
  : Calculate quantiles for continuous Y by bisection
- [`.qYXdiscr()`](https://pglpm.github.io/prova/reference/dot-qYXdiscr.md)
  : Calculate quantiles for discrete Y by bisection
- [`.rowcumsum()`](https://pglpm.github.io/prova/reference/dot-rowcumsum.md)
  : Cumulative sum along first dimension
- [`.rowinvcumsum()`](https://pglpm.github.io/prova/reference/dot-rowinvcumsum.md)
  : Inverse cumulative sum along first dimension
- [`.signifC()`](https://pglpm.github.io/prova/reference/dot-signifC.md)
  : Format numbers respecting significant digits
- [`.testPr()`](https://pglpm.github.io/prova/reference/dot-testPr.md) :
  Test posterior probabilities
- [`.vtransform()`](https://pglpm.github.io/prova/reference/dot-vtransform.md)
  : Transforms variates to different representations
- [`.workerfun()`](https://pglpm.github.io/prova/reference/dot-workerfun.md)
  : Worker function called by learn()
- [`prova`](https://pglpm.github.io/prova/reference/prova-package.md)
  [`prova-package`](https://pglpm.github.io/prova/reference/prova-package.md)
  : prova: Nonparametric Probabilistic-Statistical Variate Analysis with
  Automated Markov-Chain Monte Carlo
