# Print an object of class "prova_eu" (expected utility)

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display value and revisability of an "prova_mi" (mutual
information) object obtained with
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

## Usage

``` r
# S3 method for class 'prova_eu'
print(x, elements = NULL, digits = TRUE, edigits = 2, ...)
```

## Arguments

- x:

  Object of class "prova_eu" (expected utility), obtained with
  [`exputility()`](https://pglpm.github.io/prova/reference/exputility.md).

- elements:

  character or integer vector, or `NULL` (default): elements of the
  "expected utility" object to display. The syntax is the same as with
  [`[`](https://rdrr.io/r/base/Extract.html). If `NULL`, the elements
  `'value'`, `'value.acc'`, `'optimal.probs'` are displayed together in
  a special way.

- digits:

  positive integer or `NULL` or `TRUE` (default): minimal number of
  significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).
  If value is `TRUE`, then the significant digits for element `'value'`
  are determined from is respective `'value.acc'` (see
  [`exputility()`](https://pglpm.github.io/prova/reference/exputility.md)),
  according to the rules of the *Guide to the expression of Uncertainty
  in Measurement*, keeping as many digits as given in parameter
  `edigits`.

- edigits:

  positive integer, default 2: number of significant digits for element
  `'value'` and `'quantiles'`, if `digits = TRUE`.

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

[`exputility()`](https://pglpm.github.io/prova/reference/exputility.md)
to calculate expected utilities and their revisability.

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

## Print the expected utility of each action, its numerical accuracy,
## and the probability that it would be optimal if more data were available

print(eu)
#>        
#> actions   EU     +/-    prob.
#>      A1   0.3981 0.0048 0.013
#>      A2   0.3511 0.0013 0.058
#>      A3 * 0.4307 0.0036 0.93 
#>      A4   0.2403 0.0015 0    
```
