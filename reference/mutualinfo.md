# Calculate mutual information between groups of joint variates

Calculate the mutual information between two grops of joint variates, as
well as its revisability.

## Usage

``` r
mutualinfo(
  Y1names,
  Y2names,
  X = NULL,
  K,
  tails = NULL,
  quantiles = c(0.055, 0.25, 0.75, 0.945),
  ns = NULL,
  nv = 12,
  unit = "Sh",
  parallel = TRUE,
  verbose = FALSE,
  keepX = TRUE
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

- quantiles:

  Numeric vector, between 0 and 1: desired quantiles of the revisability
  of the mutual information. Default `c(0.055, 0.25, 0.75, 0.945)`, that
  is, the 5.5%, 25%, 75%, 94.5% quantiles. See similar argument in
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- ns:

  Integer or `Inf` or `NULL` (default): number of Monte Carlo samples in
  the "K" object to use for calculating the mutual information. If `Inf`
  or `NULL`, use all Monte Carlo samples available in the "K" object.

- nv:

  Integer, default 12: number of *duplicates* of Monte Carlo samples in
  the "K" object to use for calculating the revisability of the mutual
  information.

- unit:

  Either one of 'Sh' for *shannon* (default), 'Hart' for *hartley*,
  'nat' for *natural unit*, or a positive real indicating the base of
  the logarithms to be used.

- parallel:

  One of the following values:

  - A "cluster" object previously created with
    [`parallel::makeCluster()`](https://rdrr.io/r/parallel/makeCluster.html).

  - Positive integer: create a parallel cluster with this number of
    nodes (it will be stopped at the end).

  - `FALSE`: do not use clusters (one node is still generated, in order
    to eliminate temporary objects from the computation).

  - `TRUE`: Use the cluster that was set as default with
    [`parallel::setDefaultCluster()`](https://rdrr.io/r/parallel/makeCluster.html);
    if no such object exist, then generate a cluster with as many nodes
    as in the [option](https://rdrr.io/r/base/options.html) "nc.cores";
    if this option is unset, then use 2 nodes.

- verbose:

  Logical, default `FALSE`: give messages about parallel processing?

- keepX:

  Logical, default `TRUE`: keep a copy of the `X` argument in the
  output? This is used for
  [`hist.mi()`](https://pglpm.github.io/prova/reference/hist.mi.md).

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

- `$unit`, `$Y1names`, `$Y1names`, `$tails`: copies of the homonymous
  input arguments.

- `$K`: name of the "Knowledge" object used in the calculation.

## Details

If \\Y_1\\ and \\Y_2\\ are two variates, each of which can be a joint
variate such as \\Y_1 = (Y\_{1,1}, Y\_{1,2}, \dotsc)\\, and \\X\\ a
third, also possibly join, variate, then the mutual information
\\\mathit{MI}\\ between \\Y_1\\ and \\Y_2\\, conditional on \\X = x\\
and the knowledge \\K\\ about data and metadata, is given by
\$\$\mathit{MI}(Y_1, Y_2 \vert X = x) \mathrel{:=} \sum\_{y_1, y_2}
\mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, K) \log_2\frac{
\mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, K) }{ \mathrm{Pr}(Y_1 =
y_1 \vert X = x, K) \cdot \mathrm{Pr}(Y_2 = y_2 \vert X = x, K) } \\
\mathrm{Sh} \$\$ an expression which can also be written in several
other equivalent ways. It is a model-free information-theoretic measure
of association, that is, it does not depend on assumptions such as
linearity, gaussianity, and similar. See
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
`NULL`, then the posterior probabilities \\\mathrm{Pr}(Y_1 \| K)\\ etc.
are used. Each variate in the argument `X` can be specified either as a
point-value \\X = x\\ or as a left-open interval \\X \le x\\ or as a
right-open interval \\X \ge x\\, through the argument `tails`.

The computation of these quantities is done via Monte Carlo integration,
using the samples produced by the
[`learn()`](https://pglpm.github.io/prova/reference/learn.md) function.
The present function also output the numerical error associated with
this computation. Note that the computation can take tens of minutes; it
can be sped up by using more nodes (if available) in parallel, through
the argument `parallel =`.

## See also

[`print.mi()`](https://pglpm.github.io/prova/reference/print.mi.md) \]
to plot mutual information and quantiles calculated by `mutualinfo()`

[`hist.mi()`](https://pglpm.github.io/prova/reference/hist.mi.md) to
plot the revisability of the mutual information.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
probabilities and their revisability.

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates the `K` objects required by `mutualinfo()`.

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
K <- Kexample

## mutual information between variates 'species' and 'bill_len'
MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len', K = K, nv = 2)

## The value and its numerical Monte Carlo error
c(MI$value, MI$MCaccuracy)
#> [1] 0.79723948 0.03379594

## If we had many more data, we could instead expect to obtain values
## within the following probable ranges:
signif(MI$quantiles, 3)
#>  5.5%   25%   75% 94.5% 
#> 0.142 0.706 1.080 1.280 
```
