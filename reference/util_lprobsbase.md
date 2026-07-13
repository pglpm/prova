# Calculate collection of log-probabilities for different components and samples

Used in [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md),
[`qPr()`](https://pglpm.github.io/prova/reference/qPr.md),
[`rPr()`](https://pglpm.github.io/prova/reference/rPr.md),
[`mutualinfo()`](https://pglpm.github.io/prova/reference/mutualinfo.md),
[`util_Pcheckpoints()`](https://pglpm.github.io/prova/reference/util_Pcheckpoints.md).

## Usage

``` r
util_lprobsbase(xVs, params, logW, temporarydir = NULL, lab = "")
```

## Value

Matrix of log-probabilities, with as many rows as components and as many
cols as samples.
