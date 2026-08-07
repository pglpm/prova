# Plot numeric or character values

Plot function that modifies and expands the **graphics** package's
[`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html)
function in several ways.

## Usage

``` r
pplot(
  x = NULL,
  y = NULL,
  type = NA,
  lty = c(1, 2, 4, 3, 6, 5),
  lwd = 2,
  lend = par("lend"),
  pch = c(1, 2, 0, 5, 6, 3),
  col = palette(),
  xlab = NA,
  ylab = NA,
  xlim = NULL,
  ylim = NULL,
  add = FALSE,
  xdomain = NULL,
  ydomain = NULL,
  alpha.f = 1,
  xjitter = NA,
  yjitter = NA,
  fill = NA,
  alpha.f.fill = 0.25,
  grid = TRUE,
  lwd.grid = NULL,
  col.grid = "#00000022",
  axes = FALSE,
  cex.main = 1,
  ...
)
```

## Arguments

- x:

  Numeric or character or list: vectors of x-coordinates. If an element
  of `x` is missing, a numeric vector `1:...` is created having as many
  values as the rows of the corresponding element in `y`.

- y:

  Numeric or character or list: vectors of y-coordinates. If an element
  of `y` is missing, a numeric vector `1:...` is created having as many
  values as the rows of the corresponding element in `x`.

- type:

  Character vector or list indicating the type of plot for each element
  of `x` and `y`. The types of plot are the same as in
  [`base::plot()`](https://rdrr.io/r/base/plot.html), in particular
  `'p'` for points, `'l'` for lines, `'b'` for both points and lines,
  `'c'` for empty points joined by lines, `'o'` for overplotted points
  and lines, “n'`for empty plot. Additional special types`'hx'\`,
  \`'qx'\`, \`'hy'\`, \`'qy'\` are available for plotting histograms and
  quantile bands; see "Details".

- lty, lwd, pch, lend, col, xlab, ylab, add, axes, cex.main:

  see analogous arguments in
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html) and
  [`graphics::plot.default()`](https://rdrr.io/r/graphics/plot.default.html);
  defaults are different (see "Usage").

- xlim, ylim:

  `NULL` (default) or a vector of two values. If non-`NULL` and any of
  the two values is not finite (including `NA` or `NULL`), then the
  `min` or `max` `x`- or `y`-coordinates of the plotted points are used.

- xdomain, ydomain:

  Character or numeric or `NULL` (default): vector of possible values of
  the variates represented in the `x`- and `y`-axes, in case the `x` or
  `y` argument is a character vector. Note that the domains apply to all
  elements in `x` and `y`. The ordering of the values is respected. If
  `NULL`, then `unique(x)` or `unique(y)` is used.

- alpha.f:

  Numeric vector or list, default `1`: opacity of the line or contour
  colours, `0` being completely invisible and `1` completely opaque.

- xjitter, yjitter:

  Vector or list of logicals or `NA` (default): add
  [`base::jitter()`](https://rdrr.io/r/base/jitter.html) to `x`- or
  `y`-values? Useful when plotting discrete variates. If `NA`, jitter is
  added if both `x` and `y` are of character (or factor) class.

- fill:

  Logical or `NA` (default). For histogram plots (`type = 'hx'` or
  `'hy'`), value `TRUE` means fill the histogram, and do not plot its
  contour; `FAlSE` means plot only its contour without filling; `NA`
  means plot contour and fill. For quantile plots (`type = 'qx'` or
  `'qy'`), value `TRUE` do not plot the bands' contours; `FAlSE` means
  plot only the contours without filling; `NA` plots a contour only when
  the quantile band has zero area (and would be invisible otherwise).

- alpha.f.fill:

  Numeric vector or list, default `0.25`: opacity of the filling
  colours, `0` being completely invisible and `1` completely opaque.

- grid:

  Logical, default `TRUE`: plot a light grid?

- lwd.grid:

  Numeric, default 1: width of grid lines.

- col.grid:

  Color of grid lines, default `'#00000022'`. Can be specified in any of
  the usual ways, see for instance
  [`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html).

- ...:

  Other parameters to be passed to
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

## Value

