# Calculate expected utilities and their uncertainties

This functions calculates the expected utilities of each action or
decision corresponding to a given utility matrix. The long-run probable
utilities are also calculated.

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
  \\Y\\-values of the "prova_pr" (probability) object of argument `p`.

- p:

  A "prova_pr" (probability) object, obtained from
  [`Pr()`](https://pglpm.github.io/prova/reference/Pr.md). The number of
  \\Y\\-values of this object must be equal to the number of columens of
  the utility matrix of argument `um`.

## Value

A [list](https://rdrr.io/r/base/list.html) of the following elements:

- `'value'`: a [matrix](https://rdrr.io/r/base/matrix.html) of the
  expected utilities of the actions. One row for each action, one column
  for each value of the conditional \\X\\ in the probability `p`.

- `'samples'`: an [array](https://rdrr.io/r/base/array.html) of samples
  of the expeceted utilities that the actions would have, if many more
  sample data were available. The first dimension corresponds to the
  actions, the second to the values of the conditional \\X\\, and the
  third the sample index.

- `'value.acc'`: numerical accuracies of `'value'` elements.

- `'optimal`': [list](https://rdrr.io/r/base/list.html) of actions
  having maximal expected utility, one list element per column of `p`
  (that is, its conditional values `X`). If there are ties, all actions
  in the tie are reported.

- `'optimal.samples'`: [matrix](https://rdrr.io/r/base/matrix.html) with
  the probabilities that each action would be chosen as the optimal one,
  if more data were available. One row for each action, one column for
  each column of `p` (that is, its conditional values `X`).

- `'optimal.samples'`: [matrix](https://rdrr.io/r/base/matrix.html) of
  samples of actions having maximal expected utility, if many more
  sample data were available. Each row correspond to a column of `p`
  (that is, its conditional values `X`); each column is a sample. In
  case of ties, one action is unsystematically selected via
  [`base::sample()`](https://rdrr.io/r/base/sample.html).

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
## Use the example "prova_K" (knowledge) object 'Kexample'
## calculated from the "penguins" dataset;
## variates: 'species' and 'bill_len'

## define a utility matrix with four actions,
## and outcomes depending on the variate 'species'
umatrix <- matrix(c(
 1.80, 0.42, 1.60, -0.12, -1.10, 0.20, -0.51, 0.35, -0.49, 0.35, -0.48, 0.62
 ), nrow = 4, ncol = 3, dimnames = list(actions = paste0('A', 1:4), NULL))

print(umatrix)
#>        
#> actions  [,1]  [,2]  [,3]
#>      A1  1.80 -1.10 -0.49
#>      A2  0.42  0.20  0.35
#>      A3  1.60 -0.51 -0.48
#>      A4 -0.12  0.35  0.62

## Calculate the probability of the 'species outcomes
probs <- Pr(data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
  Kexample)

## Calculate the expected utilities of the actions
eu <- exputility(umatrix, probs)

eu$value
#>        
#> actions      [,1]
#>      A1 0.3981347
#>      A2 0.3510855
#>      A3 0.4306723
#>      A4 0.2403208

## optimal action:
eu$optimal
#> [[1]]
#> [1] "A3"
#> 

## Probabilities for the actions to be judged as optimal
## if many more sample data were available
eu$optimal.probs
#>        
#> actions       [,1]
#>      A1 0.01333333
#>      A2 0.05777778
#>      A3 0.92888889
#>      A4 0.00000000
```
