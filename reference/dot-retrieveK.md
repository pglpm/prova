# Retrieve a "Knowledge" object

Retrieve a "Knowledge" object

## Usage

``` r
.retrieveK(K)
```

## Arguments

- K:

  either a "Knowledge" object, or a character string with the path to an
  rds file with such an object or a directory containing one.

## Value

The actual "Knowledge" object or `NULL` if none was found.

## Details

Retrieves a "Knowledge" object if given as a path to directory or file.
