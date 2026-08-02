# Metadata file for "penguins" dataset

A [data frame](https://rdrr.io/r/base/data.frame.html) containing the
prior information about all variates of the
[penguins](https://rdrr.io/r/datasets/penguins.html) dataset.

## Usage

``` r
meta_penguins
```

## Format

### `metadataExample`

A [data frame](https://rdrr.io/r/base/data.frame.html) with 8 rows and
10 columns.

## Value

No return value.

## See also

[datasets::penguins](https://rdrr.io/r/datasets/penguins.html) dataset.

[`metadatatemplate()`](https://pglpm.github.io/prova/reference/metadata.md)
which helps producing this kind of metadata files from a given dataset.

[`learn()`](https://pglpm.github.io/prova/reference/learn.md) which
needs this kind of metadata files to "learn" from data.

## Examples

``` r

print(meta_penguins)
#>          name       type domainmin domainmax datastep minincluded maxincluded
#> 1     species    nominal        NA        NA       NA          NA          NA
#> 2      island    nominal        NA        NA       NA          NA          NA
#> 3    bill_len continuous         0        NA      0.1          NA          NA
#> 4    bill_dep continuous         0        NA      0.1          NA          NA
#> 5 flipper_len continuous         0        NA      1.0          NA          NA
#> 6   body_mass continuous         0        NA     25.0          NA          NA
#> 7         sex    nominal        NA        NA       NA          NA          NA
#> 8        year    ordinal      2007      2009      1.0          NA          NA
#>       V1        V2        V3
#> 1 Adelie Chinstrap    Gentoo
#> 2 Biscoe     Dream Torgersen
#> 3   <NA>      <NA>      <NA>
#> 4   <NA>      <NA>      <NA>
#> 5   <NA>      <NA>      <NA>
#> 6   <NA>      <NA>      <NA>
#> 7 female      male      <NA>
#> 8   <NA>      <NA>      <NA>
```
