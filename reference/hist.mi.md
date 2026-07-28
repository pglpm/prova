# Plot the revisability of an object of class "mi" as a histogram

The mutual information calculated with the
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
function, and outputted as a "mi" object, has an associated
"revisability" that comes from the finite size of the data sample. A
much larger sample might reveal a different value of mutual information.

The [`hist()`](https://rdrr.io/r/graphics/hist.html) method for a "mi"
object is a utility to visualize this kind of revisability, in the form
of a distribution: it shows how the mutual information could change, if
we collected a much larger (infinite) data sample, and how likely would
such change be.

## Usage

``` r
# S3 method for class 'mi'
hist(
  x,
  breaks = NULL,
  lty = c(1, 2, 4, 3, 6, 5),
  lwd = 2,
  col = palette(),
  alpha.f = 1,
  fill.alpha.f = 0.125,
  showvalue = TRUE,
  xlab = NULL,
  ylab = NULL,
  xlim = NULL,
  ylim = c(0, NA),
  main = NULL,
  grid = TRUE,
  axes = FALSE,
  add = FALSE,
  ...
)
```

## Arguments

- x:

  Object of class "mi", obtained with
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

- breaks:

  `NULL` or as in function
  [`graphics::hist()`](https://rdrr.io/r/graphics/hist.html). If `NULL`
  (default), an optimal number of breaks for each probability
  distribution is computed.

- lty, lwd, col, alpha.f, xlab, ylab, xlim, ylim, main, grid, axes, add:

  see analogous arguments in
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html)

- fill.alpha.f:

  Numeric, default 0.125: opacity of the histogram filling. `0` means no
  filling.

- showvalue:

  Logical, default `TRUE`: show the mutual information obtained from the
  current data sample?

- ...:

  Other parameters to be passed to
  [`pplot()`](https://pglpm.github.io/prova/reference/pplot.md).

## Value

[Invisibly](https://rdrr.io/r/base/invisible.html), an object of class
["histogram"](https://rdrr.io/r/graphics/hist.html).

## See also

[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
to calculate mutual information and its revisability.

[`print.mi()`](https://pglpm.github.io/prova/reference/print.mi.md) \]
to plot mutual information and quantiles calculated by
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)

[`pplot()`](https://pglpm.github.io/prova/reference/pplot.md) (on which
`hist.mi()` is based) for more general plots.

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
K <- Kexample

## calculate the mutual information and its revisability
MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
  K = K, nv = 2, parallel = 1)

## show the possible revisability of the mutual information,
## if a much larger data sample were collected
hist(MI)

```
