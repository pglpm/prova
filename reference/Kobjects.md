# Set or unset default values for 'K =' arguments, and retrieve "prova_K" objects.

Functions for declaring or undeclaring a "K" (more precisely "prova_K")
object to be used implicitly in any subsequent `K = ` arguments, and for
showing its contents.

## Usage

``` r
useK(K = NULL)

getK(K = NULL, .name = NULL)
```

## Arguments

- K:

  One of these alternatives:

  - A "K" (more precisely "prova_K") object.

  - A character string of the path to an
    [RDS](https://rdrr.io/r/base/readRDS.html) file (typically created
    by [`learn()`](https://pglpm.github.io/prova/reference/learn.md))
    containing a valid "K" object.

  - A character string of the path to a directory (also typically
    created by
    [`learn()`](https://pglpm.github.io/prova/reference/learn.md))
    containing such an [RDS](https://rdrr.io/r/base/readRDS.html) file
    of a "K" object.

  - For function `useK()`, argument `NULL` or `NA` or `FALSE`
    **removes** any default `K = ` argument.

  - Function `useK()` with empty argument will return the name of the
    "K" object currently used as default.

  - For function `getK()` it can also be `NULL` or omitted, if a default
    `K = ` argument has been defined with `useK()`.

- .name:

  Either `NULL` (default) or a character. Used for internal purposes.

## Value

Function `useK(...)`, called with an argument (also `NULL`), invisibly
returns the name of the variable that points to the "K" object. If
called with no arguments, '`useK()`', it returns the name of the "K"
object currently set as default, or `NULL` if none is set.

Function `getK()` returns the actual "K" object corresponding to its
input. If called with a non-`NULL` `name` argument, it returns a list of
a "K" object and its name.

## Details

The `K = ` argument in most functions of the **Prova** package, such as
[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md), accepts either
a "K" (more precisely "prova_K") object, or a path to a directory
containing a 'K.rds' file with such object, or a path to such a file
itself. In a typical session or script, the "K" object was calculated
beforehand, and is the same in all functions, unless the user is
comparing probabilities calculated from different sampling data or
different amounts of sampling data.

The function `useK()` allows the user to specify a "K" object to be
implictily used in all `K = ` arguments of subsequent function calls.
Then such arguments can simply be omitted, saving a lot of
`K = ...`-typing (attention must still be paid to argument order; see
details of individual functions).

This function also checks if the given `K` is a valid "K" object, or
path to one, and throws an error otherwise. Note that any previously
declared object is replaced.

(This function also saves, mostly for internal purpose in plotting
functions, the name of the variable that pointed to the "K" object.)

If called with empty argument, '`useK()`', it returns the name of the
"K" object currently set as default, or `NULL` if no default is set.

If called as `useK(NULL)` or `useK(NA)`, `useK(FALSE)`, then it declares
that no default "K" objects should be used in `K = ` arguments any
longer. Note that any subsequent calls to functions that omit `K = `
arguments will obviously throw an error.

The function `getK()` returns the actual "K" object, if its argument is
a path to such an object. If the argument is the object itself it just
returns it. With an empty argument, it returns the "K" object declared
by `useK()`, throwing an error if no such object was declared. This
function can be useful if you want to quickly check some information
stored in the "K" object, such as the metadata or the number of Monte
Carlo samples (see examples).

(This function can also return, via the `name` argument, the original
name of the variable that pointed to the "K" object. This is mostly used
for internal use of plotting functions.)

## See also

[`learn()`](https://pglpm.github.io/prova/reference/learn.md), which
creates and stores "K" objects.

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md),
[`vrtgrid()`](https://pglpm.github.io/prova/reference/vrtgrid.md), and
similar functions which use "K" objects.

[Kexample](https://pglpm.github.io/prova/reference/Kexample.md) an
example "K" object included with **Prova**.

## Examples

``` r
## 'Prova' includes the example object 'Kexample'
## related to a dataset with variates 'species' and 'bill_len'.

## Set the object 'Kexample' to be used as default 'K=' argument;
## it could be just the path (character string) to such an object
useK(Kexample)

## Show the metadata included in this default knowledge object
getK()$info$metadata
#>       name       type domainmin domainmax datastep minincluded maxincluded
#> 1  species    nominal        NA        NA       NA          NA          NA
#> 2 bill_len continuous         0        NA      0.1          NA          NA
#>       V1        V2     V3
#> 1 Adelie Chinstrap Gentoo
#> 2   <NA>      <NA>   <NA>

## Create a data frame with all possible values of 'species';
## then calculate the probabilities of the different species
## full calls would be   vrtgrid(vrt = 'species', K = Kexample)
## and   Pr(Y = Y, X = NA, K = Kexample)

Y <- vrtgrid('species')

probs <- Pr(Y)

## Stop 'Kexample' to be used as default;
## note that calling "Pr(Y)" would give an error thereafter.
useK()
#> [1] "Kexample"

## Show how many Monte Carlo samples 'Kexample' contains;
## note we must pass it explicitly as argument now
getK(Kexample)$info$nMCsamples
#> [1] 225
```
