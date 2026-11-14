# Compute ESS

See: Geyer 1992, <doi:10.1214/ss/1177011137>, Vehtari & al. 2021
<doi:10.1214/20-BA1221>, RStan
<https://github.com/stan-dev/rstan/blob/develop/rstan/rstan/R/monitor.R>

## Usage

``` r
.funESS3(x)
```

## Arguments

- x:

  Vector of MC samples.

## Value

Effective Sample Size.

## Details

Used in '.workerfun()' in 'learn()', and in '.funMCEQ()'.
