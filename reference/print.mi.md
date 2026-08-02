# Print an object of class "mi" (mutual information)

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display value and revisability of an "mi" object obtained
with
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

## Usage

``` r
# S3 method for class 'mi'
print(x, unit = NULL, elements = NULL, digits = TRUE, edigits = 2, ...)
```

## Arguments

- x:

  Object of class "mi", obtained with
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

- unit:

  Either `NULL`, or one of 'Sh' for *shannon* (default), 'Hart' for
  *hartley*, 'nat' for *natural unit*, or a positive real indicating the
  base of the logarithms to be used; see analogous argument in
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).
  If `NULL` (default), the same unit as in the object `x` is used. Unit
  conversion is internally performed if this unit is different from that
  of the object `x`.

- elements:

  character or integer vector, or `NULL` (default): elements of the
  "mutual information" object to display. The syntax is the same as with
  [`[`](https://rdrr.io/r/base/Extract.html). If `NULL`, the elements
  `'value'` and `'quantiles'` are displayed together in a special way.

- digits:

  positive integer or `NULL` or `TRUE` (default): minimal number of
  significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).
  If value is `TRUE`, then the significant digits for element `'value'`
  are determined from is respective `'value.acc'` (see
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)),
  according to the rules of the *Guide to the expression of Uncertainty
  in Measurement*, keeping as many digits as given in parameter
  `edigits`; whereas `'quantiles'` elements uses `edigits` significant
  digits.

- edigits:

  positive integer, default 2: number of significant digits for element
  `'value'` and `'quantiles'`, if `digits = TRUE`.

- ...:

  Other parameters to be passed to
  [`base::print()`](https://rdrr.io/r/base/print.html).

## Value

Its `x` argument, [invisibly](https://rdrr.io/r/base/invisible.html);
see [`base::print()`](https://rdrr.io/r/base/print.html).

## See also

[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md)
to calculate mutual information.

[`hist.mi()`](https://pglpm.github.io/prova/reference/hist.mi.md) to
plot the revisability of the mutual information.

## Examples

``` r
# \donttest{
### WARNING: the following example, if run, might even take a minute or more.

## Use the "Knowledge" object 'Kexample',
## calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'

## Calculate the mutual information between variates 'species' and 'bill_len'
MI <- mutualinfo('species', 'bill_len', Kexample)

## display the value and revisability of the mutual information
print(MI)
#> value/Sh      +/-    Q5.5%     Q25%     Q75%   Q94.5% 
#>    0.765    0.015    0.361    0.675    0.939    1.050 

## convert to hartleys (base-10 logarithms):
print(MI, unit = 'Hart')
#> value/Hart        +/-      Q5.5%       Q25%       Q75%     Q94.5% 
#>      0.765      0.015      0.361      0.675      0.939      1.050 
# }
```
