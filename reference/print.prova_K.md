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
#>  $ Dmean      : num [1, 1:64, 1:225] -4.117 1.462 4.843 -1.678 -0.462 ...
#>  $ Dsd        : num [1, 1:64, 1:225] 0.6 10.553 0.239 4.27 0.176 ...
#>  $ Nprob      : num [1:3, 1:64, 1:225] 0.0355 0.7931 0.1714 0.0212 0.8802 ...
#>  $ W          : num [1:64, 1:225] 3.19e-04 8.25e-15 1.27e-06 1.17e-18 2.07e-52 ...
#>  $ MCindex    : num [1:225(1d)] 238 298 358 418 477 537 597 657 717 777 ...
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
#>  $ info       :List of 11
#>   ..$ metadata         :'data.frame':    2 obs. of  10 variables:
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
#>   ..$ nMCsamples       : int 225
#>   ..$ nchains          : num 1
#>   ..$ npoints          : int 344
#>   ..$ maxiterations    : num 13646
#>   ..$ maxusedcomponents: num 5
#>   ..$ nonfinitechains  : num 0
#>   ..$ stoppedchains    : num 0
#>   ..$ .Random.seed     : int [1:626] 10403 95 -251349914 817189872 -776917741 361681585 -166445728 940012286 1143156361 -2060035653 ...
#>   ..$ args             :List of 24
#>   .. ..$ nsamples           : num 225
#>   .. ..$ nchains            : num 1
#>   .. ..$ nsamplesperchain   : num 450
#>   .. ..$ parallel           : logi TRUE
#>   .. ..$ seed               : NULL
#>   .. ..$ cleanup            : logi TRUE
#>   .. ..$ appendinfo         : logi TRUE
#>   .. ..$ valueisK           : logi TRUE
#>   .. ..$ subsampledata      : NULL
#>   .. ..$ prior              : logi FALSE
#>   .. ..$ startupMCiterations: num 3600
#>   .. ..$ minMCiterations    : num 0
#>   .. ..$ maxMCiterations    : num 9e+05
#>   .. ..$ maxhours           : num Inf
#>   .. ..$ ncheckpoints       : NULL
#>   .. ..$ maxrelMCSE         : num 0.0471
#>   .. ..$ minESS             : num 450
#>   .. ..$ initES             : num 8
#>   .. ..$ thinning           : NULL
#>   .. ..$ verbose            : logi TRUE
#>   .. ..$ plottraces         : logi FALSE
#>   .. ..$ showKtraces        : logi FALSE
#>   .. ..$ showAlphatraces    : logi FALSE
#>   .. ..$ hyperparams        :List of 22
#>   .. .. ..$ ncomponents : num 64
#>   .. .. ..$ minalpha    : num -4
#>   .. .. ..$ maxalpha    : num 4
#>   .. .. ..$ byalpha     : num 1
#>   .. .. ..$ Rshapelo    : num 0.5
#>   .. .. ..$ Rshapehi    : num 0.5
#>   .. .. ..$ Rvarm1      : num 9
#>   .. .. ..$ Cshapelo    : num 0.5
#>   .. .. ..$ Cshapehi    : num 0.5
#>   .. .. ..$ Cvarm1      : num 9
#>   .. .. ..$ Dshapelo    : num 0.5
#>   .. .. ..$ Dshapehi    : num 0.5
#>   .. .. ..$ Dvarm1      : num 9
#>   .. .. ..$ Bshapelo    : num 1
#>   .. .. ..$ Bshapehi    : num 1
#>   .. .. ..$ Dthreshold  : num 1
#>   .. .. ..$ tscalefactor: num 4.27
#>   .. .. ..$ Oprior      : chr "Hadamard"
#>   .. .. ..$ Nprior      : chr "Hadamard"
#>   .. .. ..$ avoidzeroW  : NULL
#>   .. .. ..$ initmethod  : chr "datacentre"
#>   .. .. ..$ Qerror      : num [1:2] 0.159 0.841
#>   ..$ diagn            :List of 9
#>   .. ..$ max abs. quantile error    : num [1:3] 0.024 0.0591 0.0731
#>   .. ..$ quantile width             : num [1:3] 0.104 0.559 0.672
#>   .. ..$ max rel. quantile error    : num [1:3] 0.231 0.106 0.109
#>   .. ..$ min ESS from rel. qt. error: num [1:3] 18.7 89.6 84.5
#>   .. ..$ MCSE                       : Named num [1:3] 0.00256 0.01506 0.01101
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#191" "#93"
#>   .. ..$ rel. MCSE                  : Named num [1:3] 0.079 0.0861 0.0524
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#191" "#93"
#>   .. ..$ ESS                        : Named num [1:3] 160 135 365
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#191" "#93"
#>   .. ..$ max needed thinning        : num 12
#>   .. ..$ log-averages               : Named num [1:3] -5.78 -6.02 -6.67
#>   .. .. ..- attr(*, "names")= chr [1:3] "entropy / joint log-F" "#191" "#93"
#>  - attr(*, "class")= chr "prova_K"
```
