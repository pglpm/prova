# Calculate quantiles

Calculate the quantiles of posterior probabilities and posterior
conditional probabilities. Output the revisability of such quantiles if
more training data were available.

## Usage

``` r
qPr(
  p,
  Yname,
  X = NULL,
  K = NULL,
  tails = NULL,
  nsamples = "all",
  quantiles = c(0.055, 0.5, 0.945),
  parallel = TRUE,
  sep = ",",
  solidus = "|",
  verbose = FALSE,
  keepYX = TRUE,
  tol = .Machine$double.eps * 10
)
```

## Arguments

- p:

  Numeric vector of probability levels.

- Yname:

  Character vector: name of variate whose quantiles will be computed.

- X:

  Matrix or data.table or `NULL` (default): set of values of variates on
  which we want to condition. If `NULL`, no conditioning is made (except
  for conditioning on the learning dataset and prior assumptions). One
  variate per column, one set of values per row. See "Details" for the
  interpretation of unnamed arguments.

- K:

  A "prova_K" (knowledge) object produced by
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md). It can
  also be a path to a 'K.rds' file containing such object, or to a
  directory containing one. See "Details" for the interpretation of
  unnamed arguments.

- tails:

  Named vector or list, or `NULL` (default). The names must match some
  or all of the variates in arguments `X`. For variates in this list,
  the probability conditional is understood in a semi-open interval
  sense: \\X \le x\\ or \\X \ge x\\, an so on. See analogous argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- nsamples:

  Integer or `NULL` or `'all'` (default): desired number of samples of
  the revisability of the quantile for `Y`. If `NULL`, no samples are
  reported. If `'all'` (or `Inf`), all samples obtained by the
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md) function
  are used.

- quantiles:

  Numeric vector, between 0 and 1, or `NULL`: desired quantiles of the
  revisability of the quantile for `Y`. Default
  `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5%
  quantiles (these are typical quantile values in the Bayesian
  literature: they give 50% and 89% credibility intervals, which
  correspond to 1 shannons and 0.5 shannons of uncertainty). If `NULL`,
  no quantiles are calculated.

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

- sep:

  character, default `','`: character to separate the output's variate
  names and values.

- solidus:

  character, default `'|'`: character prepended to the output's names of
  the variates in the conditional (typically the `X` variates).

- verbose:

  Logical, default `FALSE`: give messages about parallel processing?

- keepYX:

  Logical, default `TRUE`: keep a copy of the `Yname` and `X` arguments
  in the output? This is used for
  [`plot.prova_pr()`](https://pglpm.github.io/prova/reference/plot.prova_pr.md).

- tol:

  numeric positive: tolerance in the calculation of quantiles. Default:
  `.Machine$double.eps * 10` (typically `2.22045e-15`).

## Value

A list of the following elements:

- `'value'`: a matrix with the requested \\Y\\-quantiles `p` conditional
  on the requested \\X\\-values in `X`, for all combinations of `p`
  (rows) and `X` (columns).

- `'quantiles'` (possibly `NULL`): an array with the revisability
  quantiles (3rd dimension of the array) for the quantiles of the
  `'value'` element.

- `'samples'` (possibly `NULL`): an array with the revisability samples
  (3rd dimension of the array) for such quantiles.

- `'Y'`, `'X'` `'tails'`: copies of the `Y`, `X`, `tails` arguments.

- `'K'`: name of the "prova_K" (knowledge) object used in the
  calculation.

## Details

This function calculates the quantiles of \\\mathrm{Pr}(Y = y \vert X =
x, K)\\ or of \\\mathrm{Pr}(Y = y \vert X \le x, K)\\ or combinations
thereof, at specified cumulative-probability levels. In other words, it
calculates the values of \\Y\\ having specified cumulative probabilities
or conditional probabilities. It also calculates the revisability of
those quantiles if more learning data were provided. It is somewhat
analogous to the `qxxx`-variants of [R distribution
functions](https://rdrr.io/r/stats/Distributions.html). The revisability
can be expressed in the form of quantiles, samples, or both, as in the
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) function. If
several joint values are given for the probability levels and for `X`,
the function creates a 2D grid of results for all possible combinations
of the given probability levels and `X` values. Each variate in the
argument `X` can be specified either as a point-value \\X = x\\ or as a
left-open interval \\X \le x\\ or as a right-open interval \\X \ge x\\,
through the argument `tails`.

If `qPr()` is called with three unnamed arguments, `qPr(..., ..., ...)`,
then it is interpreted as `qPr(p = ..., Yname = ..., K = ...)`.

## References

- Porta Mana (2025): *What's special about 89% credibility intervals?*
  <doi:10.5281/zenodo.17072199>.

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates the "prova_K" (knowledge) objects required by `qPr()`.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
joint and conditional probabilities.

[`rPr()`](https://pglpm.github.io/prova/reference/rPr.md) to generate
datapoints.

## Examples

``` r
### WARNING: the following examples, if run, might even take a minute or more.

# \donttest{
## Use the example "prova_K" (knowledge) object 'Kexample'
## calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'

## ## Example 1:
## Calculate the 25%-, 50%-, and 75%-quantiles for the variate "bill length",
## that is, the values of "bill length" having such cumulative probabilities:

quants <- qPr(c(0.25, 0.5, 0.75), 'bill_len', Kexample)

## display the quantile values
quants$value
#>         
#> bill_len [,1]
#>     0.25 39.2
#>     0.5  44.3
#>     0.75 48.3

## verify these values, within numerical error, using Pr():
probs <- Pr(data.frame(bill_len = c(quants$value)), Kexample,
  tails = list(bill_len = -1))
probs$value
#>          
#> bill_len<      [,1]
#>      39.2 0.2528194
#>      44.3 0.5026998
#>      48.3 0.7501943

## display the revisability about the quantiles
quants$quantiles
#> , , Q = 5.5%
#> 
#>         
#> bill_len [,1]
#>     0.25 38.7
#>     0.5  43.3
#>     0.75 47.8
#> 
#> , , Q = 50%
#> 
#>         
#> bill_len [,1]
#>     0.25 39.2
#>     0.5  44.3
#>     0.75 48.3
#> 
#> , , Q = 94.5%
#> 
#>         
#> bill_len [,1]
#>     0.25 39.7
#>     0.5  45.1
#>     0.75 48.9
#> 


## ## Example 2:
## Calculate the 25%-, 50%-, and 75%-quantiles for the variate "bill length",
## for the subpopulation of species 'Adelie':
quants <- qPr(c(0.25, 0.5, 0.75), 'bill_len', data.frame(species = 'Adelie'),
  Kexample)

## display the quantile values
quants$value
#>         |species
#> bill_len Adelie
#>     0.25   37.0
#>     0.5    38.8
#>     0.75   40.6

## verify these values, within numerical error, using Pr():
probs <- Pr(data.frame(bill_len = c(quants$value)),
  data.frame(species = 'Adelie'), Kexample, tails = list(bill_len = -1))
probs$value
#>          |species
#> bill_len<    Adelie
#>      37   0.2530943
#>      38.8 0.5050883
#>      40.6 0.7515390
# }
```
