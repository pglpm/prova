# Build augmented metadata file

Builds an augmented metadata [data
frame](https://rdrr.io/r/base/data.frame.html) from the metadata and
data given to 'learn()'. This augmented metadata object is saved in the
'K'nowledge object produced by 'learn()'.

## Usage

``` r
.buildauxmetadata(data, metadata, Dthreshold = 1, tscalefactor = 4.266)
```

## Arguments

- data:

  data.frame object.

- metadata:

  data.frame object.

- Dthreshold:

  Positive number, default 1: threshold of fraction of unique datapoints
  to total datapoints, to decide whether to treat a rounded variate as
  continuous.

- tscalefactor:

  Positive number, default 4.266: scaling factor for variate
  transformation.

## Value

A [data frame](https://rdrr.io/r/base/data.frame.html) with auxiliary
metadata:

- `name` of the variate.

- `type` of the variate.

- `mcmctype` (`R`, `C`, `D`, `O`, `N`, `B`) of the variate, for internal
  computation.

- `id` number of the variate among those of same `mcmctype`.

- `transform` (`'identity'`, `'Q'`, `'log'`, `'logminus'`): internal
  transformation for the variate.

- `Nvalues`: variate's domain size.

- `indexpos`: starting position *minus 1* of the nominal/ordinal variate
  in the `Nprob`/`Oprob` vector of probabilities.

- `halfstep`: half of the value step for rounded variates.

- `domainmin`: domain's lower bound.

- `domainmax`: domain's upper bound.

- `minincluded`: is lower bound included in the domain?

- `maxincluded`: is upper bound included in the domain?

- `tdomainmin`: transformed lower bound.

- `tdomainmax`: transformed upper bound.

- `domainminplushs`: lower bound plus half value-step.

- `domainmaxminushs`: upper bound minus half value-step.

- `tdomainminplushs`: transformed lower bound plus half value-step.

- `tdomainmaxminushs`: transformed upper bound minus half value-step.

- `tlocation`: transformed location parameter, usually the median.

- `tscale`: transformed scale parameter, usually InterQuartileRange
  divided by `tscalefactor`.

- `plotmin`: lower plot range.

- `plotmax`: upper plot range.

## Details

In addition to the original metadata it contains info about transformed
variates and their domains, estimated location- and scale-parameters,
and similar metadata.

Used in 'learn()'.
