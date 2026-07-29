# Create a grid of values for a variate

Create a data frame of values for one variate, or a combination of
values for several variates.

## Usage

``` r
vrtgrid(vrt, K, length.out = NA)
```

## Arguments

- vrt:

  Character vector: names of the variates; they must match variate names
  in the `metadata` file provided to the
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md)
  function.

- K:

  A "Knowledge" object produced by
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md). It can
  also be a path to a 'K.rds' file containing such object, or to a
  directory containing one.

- length.out:

  Vector or list of positive integer or `NA` values, possibly named:
  number of values to be created for each variate. Elements with names
  are used for the homonymous variates in `vrt`. Unnamed elements are
  used for the remaining variates, recycled as necessary. See "Details"
  for the meaning of `NA` values. Default `NA`.

## Value

A [data frame](https://rdrr.io/r/base/data.frame.html) with columns
corresponding to the `vrt` argument, and one row for each combination of
the variate values.

## Details

The value ranges are based on the information from data and metadata
stored in the `K`nowledge object (see
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)) provided
in the `K =` argument; they include, and extend slightly beyond, the
ranges observed in the data used in the
[`learn()`](https://pglpm.github.io/prova/reference/learn.md) function.
Variate domains are always respected.

The set of chosen values, for each variate, depends on the type of
variate (nominal or continuous, rounded, and so on, see
[metadata](https://pglpm.github.io/prova/reference/metadatatemplate.md)):

- For a discrete (nominal or ordinal) variate, all possible values are
  chosen.

- For a continuous, *non-rounded* variate, a number of values as
  specified in the `length.out` argument; or 129 values if `length.out`
  is missing or `NA`.

- For a continuous, *rounded* variate, a number of values as specified
  in the `length.out` argument; or, if `length.out` is missing or `NA`,
  the output values are separated by the variates's rounding interval
  (field `datastep` in the
  [`metadata`](https://pglpm.github.io/prova/reference/metadatatemplate.md)).

The output is a [data frame](https://rdrr.io/r/base/data.frame.html)
that can be used directly in functions like
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates the `K` objects required by `vrtgrid()`.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
probabilities and their revisabilities.

[`base::expand.grid()`](https://rdrr.io/r/base/expand.grid.html) to
create a data frame with combination of specified values of several
variates.

[`plot.probability()`](https://pglpm.github.io/prova/reference/plot.probability.md)
to plot probabilities and quantiles calculated by
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
K <- Kexample

## set of values for the variate "species";
## since this variate is of a nominal kind, all values are included
valuesSpecies <- vrtgrid(vrt = 'species', K = K)

print(valuesSpecies)
#>     species
#> 1    Adelie
#> 2 Chinstrap
#> 3    Gentoo

## create a small set of values for the variate "bill length";
## this variate is continuous and rounded
valuesBill <- vrtgrid(vrt = 'bill_len', K = K, length.out = 4)

print(valuesBill)
#>   bill_len
#> 1 27.50000
#> 2 39.73333
#> 3 51.96667
#> 4 64.20000

## calculate the conditional probabilities for the 'bill_len' values above,
## given the values of 'species'
probs <- Pr(Y = valuesBill, X = valuesSpecies, K = K)


## Create a data frame with all possible combinations of the values above;
## the 'length.out' argument does not apply to the discrete variate 'species'
valuesAll <- vrtgrid(vrt = c('species', 'bill_len'), K = K, length.out = 4)

print(valuesAll)
#>      species bill_len
#> 1     Adelie 27.50000
#> 2  Chinstrap 27.50000
#> 3     Gentoo 27.50000
#> 4     Adelie 39.73333
#> 5  Chinstrap 39.73333
#> 6     Gentoo 39.73333
#> 7     Adelie 51.96667
#> 8  Chinstrap 51.96667
#> 9     Gentoo 51.96667
#> 10    Adelie 64.20000
#> 11 Chinstrap 64.20000
#> 12    Gentoo 64.20000

## base::expand.grid() would give a similar result
valuesAll2 <- expand.grid(species = unlist(valuesSpecies), bill_len = unlist(valuesBill))

print(valuesAll2)
#>      species bill_len
#> 1     Adelie 27.50000
#> 2  Chinstrap 27.50000
#> 3     Gentoo 27.50000
#> 4     Adelie 39.73333
#> 5  Chinstrap 39.73333
#> 6     Gentoo 39.73333
#> 7     Adelie 51.96667
#> 8  Chinstrap 51.96667
#> 9     Gentoo 51.96667
#> 10    Adelie 64.20000
#> 11 Chinstrap 64.20000
#> 12    Gentoo 64.20000
```