`NULL`, [invisibly](https://rdrr.io/r/base/invisible.html); produces a
plot, see
[`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

## Details

This function is essentially a wrapper around
[`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html),
augmenting the latter with some features useful for plotting data and
probabilities handled by **Prova**. Some of the additional features
provided by `pplot` are the following:

- Either or both `x` and `y` arguments can be
  [list](https://rdrr.io/r/base/list.html)s. In this case, the first
  element of `x` is plotted against the first element of `y`, and so on,
  recycling as necessary. This allows for plots having different numbers
  of base points. The specifications in arguments like `type`, `lty`,
  `col`, `alpha.f`, `xjitter`, and similar apply to each list element in
  turn.

- Argument `x`, or each element in `x` if it is a list, can be of class
  [`base::character`](https://rdrr.io/r/base/character.html). In this
  case, x-axis labels as given in `xdomain` are used, or the unique
  values in `x` if `xdomain` is `NULL`. Similarly for `y` and `ydomain`.
  This feature makes it easier to plot nominal and ordinal non-numeric
  variates.

- Additional plot `type`s are available: `'hx'`, `'qx'`, `'hy'`, `'qy'`
  (internally they use
  [`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html)):

  - `'hx'` plots shaded histograms. Argument `x` must be a list of
    `breaks`, and `y` a list of `counts` or `densities`, for example
    produced by by
    [`graphics::hist()`](https://rdrr.io/r/graphics/hist.html).

  - `'qx'` plots shaded bands. The first band extends from the line
    defined by the first column of `y`, to the line defined by the
    *last* column; the second band is similarly delimited by the second
    and second-last columns of `y`, and so on (if `y` has an odd number
    of columns, the central one defines a line rather than a band). The
    x-values are the corresponding columns of `x`, recycled if
    necessary. This plot `type` is useful for plotting quantile bands
    calculated with
    [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

  - `'hy'`, `'qy'` are analogous `type`s, but with the roles of `x` and
    `y` switched.

- A jitter can be added to each plot, via the `xjitter` and `yjitter`
  vectors of switches. When either of these arguments is `NA`, it is
  internally assessed whether jitter is necessary. This feature makes it
  easier to generate scatter plots of nominal, ordinal, or
  rounded-continuous variates.

- It is possible to specify only a lower or upper limit in the `xlim`
  and `ylim` arguments, letting the other limit to be found
  automatically. This feature is useful in plotting probabilities and
  histograms, when we want to specify the lower as `0` but want the
  upper limit to be the the maximum probability.

- Transparency of lines or markers can be specified through argument
  `alpha.f`.

- Some defaults are different from
  [`base::plot()`](https://rdrr.io/r/base/plot.html) and
  [`graphics::matplot()`](https://rdrr.io/r/graphics/matplot.html).

See the package's vignettes for more examples.

## See also

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
posterior probabilities and quantiles.

[`plot.prova_pr()`](https://pglpm.github.io/prova/reference/plot.prova_pr.md)
to directly plot posterior probabilities and quantiles contained in a
probability object.

[`hist.prova_pr()`](https://pglpm.github.io/prova/reference/hist.prova_pr.md)
to plot the revisability of the probabilities as a distribution.

## Examples

``` r
## Scatter plot of 'island' vs 'species' variates of the 'penguins' dataset;
## note how jitter is automatically added:
pplot(x = penguins[, 'species'], y = penguins[, 'island'])



## Scatter plot of 'bill_len' vs 'species':
pplot(x = penguins[, 'species'], y = penguins[, 'bill_len'])


## Scatter plot of 'bill_len' vs 'body_mass';
## in this case the scatter-plot `type = 'p'` must be specified:
pplot(x = penguins[, 'body_mass'], y = penguins[, 'bill_len'], type = 'p')


## Plot y-values having different numbers of x-values
pplot(x = list(1:5, 6:7), y = list(5:1, 6:7))


## Specify only the minimum plotting range
xgrid <- seq(from = -2, to = 2, length.out = 65)
pplot(x = xgrid, y = dnorm(xgrid), ylim = c(0, NA))


## Draw a shaded histogram
histo <- hist(rnorm(1000), breaks = 'FD', plot = FALSE)
pplot(x = histo$breaks, y = histo$density, type = 'hx')

```
