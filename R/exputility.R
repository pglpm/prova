#' Calculate expected utilities and their uncertainties
#'
#' @description This functions calculates the expected utilities of each action or decision corresponding to a given utility matrix. The long-run utilities are also calculated.
#'
#' @details This function calculates...
#'
#' @param u a utility matrix given as a [base::matrix()] or as a [base::data.frame()] (internally converted into a matrix). Each row of the matrix corresponds to a possible action; each row to an uncertain outcome \eqn{Y}. The number of columns must be equal to the number of \eqn{Y}-values of the "probability" object of argument `p`.
#'
#' @param p A "probability" object, obtained from [Pr()]. The number of \eqn{Y}-values of this object must be equal to the number of columens of the utility matrix of argument `um`.
#'
#' @return A [list][base::list()]  of the following elements:
#'
#' - `'value'`: a [matrix][base::matrix()] of the expected utilities of the actions. One row for each action, one column for each value of the conditional \eqn{X} in the probability `p`.
# #' - `'quantiles'`:...
#' - `'samples'`: an [array][base::array()] of samples of the long-run expeceted utilities of the actions. The first dimension corresponds to the actions, the second to the values of the conditional \eqn{X}, and the third the sample index.
# #' - `'value.acc'`, `quantiles.acc`:...
#' - `'X'`, `'tails'`, `'K'`: copies of the homonymous values from the probability object `p`.
#'
#' @references
#'
#' - Raiffa (1970): *Decision Analysis: Introductory Lectures on Choices under Uncertainty*, Addison-Wesley <https://archive.org/details/decisionanalysis00raif>.
#' - North (1968): *A Tutorial Introduction to Decision Theory* <doi:10.1109/TSSC.1968.300114>.
#' - Lindley (1988): *Making Decisions*, Wiley <https://www.wiley.com/Making+Decisions%2C+2nd+Edition-p-x000008175>.
#' - Fenton, Neil (2019): *Risk Assessment and Decision Analysis with Bayesian Networks*, CRC <doi:10.1201/b21982>
#' - Sox, Higgins, Owens, Schmidler (2024): *Medical Decision Making*, Wiley <doi:10.1002/9781119627876>.
#' - Lusted (1968): *Introduction to Medical Decision Making*, Thomas (Springfield, USA).
#'
#' @seealso
#' [Pr()] to calculate joint and conditional probabilities.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#'
#' @concept utility
#' @export
exputility <- function(
    u,
    p
){
    ## example reversal
    ## 0.47 -0.15  2.0
    ## 0.30  2.00 -0.7
    if(!inherits(p, 'probability')){
        stop("Argument 'p' is not an object of class 'probability'.")
    }
    if(length(dim(u)) != 2){
        stop("Argument 'u' must be a utility matrix.")
    }
    if(ncol(u) != nrow(p[['value']])){
        stop("Number of columns of 'u' and number of Y-values of 'p' must be the same.")
    }

    value <- u %*% p[['value']]

    ps <- p[['samples']]
    temp <- dim(ps)[-1]
    dim(ps) <- c(dim(ps)[1], prod(temp))
    samples <- u %*% ps
    dim(samples) <- c(nrow(u), temp)

    out <- c(
        list(
            value = value,
            samples = samples
        ),
        p[c('X', 'tails', 'K')]
    )

    class(out) <- 'eutility'
    out
}
