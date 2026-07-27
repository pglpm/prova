# Calculate mutual information between groups of joint variates

Calculate the mutual information between two grops of joint variates, as
well as its revisability.

## Usage

``` r
mutualinfo(
  Y1names,
  Y2names,
  X = NULL,
  learnt,
  tails = NULL,
  quantiles = c(0.055, 0.25, 0.75, 0.945),
  ns = NULL,
  nv = 12,
  unit = "Sh",
  parallel = TRUE,
  verbose = FALSE
)
```

## Arguments

- Y1names:

  Character vector: first group of joint variates

- Y2names:

  Character vector or `NULL`: second group of joint variates

- X:

  Matrix or data.frame or `NULL`: values of some variates conditional on
  which we want the probabilities.

- learnt:

  Either a character with the name of a directory or full path for an
  'learnt.rds' object, or such an object itself.

- tails:

  Named vector or list, or `NULL` (default). The names must match some
  or all of the variates in arguments `X`. For variates in this list,
  the probability conditional is understood in a semi-open interval
  sense: \\X \le x\\ or \\X \ge x\\, an so on. See analogous argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- quantiles:

  Numeric vector, between 0 and 1: desired quantiles of the revisability
  of the mutual information. Default `c(0.055, 0.25, 0.75, 0.945)`, that
  is, the 5.5%, 25%, 75%, 94.5% quantiles. See similar argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- ns:

  Integer or `Inf` or `NULL` (default): number of Monte Carlo samples in
  the "learnt" object to use for calculating the mutual information. If
  `Inf` or `NULL`, use all Monte Carlo samples available in the "learnt"
  object.

- nv:

  Integer, default 12: number of *duplicates* of Monte Carlo samples in
  the "learnt" object to use for calculating the revisability of the
  mutual information.

- unit:

  Either one of 'Sh' for *shannon* (default), 'Hart' for *hartley*,
  'nat' for *natural unit*, or a positive real indicating the base of
  the logarithms to be used.

- parallel:

  Logical or positive integer or cluster object. `TRUE` (default): use
  as many cores as in user's
  [option](https://rdrr.io/r/base/options.html) "nc.cores", or 2 if that
  is `NULL`. `FALSE`: use serial computation. Integer: use this many
  cores. It can also be a cluster object previously created with
  [`parallel::makeCluster()`](https://rdrr.io/r/parallel/makeCluster.html);
  in this case the parallel computation will use this object.

- verbose:

  Logical, default `FALSE`: give messages about parallel processing?

## Value

An object of class "mi", which is a list consisting of the following
elements:

- `$value`, the mutual information between (joint) variates `Y1names`
  and (joint) variates `Y2names`.

- `$quantiles`, a vector with the revisability quantiles for the mutual
  information.

- `$MCaccuracy`, vector with the numerical accuracies (roughly speaking
  a standard deviation) of the Monte Carlo calculation for the `value`
  of the mutual information.

- `$samples`, a vector with the revisability samples for the mutual
  information.

- `$rGauss`, a vector of `value` and `accuracy`: the absolute value of
  the Pearson correlation coefficient \\r\\ of a *multivariate Gaussian
  distribution* having mutual information `MI`; the two are related by
  \\\mathrm{MI} = -\ln(1 - r^2)/2\\. It may provide a vague intuition
  for the `MI` value for people more familiar with Pearson's
  correlation, but should be taken with a grain of salt.

- `$unit`, `$Y1names`, `$Y1names`: same as the input arguments.

## Details

If \\Y_1\\ and \\Y_2\\ are two variates, each of which can be a joint
variate such as \\Y_1 = (Y\_{1,1}, Y\_{1,2}, \dotsc)\\, and \\X\\ a
third, also possibly join, variate, then the mutual information
\\\mathit{MI}\\ between \\Y_1\\ and \\Y_2\\, conditional on \\X = x\\,
is given by \$\$\mathit{MI}(Y_1, Y_2 \vert X = x) \mathrel{:=}
\sum\_{y_1, y_2} \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x,
\text{data}) \log_2\frac{ \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x,
\text{data}) }{ \mathrm{Pr}(Y_1 = y_1 \vert X = x, \text{data}) \cdot
\mathrm{Pr}(Y_2 = y_2 \vert X = x, \text{data}) } \\ \mathrm{Sh} \$\$ an
expression which can also be written in several other equivalent ways.
It is a model-free information-theoretic measure of association, that
is, it does not depend on assumptions such as linearity, gaussianity,
and similar. See
[`vignette('mutualinfo')`](https://pglpm.github.io/prova/articles/mutualinfo.md)
for discussion and example uses, and also the "References" section. If
\\Y_1, Y_2\\ are *jointly gaussian variates*, then there is a
mathematical correspondence between their mutual information and their
Pearson correlation coefficient; see output `rGauss` in the "Value"
section.

The function `mutualinfo()` calculates the mutual information above for
the joint variates specified in the arguments `Y1names` and `Y2names`,
conditional on the values of the variates specified in the [data
frame](https://rdrr.io/r/base/data.frame.html) `X`. If `X` is omitted or
`NULL`, then the posterior probabilities \\\mathrm{Pr}(Y_1 \|
\text{data})\\ etc. are used. Each variate in the argument `X` can be
specified either as a point-value \\X = x\\ or as a left-open interval
\\X \le x\\ or as a right-open interval \\X \ge x\\, through the
argument `tails`.

The computation of these quantities is done via Monte Carlo integration,
using the samples produced by the
[`learn()`](https://pglpm.github.io/prova/reference/learn.md) function.
The present function also output the numerical error associated with
this computation. Note that the computation can take tens of minutes; it
can be sped up by using more cores (if available) in parallel, through
the argument `parallel =`.

## See also

[`print.mi()`](https://pglpm.github.io/prova/reference/print.mi.md) \]
to plot mutual information and quantiles calculated by `mutualinfo()`

[`hist.mi()`](https://pglpm.github.io/prova/reference/hist.mi.md) to
plot the revisability of the mutual information.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
probabilities and their revisability.

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates the `learnt` objects required by `mutualinfo()`.

## Examples

``` r
## Load the example `learnt` object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
learnt <- learntExample

## mutual information between variates 'species' and 'bill_len'
MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
  learnt = learnt, nv = 2, parallel = 1)

## The value and its numerical Monte Carlo error
c(MI$value, MI$MCaccuracy)
#> [1] 0.79723948 0.03379594

## If we had many more data, we could instead expect to obtain values
## within the following probable ranges:
signif(MI$quantiles, 3)
#>  5.5%   25%   75% 94.5% 
#> 0.142 0.706 1.080 1.280 
```
