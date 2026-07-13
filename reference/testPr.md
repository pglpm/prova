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
testPr(Y, X = NULL, learnt, tails = NULL)
```

## Arguments

- Y:

  named list of values; list names must be valid variate names.

- X:

  named list of values; list names must be valid variate names.

- learnt:

  Either a character with the name of a directory or full path for a
  'learnt.rds' object, produced by the
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md)
  function, or such an object itself.

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
  to calculate \\\mathrm{Pr}(Y \< 3)\\ you should require
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
