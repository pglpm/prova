# Calculate expected utilities and their uncertainties

This functions calculates the expected utilities of each action or
decision corresponding to a given utility matrix. The long-run utilities
are also calculated.

## Usage

``` r
exputility(u, p)
```

## Arguments

- u:

  a utility matrix given as a
  [`base::matrix()`](https://rdrr.io/r/base/matrix.html) or as a
  [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html)
  (internally converted into a matrix). Each row of the matrix
  corresponds to a possible action; each row to an uncertain outcome
  \\Y\\. The number of columns must be equal to the number of
  \\Y\\-values of the "probability" object of argument `p`.

- p:

  A "probability" object, obtained from
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md). The number of
  \\Y\\-values of this object must be equal to the number of columens of
  the utility matrix of argument `um`.

## Value

A [list](https://rdrr.io/r/base/list.html) of the following elements:

- `'value'`: a [matrix](https://rdrr.io/r/base/matrix.html) of the
  expected utilities of the actions. One row for each action, one column
  for each value of the conditional \\X\\ in the probability `p`.

- `'samples'`: an [array](https://rdrr.io/r/base/array.html) of samples
  of the long-run expeceted utilities of the actions. The first
  dimension corresponds to the actions, the second to the values of the
  conditional \\X\\, and the third the sample index.

- `'X'`, `'tails'`, `'K'`: copies of the homonymous values from the
  probability object `p`.

## Details

This function calculates...

## References

- Raiffa (1970): *Decision Analysis: Introductory Lectures on Choices
  under Uncertainty*, Addison-Wesley
  <https://archive.org/details/decisionanalysis00raif>.

- North (1968): *A Tutorial Introduction to Decision Theory*
  <doi:10.1109/TSSC.1968.300114>.

- Lindley (1988): *Making Decisions*, Wiley
  <https://www.wiley.com/Making+Decisions%2C+2nd+Edition-p-x000008175>.

- Fenton, Neil (2019): *Risk Assessment and Decision Analysis with
  Bayesian Networks*, CRC <doi:10.1201/b21982>

- Sox, Higgins, Owens, Schmidler (2024): *Medical Decision Making*,
  Wiley <doi:10.1002/9781119627876>.

- Lusted (1968): *Introduction to Medical Decision Making*, Thomas
  (Springfield, USA).

## See also

[`Pr()`](https://pglpm.github.io/prova/reference/Pr.md) to calculate
joint and conditional probabilities.

## Examples

``` r
## Load the example `K`nowledge object calculated from the "penguins" dataset;
```
