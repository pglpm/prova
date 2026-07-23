# Plot an object of class "probability"

This [`base::plot()`](https://rdrr.io/r/base/plot.html) method is a
utility to plot probabilities obtained with
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), as well as
their revisabilities. The probabilities are plotted either against `Y`,
with one curve for each value of `X`, or vice versa.

## Usage

``` r
# S3 method for class 'probability'
plot(
  x,
  spread = NULL,
  subset = NULL,
  PvsY = NULL,
  legend = "top",
  lty = c(1, 2, 4, 3, 6, 5),
  pch = c(1, 2, 0, 5, 6, 3),
  lwd = 2,
  col = palette(),
  type = NULL,
  alpha.f = 1,
  var.alpha.f = NULL,
  var.nsamples = 360,
  xlab = NULL,
  ylab = NULL,
  ylab2 = NULL,
  main = NULL,
  ylim = c(0, NA),
  grid = TRUE,
  add = FALSE,
  ...
)
```

## Arguments

- x:

  Object of class "probability", obtained with
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- spread:

  One of the values `'quantiles'`, `'samples'`, `'none'` (equivalent to
  `NA` or `FALSE`), or `NULL` (default), in which case the revisability
  available in `p` is used. This argument chooses how to represent the
  revisability of the probability; see
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md). If the
  requested representation is not available in the object `x`, then a
  warning is issued and no revisability is plotted.

- subset:

  Named list or named vector: which variate values to display. For the
  variates corresponding to the names in this list, only the vector of
  values corresponding to that variate is displayed.

- PvsY:

  Logical or `NULL`: should probabilities be plotted against their `Y`
  argument? If `NULL`, the argument between `Y` and `X` having larger
  number of values is chosen. As many probability curves will be plotted
  as the number of values of the other argument.

- legend:

  One of the values `'bottomright'`, `'bottom'`, `'bottomleft'`,
  `'left'`, `'topleft'`, `'top'`, `'topright'`, `'right'`, `'center'`
  (see [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html)):
  plot a legend at that position. A value `FALSE` or any other does not
  plot any legend. Default `'top'`.

- lty, lwd, pch, col, type, xlab, ylab, main, ylim, grid, add:

  see analogous arguments in
  [`graphics::plot.default()`](https://rdrr.io/r/graphics/plot.default.html)
  and [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

- alpha.f:

  Numeric, default 0.25: opacity of the colours, `0` being completely
  invisible and `1` completely opaque.

- var.alpha.f:

  Numeric: opacity of the quantile bands or of the samples, `0` being
  completely invisible and `1` completely opaque.

- var.nsamples:

  Integer, default 360: number of samples of long-run frequencies to
  display

- ylab2:

  A title for the y-axis on the right side of the plot, if displayed.

- ...:

  Other parameters to be passed to
  [`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md).

## Value

`NULL`, [invisibly](https://rdrr.io/r/base/invisible.html); produces a
plot, see
[`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

## See also

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
posterior probabilities and quantiles.

[`hist.probability()`](https://pglpm.github.io/prova/reference/hist.probability.md)
to plot the revisability of the probabilities as a distribution.

[`flexiplot()`](https://pglpm.github.io/prova/reference/flexiplot.md)
(on which `plot.probability()` is based) for more general plots.

[`plotquantiles()`](https://pglpm.github.io/prova/reference/plotquantiles.md)
to plot quantile ranges.

## Examples

``` r
## Load the example `learnt` object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
learnt <- learntExample

## create a grid of values for variate "bill length",
## based on the information in the dataset and metadata:
values <- vrtgrid(vrt = 'bill_len', learnt = learnt)

## calculate the probabilities and quantiles
probs <- Pr(Y = data.frame(bill_len = values), learnt = learnt, parallel = 1)

## plot the probabilities and quantiles
plot(probs)

```
