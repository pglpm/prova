# Print an object of class "MI" (mutual information)

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display value and revisability of an "MI" object obtained
with
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

## Usage

``` r
# S3 method for class 'MI'
print(x, digits = TRUE, edigits = 2, unit = NULL, ...)
```

## Arguments

- x:

  Object of class "MI", obtained with
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

- digits:

  positive integer or `NULL` or `TRUE` (default): minimal number of
  significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).
  If value is `TRUE`, then the significant digits for element `$value`
  is determined from is respective `$MCaccuracy` (see
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)),
  according to the rules of the *Guide to the expression of Uncertainty
  in Measurement*, keeping as many digits as given in parameter
  `edigits`; whereas `$quantiles` elements uses `edigits` significant
  digits.

- edigits:

  positive integer, default 2: number of significant digits for element
  `$value` and `$quantiles`, if `digits = TRUE`.

- unit:

  Either `NULL`, or one of 'Sh' for *shannon* (default), 'Hart' for
  *hartley*, 'nat' for *natural unit*, or a positive real indicating the
  base of the logarithms to be used; see analogous argument in
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).
  If `NULL` (default), the same unit as in the object `x` is used. Unit
  conversion is internally performed if this unit is different from that
  of the object `x`.

- ...:

  Other parameters to be passed to
  [`base::print()`](https://rdrr.io/r/base/print.html).

## Value

Its `x` argument, [invisibly](https://rdrr.io/r/base/invisible.html);
see [`base::print()`](https://rdrr.io/r/base/print.html).

## See also

[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
to calculate mutual information.

[`hist.MI()`](https://pglpm.github.io/prova/reference/hist.MI.md) to
plot the revisability of the mutual information.

## Examples

``` r
# \donttest{
### WARNING: the following example, if run, might even take a minute or more.

## Load the example `learnt` object calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'
learnt <- learntExample

## Calculate the mutual information between variates 'species' and 'bill_len'
MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
  learnt = learnt, parallel = 1)

## display the value and revisability of the mutual information
print(MI)
#> value/Sh    Q5.5%     Q25%     Q75%   Q94.5% 
#>    0.767     0.35     0.71     0.92      1.0 

## convert to hartleys (base-10 logarithms):
print(MI, unit = 'Hart')
#> value/Hart      Q5.5%       Q25%       Q75%     Q94.5% 
#>     0.2309       0.11       0.21       0.28       0.31 
# }
```
