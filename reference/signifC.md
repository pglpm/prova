# Format numbers respecting significant digits

This is a combination of the
[`base::signif()`](https://rdrr.io/r/base/Round.html) and
[`base::formatC()`](https://rdrr.io/r/base/formatc.html) functions,
which appropriately rounds non-decimal digits, like
[`signif()`](https://rdrr.io/r/base/Round.html) does, and appends
trailing zeros as necessary, lik
[`formatC()`](https://rdrr.io/r/base/formatc.html) does.

## Usage

``` r
signifC(x, digits = 2)
```

## Arguments

- x:

  numerical vector, matrix, or array

- digits:

  vector of positive integers: number of *significant* digits to be
  displayed

## Value

A *character* vector, matrix, or array of the elements of `x`,
appropriately rounded and truncated.
