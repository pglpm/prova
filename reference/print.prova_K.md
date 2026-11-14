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
#>  $ Dmean      : num [1, 1:64, 1:225] 0.68 -0.814 -1.057 -1.607 -2.867 ...
#>  $ Dsd        : num [1, 1:64, 1:225] 1.08594 2.23184 1.60639 0.36502 0.00626 ...
#>  $ Nprob      : num [1:3, 1:64, 1:225] 0.22369 0.622466 0.153844 0.000493 0.998166 ...
#>  $ W          : num [1:64, 1:225] 8.01e-27 2.99e-44 4.67e-23 5.43e-10 1.36e-47 ...
#>  $ MCindex    : num [1:225(1d)] 204 257 310 362 415 467 520 573 625 678 ...
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
#>   ..$ maxiterations              : num 11983
#>   ..$ maxusedcomponents          : num 5
#>   ..$ nonfinitechains            : num 0
#>   ..$ stoppedchains              : num 0
#>   ..$ max abs. quantile error    : Named num [1:13] 0.0192 0.0227 0.0145 0.0347 0.025 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ quantile width             : Named num [1:13] 0.202 0.275 0.272 0.338 0.505 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ max rel. quantile error    : Named num [1:13] 0.0954 0.0824 0.0534 0.1027 0.0495 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ min ESS from rel. qt. error: Named num [1:13] 109.8 147.3 350.2 94.8 408.8 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ MCSE                       : Named num [1:13] 0.00333 0.003 0.00305 0.00617 0.01195 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ rel. MCSE                  : Named num [1:13] 0.0498 0.0342 0.0348 0.0611 0.0743 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ quantl-rel. MCSE           : Named num [1:13] 0.0165 0.0109 0.0112 0.0183 0.0236 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ ESS                        : Named num [1:13] 402 855 827 268 181 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ needed thinning            : Named num [1:13] 2.049 1.527 0.642 2.373 1.24 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>   ..$ log-average                : Named num [1:13] -6.07 -5.07 -5.08 -5.42 -5.84 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "2" "51" "92" ...
#>  - attr(*, "class")= chr "prova_K"
```
