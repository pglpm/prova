# Monte Carlo computation of posterior probability distribution

Compute the posterior joint probability distribution of the variates
conditional on the given data, by means of Markov-chain Monte Carlo,
using the package **Nimble**.

## Usage

``` r
learn(
  data,
  metadata,
  auxdata = NULL,
  outputdir = NULL,
  nsamples = 3600,
  nchains = 8,
  nsamplesperchain = 450,
  parallel = TRUE,
  seed = NULL,
  cleanup = TRUE,
  appendinfo = TRUE,
  valueisK = TRUE,
  subsampledata = NULL,
  prior = missing(data) || is.null(data),
  startupMCiterations = 3600,
  minMCiterations = 0,
  maxMCiterations = 9e+05,
  maxhours = +Inf,
  ncheckpoints = NULL,
  maxrelMCSE = 0.0471405,
  minESS = 450,
  initES = 8,
  thinning = NULL,
  verbose = TRUE,
  plottraces = !cleanup,
  showKtraces = FALSE,
  showAlphatraces = FALSE,
  hyperparams = list(ncomponents = 64, minalpha = -4, maxalpha = 4, byalpha = 1, Rshapelo
    = 0.5, Rshapehi = 0.5, Rvarm1 = 3^2, Cshapelo = 0.5, Cshapehi = 0.5, Cvarm1 = 3^2,
    Dshapelo = 0.5, Dshapehi = 0.5, Dvarm1 = 3^2, Bshapelo = 1, Bshapehi = 1, Dthreshold
    = 1, tscalefactor = 4.266, Oprior = "Hadamard", Nprior = "Hadamard", avoidzeroW =
    NULL, initmethod = "datacentre", Qerror = pnorm(c(-1, 1)))
)
```

## Arguments

- data:

  A dataset, given as a
  [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) or as a
  file path to a CSV file. If missing or `NULL`, then the prior
  probability distribution is calculated.

