# Test posterior probabilities

This function calculates a posterior probability or probability density.
It does so in a way that is inefficient but different from
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) and with clearer
code. It can therefore be used to test the correct functioning of
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md). Note that,
unlike [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), this
function does not do consistency checks of its arguments.

## Usage

``` r
.testPr(Y, X = NULL, K = NULL, tails = NULL)
```

## Arguments

- Y:

  named list of values; list names must be valid variate names.

- X:

  named list of values; list names must be valid variate names.

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
  or all of the variates in arguments `Y` and `X`. For variates in this
  list, the probability arguments are understood in a semi-open interval
  sense: \\Y \le y\\ or \\Y \ge y\\, an so on. This is true for `Y` and
  `X` variates (on the left and on the right of the conditional sign
  \\\\\vert\\\\). A left-open interval \\Y \le y\\ is indicated by
  `'<='` or `'lower'` or`'left'` or `-1`; a right-open interval \\Y \ge
  y\\ is indicated by `'>='` or `'upper'` or `'right'` or `+1`. Values
  `NULL`, `'=='`, `0` indicate that a point value `Y = y` (not an
  interval) should be calculated. **NB**: the semi-open intervals
  *always* include the given value; this is important for ordinal or
  rounded variates. For instance, if \\Y\\ is an integer variate, then
  to calculate \\\mathrm{Pr}(Y \< 3)\\ the user should require
  \\\mathrm{Pr}(Y \le 2)\\; for this reason we also have that
  \\\mathrm{Pr}(Y \le 2)\\ and \\\mathrm{Pr}(Y \ge 2)\\ generally add up
  to *more* than 1.

## Value

A list consisting of the following elements:

- `value`: value of \\\mathrm{Pr}(Y = y \vert X = x, \text{data})\\.

- `samples`: a vector with the revisability samples of the probability
  above.

- `jacobians`: a vector with the Jacobian of the internal
  transformation.
