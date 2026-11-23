# Print an object of class "prova_pr" (probability)

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display selected elements of a "prova_pr" (probability)
object obtained with
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md); typically its
posterior probabilies (element `'value'`) and their revisabilities
(element `'quantiles'`). If the `Y` or `X` variates are joint variates,
this method also allow to display only selected values of them. Singular
probabilities, such as the probability of a censored value for a
continuous variate, are indicated with an asterisk `*`.

## Usage

``` r
# S3 method for class 'prova_pr'
print(x, elements = NULL, digits = TRUE, edigits = 2, ...)
```

## Arguments

- x:

  Object of class "prova_pr" (probability), obtained with
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md).

- elements:

  character or integer vector, or `NULL` (default): elements of the
  "prova_pr" (probability) object to display. The syntax is the same as
  with [`[`](https://rdrr.io/r/base/Extract.html). If `NULL`, the
  elements `'value'` and `'quantiles'` are displayed together in a
  special way.

- digits:

  positive integer or `NULL` or `TRUE` (default): minimal number of
  significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).
  If value is `TRUE`, then the significant digits for elements `'value'`
  and `'quantiles'` are determined from their respective `'value.acc'`
  and `'quantiles.acc'` elements of the "prova_pr" (probability) object
  (see [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md)),
  according to the rules of the *Guide to the expression of Uncertainty
  in Measurement*, keeping as many digits as given in parameter
  `edigits`; whereas `'samples'` elements uses `edigits` significant
  digits.

- edigits:

  positive integer, default 2: number of significant digits for elements
  `'value.acc'` and `'quantiles.acc'`, if `digits = TRUE`.

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

[`plot.prova_pr()`](https://pglpm.github.io/prova/reference/plot.prova_pr.md)
to plot probabilities and quantiles calculated by \`Pr()'.
[`hist.prova_pr()`](https://pglpm.github.io/prova/reference/hist.prova_pr.md)
to plot the revisability of the probabilities as a distribution.

## Examples

``` r
## Use the "K" object 'Kexample',
## calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'

## Calculate the 3 x 2 probabilities for the 3 species
## given bill-lengths of 43 mm and 44 mm

Y <- data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo'))
X <- data.frame(bill_len = c(43, 44))

probs <- Pr(Y, X, Kexample)

## display the values and revisabilities of these probabilities
print(probs)
#> , , |bill_len = 43
#> 
#>            probability
#> species     value  +/-    Q5.5%  Q25%   Q75%   Q94.5%
#>   Adelie    0.4581 0.0046 0.353  0.4152 0.5047 0.5551
#>   Chinstrap 0.1518 0.0029 0.0910 0.1233 0.1783 0.2205
#>   Gentoo    0.3901 0.0055 0.2885 0.3419 0.4356 0.501 
#> 
#> , , |bill_len = 44
#> 
#>            probability
#> species     value  +/-    Q5.5%  Q25%   Q75%   Q94.5%
#>   Adelie    0.2171 0.0038 0.1429 0.1791 0.2467 0.2948
#>   Chinstrap 0.2165 0.0043 0.1404 0.1821 0.2513 0.3053
#>   Gentoo    0.5664 0.0064 0.454  0.5176 0.619  0.6729
#> 

## display 'value' only,
## use subset() to select only the value 'Gentoo' for species
print(subset(probs, subsetY = (species == 'Gentoo')), elements = 'value')
#> $value
#>         |bill_len
#> species    43   44
#>   Gentoo 0.39 0.57
#> 
```
