# Print summary of a "Knowledge" object

This [`base::print()`](https://rdrr.io/r/base/print.html) method is a
utility to display a summary of a "Knowledge" object outputted by
[`learn()`](https://pglpm.github.io/prova/reference/learn.md),
internally using [`utils::str()`](https://rdrr.io/r/utils/str.html). It
also display a summary if
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)'s value is
only the path to the directory of the rds file containing the
"Knowledge" object itself (see argument `valueisK =` in
[`learn()`](https://pglpm.github.io/prova/reference/learn.md)), by
internally retrieving the object. If you want to have a summary of a "K"
object in a given directory or rds file, you can explicitly call
`print.K(<file path>)`.

## Usage

``` r
# S3 method for class 'K'
print(x, ...)
```

## Arguments

- x:

  Object of class "K", output of
  [`learn()`](https://pglpm.github.io/prova/reference/learn.md).

- ...:

  Other parameters to be passed to
  [`utils::str()`](https://rdrr.io/r/utils/str.html).

## Value

Its `x` argument, [invisibly](https://rdrr.io/r/base/invisible.html);
the [str](https://rdrr.io/r/utils/str.html)ucture of the corresponding
"K" object, if it exists, is also displayed.

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
generates a "Knowledge" object.

[Kexample](https://pglpm.github.io/prova/reference/Kexample.md) an
example "K" object included with **Prova**.

## Examples

``` r
## Display a summary of the example "Knowledge" object calculated from the "penguins" dataset
print(Kexample)
#> List of 7
#>  $ Dmean      : num [1, 1:64, 1:225] -0.665 3.942 -5.018 1.271 3.742 ...
#>  $ Dsd        : num [1, 1:64, 1:225] 0.6413 0.0614 10.5637 0.9795 0.1708 ...
#>  $ Nprob      : num [1:3, 1:64, 1:225] 0.1032 0.8193 0.0775 0.1119 0.8821 ...
#>  $ W          : num [1:64, 1:225] 7.54e-168 1.10e-18 4.59e-43 1.59e-30 2.20e-48 ...
#>  $ MCindex    : num [1:225(1d)] 219 3752 7285 10817 14350 ...
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
#>  $ auxinfo    :List of 12
#>   ..$ nchains          : num 15
#>   ..$ npoints          : int 344
#>   ..$ hyperparams      :List of 21
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
#>   ..$ maxiterations    : num 49676
#>   ..$ maxusedcomponents: num 8
#>   ..$ nonfinitechains  : num 0
#>   ..$ stoppedchains    : num 0
#>   ..$ rel. CI error    : Named num [1:13] 0.0754 0.0613 0.0763 0.1336 0.1411 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "62" "64" "67" ...
#>   ..$ ESS              : Named num [1:13] 192 234 251 190 351 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "62" "64" "67" ...
#>   ..$ needed thinning  : Named num [1:13] 1.28 0.96 1.31 4.02 4.48 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "62" "64" "67" ...
#>   ..$ average          : Named num [1:13] 0.002442 0.000643 0.006379 0.002348 0.002848 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "62" "64" "67" ...
#>   ..$ quantile width   : Named num [1:13] 0.000495 0.000589 0.001754 0.00243 0.001564 ...
#>   .. ..- attr(*, "names")= chr [1:13] "gmean" "62" "64" "67" ...
#>  - attr(*, "class")= chr "K"
```
