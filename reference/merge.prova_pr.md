# Merge two objects of class "prova_pr" (probability)

Utility function to merge two objects of class "prova_pr" (probability),
having same `Y` and `X` variates but different values.

## Usage

``` r
# S3 method for class 'prova_pr'
merge(x, y, ...)
```

## Arguments

- x, y:

  Objects of class "prova_pr" (probability), obtained with
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- ...:

  Not used, left for consistency with generic
  [`base::merge()`](https://rdrr.io/r/base/merge.html).

## Value

An object of class "prova_pr" (probability), concatenating the `x` and
`y` objects either along the `Y` values or along the `X` values.

## Details

This function combines two probability objects of class "prova_pr"
(probability) into one. The two objects must have exactly the same sets
(and ordering) of `Y` variates. They must also have the same sets (and
ordering) of `X` variates, unless one or both have `NULL` `X`.

The [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) function
allows to calculate point and tail probabilities for any given variate,
but not both kinds at the same time. For example,
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) can calculate
the probability that a variate "age" is equal to 30, storing the result
in a "prova_pr" probability object; or that it is larger than 35,
storing the result in another probability object. But these two
calculations cannot be done within one call to
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), storing both
results at once in one probability object. With the `merge` function
such an object can nevertheless be created from the previous two.

If the values of the `X` variates are the same, then the probabilities
corresponding to different `Y` values are concatenated. If the values of
the `Y` variates are the same, then the probabilities corresponding to
different `X` values are concatenated. If neither values are in common,
the function throws an error.

## See also

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), to generate
probability objects.

[`subset.prova_pr()`](https://pglpm.github.io/prova/reference/subset.prova_pr.md),
to subset a probability object.

[`plot.prova_pr()`](https://pglpm.github.io/prova/reference/plot.prova_pr.md)
to plot probabilities and quantiles calculated by \`Pr()'.

[`hist.prova_pr()`](https://pglpm.github.io/prova/reference/hist.prova_pr.md)
to plot histograms of the probability distributions calculated by
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
K <- Kexample

## Calculate the probability that bill_len <= 43
## given that the species is 'Adelie':
probs1 <- Pr(
  Y = data.frame(bill_len = 43),
  X = data.frame(species = 'Adelie'),
  K = K,
  tails = list(bill_len = '<=')
)

probs1
#> , , |species = Adelie
#> 
#>         probability
#> bill_len value   +/-     Q5.5%  Q25%   Q75%   Q94.5%
#>     <=43 0.93524 0.00089 0.9078 0.9258 0.9456 0.9581
#> 

## Calculate the probability that bill_len >= 43.1
## given that the species is 'Adelie':
probs2 <- Pr(
  Y = data.frame(bill_len = 43.1),
  X = data.frame(species = 'Adelie'),
  K = K,
  tails = list(bill_len = '>=')
)

probs2
#> , , |species = Adelie
#> 
#>         probability
#> bill_len value   +/-     Q5.5%  Q25%   Q75%   Q94.5%
#>   >=43.1 0.06476 0.00089 0.0419 0.0544 0.0742 0.0922
#> 

## Combine the two tail probabilities for bill_len in one object
probs <- merge(probs1, probs2)

probs
#> , , |species = Adelie
#> 
#>         probability
#> bill_len value   +/-     Q5.5%  Q25%   Q75%   Q94.5%
#>   <=43   0.93524 0.00089 0.9078 0.9258 0.9456 0.9581
#>   >=43.1 0.06476 0.00089 0.0419 0.0544 0.0742 0.0922
#> 
```