- metadata:

  [metadata](https://pglpm.github.io/prova/reference/metadata.md) about
  the dataset's variates, given either as a [data
  frame](https://rdrr.io/r/base/data.frame.html) or as a file path to a
  CSV file.

- auxdata:

  An *additional*, larger dataset, given as a data frame or as a file
  path to a CSV file. Such a dataset would be too large to use in the
  Monte Carlo sampling, but is used to help estimate some
  hyperparameters. Note that the `auxdata` and `data` datasets should
  *not* have datapoints in common.

- outputdir:

  `NULL` (default) or `NA` or character: path to folder where output
  information and diagnostics should be saved. If `NULL`, a directory is
  created in the temporary-directory space given by
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). If `NA`, a
  directory is created in the current working directory given by
  [`base::getwd()`](https://rdrr.io/r/base/getwd.html). If character,
  this is taken to be the output directory; it should of course be
  writable by the user.

- nsamples:

  Integer, default 3600: number of desired, *approximately independent*
  Monte Carlo samples. If this argument is changed, the user is also
  required to explicitly give either `nchains` or `nsamplesperchain`,
  but not both; the remaining third argument is determined from
  \\\mathrm{nsamples} = \mathrm{nchains} \times
  \mathrm{nsamplesperchain}\\.

- nchains:

  Integer, default 8: number of Monte Carlo chains. If this argument is
  changed, the user is also required to explicitly give either
  `nsamples` or `nsamplesperchain`, but not both; the remaining third
  argument is determined from \\\mathrm{nsamples} = \mathrm{nchains}
  \times \mathrm{nsamplesperchain}\\.

- nsamplesperchain:

  Integer, default 450: number of *approximately independent* Monte
  Carlo samples per chain. If this argument is changed, the user is also
  required to explicitly give either `nsamples` or `nchains`, but not
  both; the remaining third argument is determined from
  \\\mathrm{nsamples} = \mathrm{nchains} \times
  \mathrm{nsamplesperchain}\\.

- parallel:

  One of the following values:

  - A "cluster" object previously created with
    [`parallel::makeCluster()`](https://rdrr.io/r/parallel/makeCluster.html).

  - Positive integer: create a parallel cluster with this number of
    nodes (it will be stopped at the end).

  - `FALSE`: do not use clusters (one node is still generated, in order
    to eliminate temporary objects from the computation).

  - `TRUE` (default): use the cluster that was set as default with
    [`parallel::setDefaultCluster()`](https://rdrr.io/r/parallel/makeCluster.html);
    if no such object exists, then generate a cluster with as many nodes
    as in the [option](https://rdrr.io/r/base/options.html) "cl.cores";
    if this option is unset, then use 2 nodes.

- seed:

  Integer or `NULL` (default): use this seed for the random number
  generator. If `NULL`, do not set the seed.

- cleanup:

  Logical, default `TRUE`: remove diagnostic files at the end of the
  computation?

- appendinfo:

  Logical, default `TRUE`: append information about number of variates
  ('V'), number of data points ('D'), number of Monte Carlo samples
  ('S'), and timestamp, to the name of the output directory `outputdir`?
  The appended string has the format
  \\\mathrm{V}n\\\mathrm{D}n\\\mathrm{S}n\\\\\mathit{YYMMDD}\\\mathrm{T}\mathit{HHMMSS}\\.

- valueisK:

  Logical or `NULL`: should the `VALUE` returned be the `K`nowledge
  object containing the results from the Monte Carlo computation?
  Default `TRUE`. If `FALSE`, then `VALUE` is the output directory name.
  If `NULL`, then `VALUE` is `NULL`.

- subsampledata:

  Integer or `NULL` (default): if integer, use only that many datapoints
  from the original dataset in the `data` argument.

- prior:

  Logical: calculate the prior distribution? Default is `FALSE` unless
  `data` argument is missing or `NULL`.

- startupMCiterations:

  Integer, default 3600: number of initial Monte Carlo iterations per
  chain.

- minMCiterations:

  Integer, default 0: do at least this many Monte Carlo iterations per
  chain.

- maxMCiterations:

  Integer, default 900000: do at most this many Monte Carlo iterations
  per chain. Data is saved to disk during computation, so the user
  should increase or decrease this number according to disk capacity and
  complexity of the data.

- maxhours:

  Numeric, default `Inf`: stop the Monte Carlo computation after
  approximately this many hours, if it has not finished yet. A value of
  0 finishes the computation as soon as possible, compatibly with the
  arguments `startupMCiterations` and `minMCiterations`.

- ncheckpoints:

  Integer or `NULL`: number of datapoints (per chain) to be used for
  Monte Carlo checks and ending. If `NULL`, it is equal to the largest
  between 30 and 2 \\\times\\ (number of variates + 2), or all
  datapoints if they are less than this maximum. If `Inf`, use all
  datapoints.

- maxrelMCSE:

  Numeric positive, default 0.04: desired maximal *relative Monte Carlo
  Standard Error* of calculated probabilities per chain (after "burn-in"
  samples have been discarded). If missing, then argument `minESS` is
  used; if `minESS` is also missing, then the default value is used.
  `maxrelMCSE` is related to `minESS` by \\\mathrm{maxrelMCSE} =
  1/\sqrt{\mathrm{minESS}}\\.

- minESS:

  Numeric positive, default 625: desired minimal Monte Carlo *Expected
  Sample Size* per chain (after "burn-in" samples have been discarded).
  If missing, then argument `maxrelMCSE` is used; if `maxrelMCSE` is
  also missing, then the default value is used. `minESS` is related to
  `maxrelMCSE` by \\\mathrm{minESS} = 1/\mathrm{maxrelMCSE}^2\\.

- initES:

  Numeric positive, default 8: number of initial "burn-in" samples,
  separated by the Expected Sample Size, to be discarded per chain. Note
  that the Monte Carlo chain typically starts in a high-probability
  region, so there is no reason to discard many initial samples.

- thinning:

  Integer or `NULL` (default): thin out the Monte Carlo samples by this
  value. If `NULL`: let diagnostics decide the thinning value.

- verbose:

  Logical, default `TRUE`: output the progress also to terminal? If
  `FALSE`, the progress is outputted only to the file `'main.out'` in
  the `outputdir` directory.

- plottraces:

  Logical, default `TRUE`: save plots of the Monte Carlo traces of
  diagnostic values?

- showKtraces:

  Logical, default `FALSE`: save plots of the Monte Carlo traces of the
  K parameter?

- showAlphatraces:

  Logical, default `FALSE`: save plots of the Monte Carlo traces of the
  Alpha parameter?

- hyperparams:

  List: hyperparameters of the hyperprior; see values in "Usage".

## Value

A "K" (more precisely "prova_K") object, or name of directory containing
such an object and other output files, or `NULL`, depending on argument
`valueisK`. The elements of this object are described below.

`learn()` saves several files in a directory. By default this output
directory is a temporary directory within the one used by
[`base::tempdir()`](https://rdrr.io/r/base/tempfile.html), but an
alternative one can be chosen with the argument `outputdir = `. The
output directory contain several diagnostic files for the Monte Carlo
computation; in particular:

- `MCtraces.pdf`: shows several trace plots of the Monte Carlo sampling;
  the corresponding data are in the file `MCtraces.rds`.

- `plotsamples_learn.pdf`, `plotquantiles_learn.pdf`: show the marginal
  posterior distributions of each individual variate, together with
  their "revisability" (as samples or quantiles).

- `log-1.out`, `log-2.out`, ... one for each parallel node; report the
  progress of each parallel Monte Carlo computation and notes about it.

- `rng_seed.rds`: the state of the pseudorandom seed (see
  [base::Random](https://rdrr.io/r/base/Random.html)) when `learn()` was
  called.

- `metadata.csv`: a copy of the metadata.

It is recommended that an explicit argument `outputdir = ` be given, so
as to save the directory with the files above for future reference. In
particular, the `MCtraces.pdf` plot and `MCtraces.rds` data can be
useful to report Monte Carlo convergence in any work that used
**Prova**.

During operation, computation progress and estimated end times for each
node's computation are outputted to the file `'main.out'` in the output
directory, and also to the console if argument `verbose` is `TRUE`. Note
that the estimated end times are very approximate and often quite
conservative.

*Typical elements of the "K" ojbect*

- Some among `Rmean`, `Rsd`, `Cmean`, `Csd`, `Dmean`, `Dsd`, `Nprob`,
  `Oprob`, `Bprob`, depending on the kinds of data variates: samples of
  component kernel hyperparameters.

- `W`: samples of component weights.

- `MCindex`: Monte Carlo iteration indices.

- `auxmetadata`: list of metadata and auxiliary metadata values.

- `info`: information about the Monte Carlo run and some additional
  information: `metadata`, `nMCsamples`, `nchains`, `npoints`,
  `maxiterations`, `maxusedcomponents`, `nonfinitechains`,
  `stoppedchains`. Also `.Random.seed` containing the
  [random-seed](https://rdrr.io/r/base/Random.html) state when `learn()`
  was called; `args` containing most arguments with which the function
  was called; `diagn` containing final Monte Carlo diagnostics such as
  relative Monte Carlo Standard Error and Effective Sample Size.

## Details

To use this function, the package
[**Nimble**](https://cran.r-project.org/package=nimble) needs to be
installed.

This function takes as main inputs a set of data and metadata, and
computes the full joint probability distribution for new data, including
its "revisability". From this full joint distribution any other
distributions of interest can subsequently be computed; see
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) and related
functions. This computation can also be interpreted as an estimation of
the full joint frequency distribution of the variates in the *whole
population*, beyond the sample data, together with its uncertainty. The
computation allows for the use of datapoints with partially missing
variables: imputation is automatically made. This imputation is
*principled*, made according to the rules of probability theory.

The output is a "K" (more precisely "prova_K") object, typically saved
in a `K.rds` file, which is used in all subsequent probabilistic
computations. Other information about the computation is provided in
logs and plots, saved in a directory specified by the user.

See
[`vignette('intro')`](https://pglpm.github.io/prova/articles/intro.md)
for introductory examples.

The computation is "non-parametric": probability or frequency
distributions are not assumed to be Gaussian or of any other specific
shape; no "model" is assumed. The mathematical representation of the
space of joint frequency distributions follows ideas of Dunson &
Bhattacharya (2011); see [technical
manual](https://github.com/pglpm/prova/raw/main/development/manual/pglpm2024-bayes_nonparam.pdf)
for details.

The computation is done via Markov-chain Monte Carlo, using the package
**Nimble**. "Convergence" of the Monte Carlo computation is
automatically assessed with methods similar to those described in
Vehtari & al. (2021), Kwon & al. (2025), Flegal & al (2008)
<doi:10.1214/08-STS257>, Jones & al. (2006):
<doi:10.1198/016214506000000492>; see [technical
manual](https://github.com/pglpm/prova/raw/main/development/manual/pglpm2024-bayes_nonparam.pdf)
for details. The default values for convergence require that all of the
following three conditions be fulilled:

- The computation's numerical error (Monte-Carlo Standard Error) for the
  posterior probability must be smaller than 4.7% of the standard
  deviation of the posterior's variability.

- The computation's numerical error for the 0.055- and 0.945-percentiles
  of the posterior's variability should be smaller than 4.7% of the
  distance between them.

Typically this requirement leads to final results obtained with the
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) function having
at least two significant digits.

The `learn()` function can take hours or even days to perform its
computations, depending on the size of the dataset, number of variates,
and the (initially unknown) "shape" of the underlying probability
distribution. For this reason it is typically called within an R script,
executed via [utils::Rscript](https://rdrr.io/r/utils/Rscript.html). For
example, a script 'myscript.R' could have the following structure:

    library('prova')

    learn(
      data = 'filename_with_data.csv', # CSV file containing the dataset
      metadata = 'filename_with_metadata.csv', # CSV file containing the metadata
      outputdir = 'some_directory', # path to output directory
      parallel = 8 # let's say machine has more than 8 cores, so we use 8
      ## possibly other arguments to learn()
    )

and then be called on a bash terminal with

    $ Rscript myscript.R > learnoutput.out 2>&1 &

with such a call, the file 'learnoutput.out' will contain information
about how the computation is proceeding and the estimated end time.

## References

For the mathematical representation of the frequency space:

- Dunson, Bhattacharya (2011): *Nonparametric Bayes regression and
  classification through mixtures of product kernels*
  <doi:10.1093/acprof:oso/9780199694587.003.0005>.

- Ishwaran, Zarepour (2002): *Exact and approximate sum representations
  for the Dirichlet process* <doi:10.2307/3315951>.

- Porta Mana
  <https://github.com/pglpm/prova/raw/main/development/manual/pglpm2024-bayes_nonparam.pdf>.

About Bayesian inference under exchangeability ("population inference"):

- Lindley, Novick (1981): *The role of exchangeability in inference*,
  <doi:10.1214/aos/1176345331>.

- Bernardo, Smith (2000): *Bayesian Theory*, Wiley
  <doi:10.1002/9780470316870>.

- Fortini, Petrone (2024): *Prediction-based uncertainty quantification
  for exchangeable sequences*, <doi:10.1098/rsta.2022.0142>.

- Porta Mana
  <https://github.com/pglpm/prova/raw/main/development/manual/pglpm2024-bayes_nonparam.pdf>.

About nonparametrics:

- Müller et al. (2015): *Nonparametric Bayesian inference*, IMS
  <doi:10.1007/978-3-319-18968-0>.

- Hjort et al. (2010): *Bayesian Nonparametrics*, Cambridge University
  Press <doi:10.1017/CBO9780511802478>.

About Markov-chain Monte Carlo and "convergence":

- de Valpine, Paciorek, Turek, & al. (2026): *NIMBLE: MCMC, Particle
  Filtering, and Programmable Hierarchical Modeling*,
  <doi:10.5281/zenodo.1211190>,
  <https://cran.r-project.org/package=nimble>.

- Kwon & al. (2025): *MCMC stopping rules in latent variable modelling*,
  <doi:10.1111/bmsp.12357>.

- Vehtari & al. (2021): *Rank-normalization, folding, and localization:
  an improved R-hat for assessing convergence of MCMC*,
  <doi:10.1214/20-BA1221>.

- Roy (2020): *Convergence diagnostics for Markov chain Monte Carlo*,
  <doi:10.1146/annurev-statistics-031219-041300>.

- Flegal & al. (2008): *Markov chain Monte Carlo: can we trust the third
  significant figure?*, <doi:10.1214/08-STS257>.

- Jones & al. (2006): *Fixed-width output analysis for Markov chain
  Monte Carlo*, <doi:10.1198/016214506000000492>.

- Gilks & al. (1998): *Markov Chain Monte Carlo in Practice*, Chapman &
  Hall/CRC <doi:10.1201/b14835>.

- D. J. C. MacKay (2005): *Information Theory, Inference, and Learning
  Algorithms*, Cambridge University Press
  <https://www.inference.org.uk/itila/book.html>.

- Porta Mana
  <https://github.com/pglpm/prova/raw/main/development/manual/pglpm2024-bayes_nonparam.pdf>.

## See also

[`metadatatemplate()`](https://pglpm.github.io/prova/reference/metadata.md)
to help writing metadata files.

[`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md) to set a
"K" (more precisely "prova_K") object generated by `learn()` as default
in all subsequent `K = ` arguments.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
probabilities, and
[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md) to calculate
quantiles, given the data processed by `learn()`.

[`rPr()`](https://pglpm.github.io/prova/reference/rPr.md) to generate
datapoints similar to the data processed by `learn()`.

[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
to calculate mutual information given the data processed by `learn()`.

[`pread.csv()`](https://pglpm.github.io/prova/reference/data.md) and
[`pwrite.csv()`](https://pglpm.github.io/prova/reference/data.md) to
read and write CSV files in the format used by `learn()`.

## Examples

``` r
# \donttest{
### WARNING: running the following example might take a minute or more.

## Create dataset with 3 points of variate 'V' for demonstration:
dataset <- data.frame(V = rnorm(n = 3))

## Create metadata file:
metadata <- data.frame(name = 'V', type = 'continuous')

## Learn from the data:
K <- learn(
  data = dataset, metadata = metadata,
     ## the following parameters are unrealistic
     ## only used to reduce computation time for this example
  nsamples = 10, nchains = 1,
  startupMCiterations = 10, maxMCiterations = 10,
  minESS = 0, initES = 0
)
#> 
#> Saving output in directory
#> /tmp/RtmpDZJ9KR/prova-V1_D3_S10_261122T203239_19ca764ebe1f
#> Prova v3.0.2.
#> Registered socket cluster with 1 nodes on host ‘localhost’.
#> Learning from 3 datapoints, 1 variates.
#> Starting Monte Carlo sampling of 10 samples by 1 chains
#> in a space of 191 (effectively 259) dimensions.
#> Using 1 nodes: 10 samples per chain, max 1 chains per node.
#> Requested:     ESS 0   rel.MCSE Inf.
#> With burn-in:  ESS 0   rel.MCSE Inf.
#> Node logs are being saved in individual files.
#> 
#> Finished Monte Carlo sampling.
#> Highest number of Monte Carlo iterations across chains: 10.
#> Highest number of used mixture components: 3.
#> 
#> Diagnostics with 3 test data:
#> #1 #2 #3
#> max abs. quantile error: 0.2605 -- 0.8855
#> quantile width: 0.7744 -- 2.851
#> max rel. quantile error: 0.1188 -- 0.3364
#> min ESS from rel. qt. error: 8.839 -- 70.8
#> MCSE: 0.1018 -- 0.5315
#> rel. MCSE: 0.4203 -- 0.5957
#> ESS: 2.818 -- 5.66
#> max needed thinning: 3.194 -- 3.194
#> log-averages: -2.623 -- -1.21
#> Plotting final Monte Carlo traces and marginal samples...
#> Total computation time: 38 secs
#> Average preparation & finalization time: 36 secs.
#> Average Monte Carlo time per chain: 0.71 secs.
#> Max total memory used: approx 340MB.
#> Max memory used per node: approx 340MB.
#> Removing temporary output files.
#> Finished.
#> 
#> **********************************************************
#> Output saved in directory
#> /tmp/RtmpDZJ9KR/prova-V1_D3_S10_261122T203239_19ca764ebe1f
#> **********************************************************

## Check the structure of the produced `K` object:
str(K)
#> List of 6
#>  $ Rmean      : num [1, 1:64, 1:9] -2.32 -3.69 2.92 2.92 -1.05 ...
#>  $ Rsd        : num [1, 1:64, 1:9] 0.249 2.446 0.629 1.453 0.298 ...
#>  $ W          : num [1:64, 1:9] 2.40e-13 2.53e-10 3.81e-28 7.68e-263 1.60e-28 ...
#>  $ MCindex    : num [1:9(1d)] 1 2 3 4 6 7 8 9 10
#>  $ auxmetadata:'data.frame': 1 obs. of  24 variables:
#>   ..$ name             : chr "V"
#>   ..$ type             : chr "continuous"
#>   ..$ mcmctype         : chr "R"
#>   ..$ id               : int 1
#>   ..$ transform        : chr "identity"
#>   ..$ Nvalues          : int NA
#>   ..$ indexpos         : int NA
#>   ..$ halfstep         : num 0
#>   ..$ domainmin        : num -Inf
#>   ..$ domainmax        : num Inf
#>   ..$ minincluded      : logi FALSE
#>   ..$ maxincluded      : logi FALSE
#>   ..$ tdomainmin       : num -Inf
#>   ..$ tdomainmax       : num Inf
#>   ..$ domainminplushs  : num -Inf
#>   ..$ domainmaxminushs : num Inf
#>   ..$ tdomainminplushs : num -Inf
#>   ..$ tdomainmaxminushs: num Inf
#>   ..$ tlocation        : num -0.476
#>   ..$ tscale           : num 0.574
#>   ..$ plotmin          : num -2.76
#>   ..$ plotmax          : num 2.14
#>   ..$ V1               : logi NA
#>   ..$ V2               : logi NA
#>  $ info       :List of 11
#>   ..$ metadata         :'data.frame':    1 obs. of  2 variables:
#>   .. ..$ name: chr "V"
#>   .. ..$ type: chr "continuous"
#>   ..$ nMCsamples       : int 9
#>   ..$ nchains          : num 1
#>   ..$ npoints          : int 3
#>   ..$ maxiterations    : num 10
#>   ..$ maxusedcomponents: num 3
#>   ..$ nonfinitechains  : num 0
#>   ..$ stoppedchains    : num 0
#>   ..$ .Random.seed     : int [1:626] 10403 481 1901576442 305780618 1771555321 140805362 -1701321808 1010115073 1617144363 1953263465 ...
#>   ..$ args             :List of 24
#>   .. ..$ nsamples           : num 10
#>   .. ..$ nchains            : num 1
#>   .. ..$ nsamplesperchain   : num 450
#>   .. ..$ parallel           : logi TRUE
#>   .. ..$ seed               : NULL
#>   .. ..$ cleanup            : logi TRUE
#>   .. ..$ appendinfo         : logi TRUE
#>   .. ..$ valueisK           : logi TRUE
#>   .. ..$ subsampledata      : NULL
#>   .. ..$ prior              : logi FALSE
#>   .. ..$ startupMCiterations: num 10
#>   .. ..$ minMCiterations    : num 0
#>   .. ..$ maxMCiterations    : num 10
#>   .. ..$ maxhours           : num Inf
#>   .. ..$ ncheckpoints       : NULL
#>   .. ..$ maxrelMCSE         : num 0.0471
#>   .. ..$ minESS             : num 0
#>   .. ..$ initES             : num 0
#>   .. ..$ thinning           : NULL
#>   .. ..$ verbose            : logi TRUE
#>   .. ..$ plottraces         : logi FALSE
#>   .. ..$ showKtraces        : logi FALSE
#>   .. ..$ showAlphatraces    : logi FALSE
#>   .. ..$ hyperparams        :List of 22
#>   .. .. ..$ ncomponents : num 64
#>   .. .. ..$ minalpha    : num -4
#>   .. .. ..$ maxalpha    : num 4
#>   .. .. ..$ byalpha     : num 1
#>   .. .. ..$ Rshapelo    : num 0.5
#>   .. .. ..$ Rshapehi    : num 0.5
#>   .. .. ..$ Rvarm1      : num 9
#>   .. .. ..$ Cshapelo    : num 0.5
#>   .. .. ..$ Cshapehi    : num 0.5
#>   .. .. ..$ Cvarm1      : num 9
#>   .. .. ..$ Dshapelo    : num 0.5
#>   .. .. ..$ Dshapehi    : num 0.5
#>   .. .. ..$ Dvarm1      : num 9
#>   .. .. ..$ Bshapelo    : num 1
#>   .. .. ..$ Bshapehi    : num 1
#>   .. .. ..$ Dthreshold  : num 1
#>   .. .. ..$ tscalefactor: num 4.27
#>   .. .. ..$ Oprior      : chr "Hadamard"
#>   .. .. ..$ Nprior      : chr "Hadamard"
#>   .. .. ..$ avoidzeroW  : NULL
#>   .. .. ..$ initmethod  : chr "datacentre"
#>   .. .. ..$ Qerror      : num [1:2] 0.159 0.841
#>   ..$ diagn            :List of 9
#>   .. ..$ max abs. quantile error    : num [1:3] 0.26 0.886 0.281
#>   .. ..$ quantile width             : num [1:3] 0.774 2.851 2.366
#>   .. ..$ max rel. quantile error    : num [1:3] 0.336 0.311 0.119
#>   .. ..$ min ESS from rel. qt. error: num [1:3] 8.84 10.37 70.8
#>   .. ..$ MCSE                       : Named num [1:3] 0.102 0.531 0.413
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#2" "#1"
#>   .. ..$ rel. MCSE                  : Named num [1:3] 0.42 0.596 0.558
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#2" "#1"
#>   .. ..$ ESS                        : Named num [1:3] 5.66 2.82 3.21
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#2" "#1"
#>   .. ..$ max needed thinning        : num 3.19
#>   .. ..$ log-averages               : Named num [1:3] -2.26 -1.21 -2.62
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#2" "#1"
#>  - attr(*, "class")= chr "prova_K"
# }
```
