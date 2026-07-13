# Print an object of class "MI" (mutual information)

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display value and revisability of an "MI" object obtained
with
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

## Usage

``` r
# S3 method for class 'MI'
print(x, digits = 2, ...)
```

## Arguments

- x:

  Object of class "MI", obtained with
  [`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

- digits:

  positive number, default 2,: number of significant digits, see
  [`base::print.default()`](https://rdrr.io/r/base/print.default.html).

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
#>     0.74     0.29     0.65     0.94     1.10 
# }
```
