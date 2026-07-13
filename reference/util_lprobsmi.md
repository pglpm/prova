# Calculate and combine log-probabilities to compute entropies

Calculate log2_p(Y1\|Y2), log2_p(Y2\|Y1), log2_p(Y1), log2_p(Y2) for one
datapoint. Used in
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md).

## Usage

``` r
util_lprobsmi(xVs, params1, params2, lW)
```

## Value

A vector of two pointwise mutual informations; one calculated from all
MC samples, the other from the "limit frequencies" (MC sample
corresponding to the input datapoint).
