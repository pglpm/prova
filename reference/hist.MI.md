# Plot the revisability of an object of class "MI" as a histogram

The mutual information calculated with the
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
function, and outputted as a "MI" object, has an associated
"revisability" that comes from the finite size of the data sample. A
much larger sample might reveal a different value of mutual information.

The [`hist()`](https://rdrr.io/r/graphics/hist.html) method for a "MI"
object is a utility to visualize this kind of revisability, in the form
of a distribution: it shows how the mutual information could change, if
we collected a much larger (infinite) data sample, and how likely would
such change be.

## Usage

``` r
# S3 method for class 'MI'
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
  add = FALSE,
  ...
)
```

## Arguments

- x:

  Object of class "MI", obtained with
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

- breaks:

  `NULL` or as in function
  [`graphics::hist()`](https://rdrr.io/r/graphics/hist.html). If `NULL`
  (default), an optimal number of breaks for each probability
  distribution is computed.

- lty, lwd, col, alpha.f, xlab, ylab, xlim, ylim, main, grid, add:

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
  [`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md).

## Value

[Invisibly](https://rdrr.io/r/base/invisible.html), an object of class
["histogram"](https://rdrr.io/r/graphics/hist.html).

## See also

[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
to calculate mutual information and its revisability.

[`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md)
(on which `hist.MI()` is based) for more general plots.

## Examples

``` r
## Load the example `learnt` object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
learnt <- learntExample

## calculate the mutual information and its revisability
MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
  learnt = learnt, nv = 2, parallel = 1)

## show the possible revisability of the mutual information,
## if a much larger data sample were collected
hist(MI)

```
