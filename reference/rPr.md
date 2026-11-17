# Generate datapoints

Generates datapoints of chosen joint variates, according to posterior
probabilities and posterior conditional probabilities.

## Usage

``` r
rPr(
  n,
  Ynames,
  X = NA,
  K = NULL,
  tails = NULL,
  mcsamples = NULL,
  mcrownames = !is.null(mcsamples)
)
```

## Arguments

- n:

  Positive integer: number of samples to draw.

- Ynames:

  Character vector: names of variates to draw jointly

- X:

  Matrix or data.table, or `NULL` or `NA` (default): set of values of
  variates in the conditional of the probability of `Y`. If `NA` or
  `NULL`, no conditioning is made (besides the conditioning on knowledge
  `K`). One variate per column, one set of values per row. See "Details"
  for the interpretation of unnamed arguments.

- K:

  One of these alternatives:

  - A "K" (more precisely "prova_K") object.

  - A character string of the path to an
    [RDS](https://rdrr.io/r/base/readRDS.html) file (typically created
    by [`learn()`](https://pglpm.github.io/prova/reference/learn.md))
    containing a valid "K" object.

  - A character string of the path to a directory (also typically
    created by
    [`learn()`](https://pglpm.github.io/prova/reference/learn.md))
    containing such an [RDS](https://rdrr.io/r/base/readRDS.html) file
    of a "K" object.

  - For function
    [`getK()`](https://pglpm.github.io/prova/reference/Kobjects.md) it
    can also be `NULL` or omitted, if a default `K = ` argument has been
    defined with
    [`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md).

  Alternatively, a default `K = ` argument can be set with
  [`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md), in
  which case the `K = ` argument may be omitted. See "Details" for the
  interpretation of unnamed arguments.

- tails:

  Named vector or list, or `NULL` (default). The names must match some
  or all of the variates in arguments `X`. For variates in this list,
  the probability conditional is understood in a semi-open interval
  sense: \\X \le x\\ or \\X \ge x\\, an so on. See analogous argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- mcsamples:

  Either `NULL` (default, equivalently `'all'` or `TRUE`), or a vector
  of integers: which Monte Carlo samples calculated by the
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md) function
  should be used to draw the variate values. The default `NULL` chooses
  a random subset if `n` is smaller than their number, otherwise to
  recycle them as necessary.

- mcrownames:

  Logical: whether the row names of the created data frame should report
  underlying information about the Monte Carlo samples used to generate
  the datapoints; see **Value** section. Default is `FALSE` if argument
  `mcsamples` is `NULL`, and `TRUE` otherwise.

## Value

A [data frame](https://rdrr.io/r/base/data.frame.html) of joint draws of
the variates `Ynames` from the posterior distribution, conditional on
what is specified in the `X` (and `tails`) argument.

With argument `mcrownames = TRUE` or argument `mcsamples = ` not `NULL`,
the row names of the data frame report the Monte Carlo sample (from
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)) from
which that datapoint was drawn from, and the grand-total of datapoints
drawn from that Monte Carlo sample, according to the scheme
"`sample_total`".

## Details

This function generates datapoints according to the posterior
probability \\\mathrm{Pr}(Y = y \vert X = x, K)\\ or \\\mathrm{Pr}(Y = y
\vert X \le x, K)\\ or combinations thereof, for the variates specified
in the argument `Y`, and conditional on the variate values specified in
the argument `X`. It is somewhat analogous to the `rxxx`-variants of [R
distribution functions](https://rdrr.io/r/stats/Distributions.html). If
`X` is `NA`, then the posterior probability \\\mathrm{Pr}(Y \| K)\\ is
used.

Each variate in the argument `X` can be specified either as a
point-value \\X = x\\ or as a left-open interval \\X \le x\\ or as a
right-open interval \\X \ge x\\, through the argument `tails` (see *Tail
probabilities* in the
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) documentation).

A default value for the `K = ` argument can be set (and unset) with
[`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md). When
this is done, the `K = ` argument may be omitted, saving a lot of
`K = ...`-typing in this and other functions.

Therefore if `rPr()` is called with two unnamed arguments,
`rPr(..., ...)`, then it is interpreted as `rPr(n = ..., Ynames = ...)`,
with `X = NA` and the default `K = ` argument set by
[`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md). If it
is called with three unnamed arguments, then it is interpreted as
`rPr(n = ..., Ynames = ..., X = ...)`, with the default `K = ` argument
set by [`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md).
In order to specify `n`, `Ynames`, and `K` without naming the arguments,
the form `rPr(..., ..., NA, ...)` must be used, explicitly giving `X` as
third argument.

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), to
generate "K" objects required by
[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md).

[`useK()`](https://pglpm.github.io/prova/reference/Kobjects.md) to set a
"K" object as default in all `K = ` arguments.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
joint and conditional probabilities.

[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md) to calculate
quantiles.

[Kexample](https://pglpm.github.io/prova/reference/Kexample.md) an
example "K" object included with **Prova**.

[`base::set.seed()`](https://rdrr.io/r/base/Random.html) to generate
samples reproducibly.

## Examples

``` r

## Use the "K" object 'Kexample' included in *Prova*,
## calculated from the "penguins" dataset.
## Variates: 'species' and 'bill_len'

## ## Example 1:
## Generate 10 values of the 'species' variate,
## with the same probability calculated from the data
datapoints <- rPr(n = 10, Ynames = 'species', K = Kexample)
## alternatively: rPr(10, 'species', NA, Kexample)
datapoints
#>         species
#> 3_1      Adelie
#> 37_1     Adelie
#> 67_1     Adelie
#> 69_1     Adelie
#> 88_1     Adelie
#> 176_1 Chinstrap
#> 182_1    Gentoo
#> 191_1 Chinstrap
#> 199_1    Gentoo
#> 218_1    Gentoo


## ## Example 2:
## Generate 5 joint values of 'species' and 'bill_len' variates.
datapoints <- rPr(5, c('species', 'bill_len'), NA, Kexample)
datapoints
#>         species bill_len
#> 49_1  Chinstrap     50.2
#> 61_1     Adelie     38.4
#> 69_1  Chinstrap     51.1
#> 109_1    Adelie     44.4
#> 201_1    Gentoo     52.3


## ## Example 3:
## Generate 5 values of the 'species' variate,
## among penguins having bill length shorter than or equal to 40 mm

datapoints <- rPr(5, 'species', data.frame(bill_len = 40), Kexample, tails = list(bill_len = '<='))
datapoints
#>       species
#> 70_1   Adelie
#> 191_1  Adelie
#> 193_1  Adelie
#> 201_1  Adelie
#> 216_1  Adelie


## ## Example 4:
## To omit 'K =' arguments, set a default one with useK()
useK(Kexample)

## Generate 10 values of the 'species' variate.
## The datapoints are different from before,
## since we did not set a random seed with 'set.seed()'
datapoints <- rPr(10, 'species')
datapoints
#>         species
#> 17_1     Gentoo
#> 23_1     Adelie
#> 38_1     Adelie
#> 50_1     Gentoo
#> 58_1     Adelie
#> 69_1  Chinstrap
#> 97_1     Gentoo
#> 143_1 Chinstrap
#> 155_1    Gentoo
#> 185_1    Adelie

## Remove any default 'K =' argument
useK(NA)
```
