# Format datapoints used for MCMC monitoring

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

some arguments to be repeatedly used in .Pcheckpoints
