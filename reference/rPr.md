# Generate datapoints

Generates datapoints of chosen joint variates, according to posterior
probabilities and posterior conditional probabilities.

## Usage

``` r
rPr(n, Ynames, X = NULL, K, tails = NULL, mcsamples = NULL, parallel = NULL)
```

## Arguments

- n:

  Positive integer: number of samples to draw.

- Ynames:

  Character vector: names of variates to draw jointly

- X:

  List or data.table or `NULL`: set of values of variates on which we
  want to condition the joint probability for `Y`. If `NULL` (default),
  no conditioning is made. Any rows beyond the first are discarded

- K:

  A "Knowledge" object produced by
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md). It can
  also be a path to a 'K.rds' file containing such object, or to a
  directory containing one.

- tails:

  Named vector or list, or `NULL` (default). The names must match some
  or all of the variates in arguments `X`. For variates in this list,
  the probability conditional is understood in a semi-open interval
  sense: \\X \le x\\ or \\X \ge x\\, an so on. See analogous argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- mcsamples:

  Vector of integers, or `'all'`, or `NULL` (default): which Monte Carlo
  samples calculated by the
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md) function
  should be used to draw the variate values. The default is to choose a
  random subset if `n` is smaller than their number, otherwise to
  recycle them as necessary.

- parallel:

  Not used: this function does not use parallelization.

## Value

A [data frame](https://rdrr.io/r/base/data.frame.html) of joint draws of
the variates `Ynames` from the posterior distribution, conditional on
`X`. The row names of the data frame report the Monte Carlo sample (from
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)) used for
that draw, and the total number of draws from that sample so far.

## Details

This function generates datapoints according to the posterior
probability \\\mathrm{Pr}(Y = y \vert X = x, K)\\ or \\\mathrm{Pr}(Y = y
\vert X \le x, K)\\ or combinations thereof, for the variates specified
in the argument `Y`, and conditional on the variate values specified in
the argument `X`. It is somewhat analogous to the `rxxx`-variants of [R
distribution functions](https://rdrr.io/r/stats/Distributions.html). If
`X` is omitted or `NULL`, then the posterior probability \\\mathrm{Pr}(Y
\| K)\\ is used. Each variate in the argument `X` can be specified
either as a point-value \\X = x\\ or as a left-open interval \\X \le x\\
or as a right-open interval \\X \ge x\\, through the argument `tails`.

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates the `K` objects required by
[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md).

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
joint and conditional probabilities.

[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md) to calculate
quantiles.

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
K <- Kexample

## ## Example 1:
## Generate 10 values of the 'species' variate,
## according to the frequency distribution estimated from the data

datapoints <- rPr(
  n = 10,
  Ynames = 'species',
  K = K
)

c(datapoints)
#> $species
#>  [1] "Adelie"    "Adelie"    "Gentoo"    "Gentoo"    "Adelie"    "Adelie"   
#>  [7] "Adelie"    "Chinstrap" "Gentoo"    "Adelie"   
#> 


## ## Example 2:
## Generate 5 joint values of the 'species' and 'bill_len' variates.

datapoints <- rPr(
  n = 5,
  Ynames = c('species', 'bill_len'),
  K = K
)

print(datapoints, row.names = FALSE) ## row names give MCMC information
#>    species bill_len
#>  Chinstrap     50.1
#>     Adelie     34.0
#>  Chinstrap     48.3
#>     Adelie     37.6
#>     Gentoo     44.5


## ## Example 3:
## Generate 5 values of the 'species' variate,
## for the subpopulation of penguins having bill length shorter than 40 mm

datapoints <- rPr(
  n = 5,
  Ynames = 'species',
  X = data.frame(bill_len = 40),
  tails = list(bill_len = 'lower'),
  K = K
)

c(datapoints)
#> $species
#> [1] "Adelie" "Adelie" "Adelie" "Adelie" "Adelie"
#> 
```
