# Format datapoints used for MCMC monitoring

Simplified version of
[`.lprobsargs()`](https://pglpm.github.io/prova/reference/dot-lprobsargs.md).
Used in '.Pcheckpoints()' within 'learn()'.

## Usage

``` r
.prepPcheckpoints(x, auxmetadata, pointsid = NULL)
```

## Arguments

- x:

  Datapoints to be used for checking MCMC progress

- auxmetadata:

  auxmetadata object

- pointsid:

  Id of datapoints

## Value

some arguments to be repeatedly used in
[`.Pcheckpoints()`](https://pglpm.github.io/prova/reference/dot-Pcheckpoints.md);
see
[`.lprobsargs()`](https://pglpm.github.io/prova/reference/dot-lprobsargs.md).
