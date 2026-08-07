# Plot an object of class "prova_eu" (expected utility) and its revisability

This [`base::plot()`](https://rdrr.io/r/base/plot.html) method is a
utility to plot probabilities obtained with
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), as well as
their revisabilities. The probabilities are plotted either against `Y`,
with one curve for each value of `X`, or vice versa.

## Usage

``` r
# S3 method for class 'prova_eu'
plot(
  x,
  type = "b",
  lty = c(1, 2, 4, 3, 6, 5),
  pch = c(1, 2, 0, 5, 6, 3),
  lwd = 2,
  col = palette(),
  xlab = NULL,
  ylab = NULL,
  xlim = NULL,
  ylim = NULL,
  legend = "topright",
  add = FALSE,
  alpha.f = 1,
  grid = TRUE,
  lwd.grid = NULL,
  col.grid = "#00000022",
  axes = FALSE,
  main = NULL,
  type.spread = "b",
  lty.spread = c(1, 2, 4, 3, 6, 5),
  lwd.spread = 1,
  alpha.f.spread = NULL,
  nsamples.spread = 360,
  ...
)
```

## Arguments

- x:

  Object of class "prova_pr" (probability), obtained with
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- type:

  `NULL` (default) or character vector or indicating the type of plot
  for the main probability distribution; see
  [`base::plot()`](https://rdrr.io/r/base/plot.html). The default `NULL`
  value uses type `'l'` (lines) for continuous variates, and `'b'`
  (points and lines) for discrete variates.

- lty:

  Analogous to argument `lty` (line style) in
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html), used
  for the main probability distributions.

- pch, col, xlab, ylab, main, xlim, ylim, grid, axes, add, lwd.grid,
  col.grid:

  see analogous arguments in
  [`graphics::plot.default()`](https://rdrr.io/r/graphics/plot.default.html)
  and [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

- lwd:

  Analogous to argument `lwd` (line width) in
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html), used
  for the main probability distributions.

- legend:

  One of the values `'bottomright'`, `'bottom'`, `'bottomleft'`,
  `'left'`, `'topleft'`, `'top'`, `'topright'`, `'right'`, `'center'`
  (see [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html)):
  plot a legend at that position. A value `FALSE` or any other does not
  plot any legend. Default `'top'`.

- alpha.f:

  Numeric, default `1`: opacity of the colours of lines or markers, `0`
  being completely invisible and `1` completely opaque.

- type.spread:

  `NULL` (default) or character vector or indicating the type of plot
  for the long-run-frequency samples; see. The default `NULL` value uses
  type `'l'` (lines) for continuous variates, and `'b'` (points and
  lines) for discrete variates.

- lty.spread:

  Same as parameter `lty` (line style), but for the line type of the
  long-run-frequency samples.

- lwd.spread:

  Same as parameter `lwd` (line width), but for the line type of the
  long-run-frequency samples.

- alpha.f.spread:

  Numeric or `NULL` (default): opacity of the quantile bands or of the
  long-run-frequency samples, similar to `alpha.f`. `NULL` means `0.25`
  if `spread = 'quantiles'`; and an appropriate value if
  `spread = 'samples'`,dependent on the number of samples (more samples,
  less opacity).

- nsamples.spread:

  Integer, default 360: number of samples of long-run frequencies to
  display.

- ...:

  Other parameters to be passed to
  [`pplot()`](https://pglpm.github.io/prova/reference/pplot.md).

## Value

`NULL`, [invisibly](https://rdrr.io/r/base/invisible.html); produces a
plot, see
[`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

## See also

[`exputility()`](https://pglpm.github.io/prova/reference/exputility.md)
to calculate expected utilities and their revisability.

[`print.prova_eu()`](https://pglpm.github.io/prova/reference/print.prova_eu.md)
to print a summary of expected utilities and their revisability.

[`pplot()`](https://pglpm.github.io/prova/reference/pplot.md) (on which
`plot.prova_eu()` is based) for more general plots.

## Examples

``` r
## Use the example "prova_K" (knowledge) object 'Kexample'
## calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'

## define a utility matrix with four actions,
## and outcomes depending on the variate 'species'
umatrix <- matrix(c(
 1.80, 0.42, 1.60, -0.12, -1.10, 0.20, -0.51, 0.35, -0.49, 0.35, -0.48, 0.62
 ), nrow = 4, ncol = 3, dimnames = list(actions = paste0('A', 1:4), NULL))

print(umatrix)
#>        
#> actions  [,1]  [,2]  [,3]
#>      A1  1.80 -1.10 -0.49
#>      A2  0.42  0.20  0.35
#>      A3  1.60 -0.51 -0.48
#>      A4 -0.12  0.35  0.62

## Calculate the probability of the 'species outcomes
probs <- Pr(data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
  Kexample)

## Calculate the expected utilities of the actions
eu <- exputility(umatrix, probs)

## plot the expected utilities and their revisability
plot(eu)

```
