# Retrieve a "prova_K" (knowledge) object

Retrieve a "prova_K" (knowledge) object

## Usage

``` r
.retrieveK(K)
```

## Arguments

- K:

  either a "prova_K" (knowledge) object, or a character string with the
  path to an rds file with such an object or a directory containing one.

## Value

The actual "prova_K" (knowledge) object or `NULL` if none was found.

## Details

Retrieves a "prova_K" (knowledge) object if given as a path to directory
or file.
