#' Calculate expected utilities and their uncertainties
#'
#' @description Calculate...
#'
#' @details This function calculates...
#'
#' @param um utility matrix
#'
#' @param p "probability" object
#'
#' @return An object with ...
#'
#' - `'value'`:...
#' - `'quantiles'`:...
#' - `'samples'`:...
#' - `'value.acc'`, `quantiles.acc`:...
#' - `'K'`: name of the "Knowledge" object used in the calculation.
#'
#' @references
#'
#' - Lindley, Novick (1981): *The role of exchangeability in inference*, <doi:10.1214/aos/1176345331>.
#'
#' @seealso
#' [learn()], which generates the `K`nowledge objects required by `Pr()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#'
#' @concept utility
#' @export
eutility <- function(
    um,
    p
){
    ## example reversal
    ## 0.47 -0.15  2.0
    ## 0.30  2.00 -0.7
    value <- um %*% p[['value']]

    ps <- p[['samples']]
    temp <- dim(ps)[-1]
    dim(ps) <- c(dim(ps)[1], prod(temp))
    samples <- um %*% ps
    dim(samples) <- c(nrow(um), temp)

    list(
        value = value,
        samples = samples
    )
}
