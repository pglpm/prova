# Print summary of a "K" (more precisely "prova_K") object

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display a summary of a "K" (more precisely "prova_K") object
outputted by
[`learn()`](https://pglpm.github.io/prova/reference/learn.md),
internally using [`utils::str()`](https://rdrr.io/r/utils/str.html). It
also display a summary if
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)'s value is
only the path to the directory of the rds file containing the "K" object
itself (see argument `valueisK = ` in
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)), by
internally retrieving the object. To get a summary of a "K" object in a
given directory or RDS file, the user can explicitly call
`print.prova_K(<file path>)`.

## Usage

``` r
# S3 method for class 'prova_K'
print(x, ...)
```

## Arguments

- x:

  Object of class "K" (more precisely "prova_K"), output of
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md).

- ...:

  Other parameters to be passed to
  [`utils::str()`](https://rdrr.io/r/utils/str.html).

## Value

Its `x` argument, [invisibly](https://rdrr.io/r/base/invisible.html);
the [str](https://rdrr.io/r/utils/str.html)ucture of the corresponding
"K" object, if it exists, is also displayed.

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), to
generate a "K" (more precisely "prova_K") object.

[Kexample](https://pglpm.github.io/prova/reference/Kexample.md) an
example "K" object included with **Prova**.

## Examples

``` r
## Display a summary of the example "K" object
## calculated from the "penguins" dataset
print(Kexample)
#> List of 7
#>  $ Dmean      : num [1, 1:64, 1:225] 4.265 1.53 2.779 1.419 0.676 ...
#>  $ Dsd        : num [1, 1:64, 1:225] 1.658 0.213 2.688 4.021 0.448 ...
#>  $ Nprob      : num [1:3, 1:64, 1:225] 6.80e-01 3.16e-01 4.08e-03 7.93e-01 7.60e-07 ...
#>  $ W          : num [1:64, 1:225] 2.17e-10 1.75e-11 4.23e-17 1.41e-60 4.95e-30 ...
#>  $ MCindex    : num [1:225(1d)] 227 310 392 475 558 641 724 807 889 972 ...
#>  $ auxmetadata:'data.frame': 2 obs. of  25 variables:
#>   ..$ name             : chr [1:2] "species" "bill_len"
#>   ..$ type             : chr [1:2] "nominal" "continuous"
#>   ..$ mcmctype         : chr [1:2] "N" "D"
#>   ..$ id               : int [1:2] 1 1
#>   ..$ transform        : chr [1:2] "identity" "identity"
#>   ..$ Nvalues          : int [1:2] 3 NA
#>   ..$ indexpos         : int [1:2] 0 NA
#>   ..$ halfstep         : num [1:2] NA 0.05
#>   ..$ domainmin        : num [1:2] NA 0
#>   ..$ domainmax        : num [1:2] NA Inf
#>   ..$ minincluded      : logi [1:2] NA FALSE
#>   ..$ maxincluded      : logi [1:2] NA FALSE
#>   ..$ tdomainmin       : num [1:2] 1 -20.4
#>   ..$ tdomainmax       : num [1:2] 3 Inf
#>   ..$ domainminplushs  : num [1:2] NA 0.05
#>   ..$ domainmaxminushs : num [1:2] NA Inf
#>   ..$ tdomainminplushs : num [1:2] NA -20.4
#>   ..$ tdomainmaxminushs: num [1:2] NA Inf
#>   ..$ tlocation        : num [1:2] 0 44.5
#>   ..$ tscale           : num [1:2] 1 2.18
#>   ..$ plotmin          : num [1:2] NA 27.5
#>   ..$ plotmax          : num [1:2] NA 64.2
#>   ..$ V1               : chr [1:2] "Adelie" NA
#>   ..$ V2               : chr [1:2] "Chinstrap" NA
#>   ..$ V3               : chr [1:2] "Gentoo" NA
#>  $ info       :List of 19
#>   ..$ metadata                   :'data.frame':  2 obs. of  10 variables:
#>   .. ..$ name       : chr [1:2] "species" "bill_len"
#>   .. ..$ type       : chr [1:2] "nominal" "continuous"
#>   .. ..$ domainmin  : int [1:2] NA 0
#>   .. ..$ domainmax  : int [1:2] NA NA
#>   .. ..$ datastep   : num [1:2] NA 0.1
#>   .. ..$ minincluded: int [1:2] NA NA
#>   .. ..$ maxincluded: int [1:2] NA NA
#>   .. ..$ V1         : chr [1:2] "Adelie" NA
#>   .. ..$ V2         : chr [1:2] "Chinstrap" NA
#>   .. ..$ V3         : chr [1:2] "Gentoo" NA
#>   ..$ nMCsamples                 : int 225
#>   ..$ nchains                    : num 1
#>   ..$ npoints                    : int 344
#>   ..$ hyperparams                :List of 21
#>   .. ..$ ncomponents : num 64
#>   .. ..$ minalpha    : num -4
#>   .. ..$ maxalpha    : num 4
#>   .. ..$ byalpha     : num 1
#>   .. ..$ Rshapelo    : num 0.5
#>   .. ..$ Rshapehi    : num 0.5
#>   .. ..$ Rvarm1      : num 9
#>   .. ..$ Cshapelo    : num 0.5
#>   .. ..$ Cshapehi    : num 0.5
#>   .. ..$ Cvarm1      : num 9
#>   .. ..$ Dshapelo    : num 0.5
#>   .. ..$ Dshapehi    : num 0.5
#>   .. ..$ Dvarm1      : num 9
#>   .. ..$ Bshapelo    : num 1
#>   .. ..$ Bshapehi    : num 1
#>   .. ..$ Dthreshold  : num 1
#>   .. ..$ tscalefactor: num 4.27
#>   .. ..$ Oprior      : chr "Hadamard"
#>   .. ..$ Nprior      : chr "Hadamard"
#>   .. ..$ initmethod  : chr "datacentre"
#>   .. ..$ Qerror      : num [1:2] 0.159 0.841
#>   ..$ maxiterations              : num 18779
#>   ..$ maxusedcomponents          : num 6
#>   ..$ nonfinitechains            : num 0
#>   ..$ stoppedchains              : num 0
#>   ..$ max abs. quantile error    : Named num [1:13] 0.013 0.0184 0.053 0.0338 0.0418 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ quantile width             : Named num [1:13] 0.125 0.277 0.609 0.282 0.387 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ max rel. quantile error    : Named num [1:13] 0.1042 0.0663 0.087 0.12 0.1079 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ min ESS from rel. qt. error: Named num [1:13] 92 227.5 132.2 69.4 85.8 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ MCSE                       : Named num [1:13] 0.00312 0.00668 0.01282 0.00624 0.01233 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ rel. MCSE                  : Named num [1:13] 0.082 0.0771 0.0669 0.0702 0.1043 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ quantl-rel. MCSE           : Named num [1:13] 0.025 0.0241 0.0211 0.0221 0.0318 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ ESS                        : Named num [1:13] 148.7 168.3 223.6 203 91.9 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ needed thinning            : Named num [1:13] 2.45 1.34 1.7 3.24 2.62 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>   ..$ log-average                : Named num [1:13] -5.79 -5.28 -6.67 -5.43 -5.39 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "88" "93" "120" ...
#>  - attr(*, "class")= chr "prova_K"
```
