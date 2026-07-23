# Print an object of class "probability"

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display selected elements of a "probability" object obtained
with [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md); typically
its posterior probabilies (element `$values`) and their revisabilities
(element `$quantiles`). If the `Y` or `X` variates are joint variates,
this method also allow to display only selected values of them. Singular
probabilities, such as the probability of a censored value for a
continuous variate, are indicated with an asterisk `*`.

## Usage

``` r
# S3 method for class 'probability'
print(x, elements = NULL, subset = NULL, digits = TRUE, edigits = 2, ...)
```

## Arguments

- x:

  Object of class "probability", obtained with
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- elements:

  character or integer vector, or `NULL` (default): elements of the
  "probability" object to display. The syntax is the same as with
  [`[`](https://rdrr.io/r/base/Extract.html). If `NULL`, the elements
  `$values` and `$quantiles` are displayed together in a special way.

- subset:

  Named list or named vector: which variate values to display. For the
  variates corresponding to the names in this list, only the vector of
  values corresponding to that variate is displayed.

- digits:

  positive integer or `NULL` or `TRUE` (default): minimal number of
  significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).
  If value is `TRUE`, then the significant digits for elements `$values`
  and `$quantiles` are determined from their respective
  `$values.MCaccuracy` and `$quantiles.MCaccuracy` elements of the
  "probability" object (see
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md)), according to
  the rules of the *Guide to the expression of Uncertainty in
  Measurement*, keeping as many digits as given in parameter `edigits`;
  whereas `$samples` elements uses `edigits` significant digits.

- edigits:

  positive integer, default 2: number of significant digits for elements
  `$values.MCaccuracy` and `$quantiles.MCaccuracy`, if `digits = TRUE`.

- ...:

  Other parameters to be passed to
  [`base::print()`](https://rdrr.io/r/base/print.html).

## Value

Its `x` argument, [invisibly](https://rdrr.io/r/base/invisible.html);
see [`base::print()`](https://rdrr.io/r/base/print.html).

## References

- Joint Committee for Guides in Metrology (2008): *Guide to the
  expression of uncertainty in measurement*,
  <doi:10.59161/JCGM100-2008E>,
  <https://www.iso.org/sites/JCGM/GUM-JCGM100.htm>.

## See also

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
posterior probabilities and quantiles.

[`plot.probability()`](https://pglpm.github.io/prova/reference/plot.probability.md)
to plot probabilities and quantiles calculated by \`Pr()'.
[`hist.probability()`](https://pglpm.github.io/prova/reference/hist.probability.md)
to plot the revisability of the probabilities as a distribution.

## Examples

``` r
## Load the example `learnt` object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
learnt <- learntExample

## Calculate the 3 x 2 probabilities for the 3 species
## given bill-lengths of 43 mm and 44 mm

Y <- data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo'))
X <- data.frame(bill_len = c(43, 44))

probs <- Pr(Y = Y, X = X, learnt = learnt, parallel = 1)

## display the values and revisabilities of these probabilities
print(probs)
#> , , |bill_len = 43
#> 
#>            probability
#> species     value  +/-    Q5.5%  Q25%   Q75%   Q94.5%
#>   Adelie    0.4647 0.0049 0.3669 0.4212 0.5131 0.5679
#>   Chinstrap 0.1458 0.0029 0.0810 0.1167 0.1723 0.2191
#>   Gentoo    0.3894 0.0034 0.2985 0.3476 0.4302 0.4812
#> 
#> , , |bill_len = 44
#> 
#>            probability
#> species     value  +/-    Q5.5%  Q25%   Q75%   Q94.5%
#>   Adelie    0.2223 0.0029 0.145  0.1866 0.2551 0.3069
#>   Chinstrap 0.2054 0.0035 0.1198 0.1717 0.2429 0.2966
#>   Gentoo    0.5722 0.0031 0.4671 0.5270 0.6204 0.6718
#> 

## diplay 'values' only, and only for the species value 'Gentoo'
print(probs, elements = 'values', subset = list(species = 'Gentoo'))
#> $values
#>         |bill_len
#> species    43   44
#>   Gentoo 0.39 0.57
#> 
```
