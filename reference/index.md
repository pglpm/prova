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

## Plot & print probability distributions

- [`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md)
  : Plot numeric or character values
- [`hist(`*`<MI>`*`)`](https://pglpm.github.io/prova/reference/hist.MI.md)
  : Plot the revisability of an object of class "MI" as a histogram
- [`hist(`*`<probability>`*`)`](https://pglpm.github.io/prova/reference/hist.probability.md)
  : Plot the revisability of an object of class "probability" as a
  histogram
- [`plot(`*`<probability>`*`)`](https://pglpm.github.io/prova/reference/plot.probability.md)
  : Plot an object of class "probability"
- [`plotquantiles()`](https://pglpm.github.io/prova/reference/plotquantiles.md)
  : Plot pairs of quantiles
- [`print(`*`<MI>`*`)`](https://pglpm.github.io/prova/reference/print.MI.md)
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

## Quantify associations between variate groups

- [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
  : Calculate mutual information between groups of joint variates

## Internal functions

For developers (beware!)

- [`buildauxmetadata()`](https://pglpm.github.io/prova/reference/buildauxmetadata.md)
  : Build augmented metadata file
- [`createQfunction()`](https://pglpm.github.io/prova/reference/createQfunction.md)
  : Calculate and save transformation function for ordinal variates
- [`fftNGS()`](https://pglpm.github.io/prova/reference/fftNGS.md) : Find
  optimal FFT size
- [`funAC()`](https://pglpm.github.io/prova/reference/funAC.md) :
  Compute autocovariance
- [`funESS3()`](https://pglpm.github.io/prova/reference/funESS3.md) :
  Compute ESS
- [`funMCEQ()`](https://pglpm.github.io/prova/reference/funMCEQ.md) :
  Calculate credibility quantiles on estimated quantile
- [`funMCSELD()`](https://pglpm.github.io/prova/reference/funMCSELD.md)
  : Calculate MC standard error using LaplacesDemon's batch means
- [`learnbind()`](https://pglpm.github.io/prova/reference/learnbind.md)
  : Bind 3D arrays by first dimension
- [`mcjoin()`](https://pglpm.github.io/prova/reference/mcjoin.md) :
  Concatenate mcsample objects
- [`mcsubset()`](https://pglpm.github.io/prova/reference/mcsubset.md) :
  Eliminate samples from mcsamples object
- [`plotFsamples()`](https://pglpm.github.io/prova/reference/plotFsamples.md)
  : Plot one-dimensional posterior probabilities
- [`prova`](https://pglpm.github.io/prova/reference/prova-package.md)
  [`prova-package`](https://pglpm.github.io/prova/reference/prova-package.md)
  : prova: Nonparametric Probabilistic-Statistical Variate Analysis with
  Automated Markov-Chain Monte Carlo
- [`prsubset()`](https://pglpm.github.io/prova/reference/prsubset.md) :
  Subset variates of an object of class "probability"
- [`rowcumsum()`](https://pglpm.github.io/prova/reference/rowcumsum.md)
  : Cumulative sum along first dimension
- [`rowinvcumsum()`](https://pglpm.github.io/prova/reference/rowinvcumsum.md)
  : Inverse cumulative sum along first dimension
- [`signifC()`](https://pglpm.github.io/prova/reference/signifC.md) :
  Format numbers respecting significant digits
- [`testPr()`](https://pglpm.github.io/prova/reference/testPr.md) : Test
  posterior probabilities
- [`util_Pcheckpoints()`](https://pglpm.github.io/prova/reference/util_Pcheckpoints.md)
  : Calculate joint frequencies for MCMC-monitoring checkpoints
- [`util_cleanup()`](https://pglpm.github.io/prova/reference/util_cleanup.md)
  : Cleanup a learn()-output directory
- [`util_combineYX()`](https://pglpm.github.io/prova/reference/util_combineYX.md)
  : Calculate probabilities, quantiles, etc, for all Y and X
  combinations
- [`util_denorm()`](https://pglpm.github.io/prova/reference/util_denorm.md)
  : Utility function to improve accuracy
- [`util_joinPtraces()`](https://pglpm.github.io/prova/reference/util_joinPtraces.md)
  : Join '\_\_\_\_tempPtraces-' files
- [`util_lprobsargsyx()`](https://pglpm.github.io/prova/reference/util_lprobsargsyx.md)
  : Prepare arguments for util_lprobsyx from data
- [`util_lprobsbase()`](https://pglpm.github.io/prova/reference/util_lprobsbase.md)
  : Calculate collection of log-probabilities for different components
  and samples
- [`util_lprobsmi()`](https://pglpm.github.io/prova/reference/util_lprobsmi.md)
  : Calculate and combine log-probabilities to compute entropies
- [`util_prepPcheckpoints()`](https://pglpm.github.io/prova/reference/util_prepPcheckpoints.md)
  : Format datapoints used for MCMC monitoring
- [`util_qYXcont()`](https://pglpm.github.io/prova/reference/util_qYXcont.md)
  : Calculate quantiles for continuous Y by bisection
- [`util_qYXdiscr()`](https://pglpm.github.io/prova/reference/util_qYXdiscr.md)
  : Calculate quantiles for discrete Y by bisection
- [`vtransform()`](https://pglpm.github.io/prova/reference/vtransform.md)
  : Transforms variates to different representations
- [`workerfun()`](https://pglpm.github.io/prova/reference/workerfun.md)
  : Worker function called by learn()
