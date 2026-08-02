#' Calculate expected utilities and their uncertainties
#'
#' @description This functions calculates the expected utilities of each action or decision corresponding to a given utility matrix. The long-run probable utilities are also calculated.
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
#' - `'samples'`: an [array][base::array()] of samples of the expeceted utilities that the actions would have, if many more sample data were available. The first dimension corresponds to the actions, the second to the values of the conditional \eqn{X}, and the third the sample index.
#' - `'value.acc'`: numerical accuracies of `'value'` elements.
#' - `'optimal`': [list][base::list()] of actions having maximal expected utility, one list element per column of `p` (that is, its conditional values `X`). If there are ties, all actions in the tie are reported.
#' - `'optimal.samples'`: [matrix][base::matrix()] of samples of actions having maximal expected utility, if many more sample data were available. Each row correspond to a column of `p` (that is, its conditional values `X`); each column is a sample. In case of ties, one action is unsystematically selected via [base::sample()].
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
#' ## Use the example "Knowledge" object 'Kexample'
#' ## calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#'
#' ## define a utility matrix with four actions,
#' ## and outcomes depending on the variate 'species'
#' umatrix <- matrix(c(
#'  1.80, 0.42, 1.60, -0.12, -1.10, 0.20, -0.51, 0.35, -0.49, 0.35, -0.48, 0.62
#'  ), nrow = 4, ncol = 3, dimnames = list(paste0('action', 1:4), NULL))
#'
#' print(umatrix)
#'
#' ## Calculate the probability of the 'species outcomes
#' probs <- Pr(data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
#'   Kexample)
#'
#' ## Calculate the expected utilities of the actions
#' eu <- exputility(umatrix, probs)
#'
#' eu$value
#'
#' ## optimal action:
#' eu$optimal
#'
#' ## Tabulate probabilities of what optimal action would be
#' ## if many more sample data were available
#' signif(table(eu$optimal.samples)/ncol(eu$optimal.samples), 2)
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

    anames <- rownames(u)
    if(is.null(anames)){
        anames <- seq_len(nrow(u))
        rownames(u) <- anames
    }

    value <- u %*% p[['value']]

    samples <- p[['samples']]
    temp <- dim(samples)[-1]
    temp2 <- dimnames(samples)[-1]
    dim(samples) <- c(dim(samples)[1], prod(temp))
    samples <- u %*% samples
    dim(samples) <- c(nrow(u), temp)
    dimnames(samples) <- c(list(anames), temp2)

    osamples <- anames[c(
        apply(X = samples, MARGIN = c(2, 3),
            FUN = function(xx){sample(
                x = rep.int(x = which(xx == max(xx, na.rm = TRUE)),
                    times = 2),
                size = 1, replace = FALSE, prob = NULL)}, simplify = TRUE)
    )]
    dim(osamples) <- dim(samples)[-1]
    dimnames(osamples) <- dimnames(samples)[-1]

    out <- c(
        list(
            value = value,
            value.acc = abs(u) %*% p[['value.acc']],
            samples = samples,
            optimal = apply(X = value, MARGIN = 2,
                FUN = function(xx){anames[which(xx == max(xx, na.rm = TRUE))]},
                simplify = FALSE),
            optimal.samples = osamples
        ),
        p[c('X', 'tails', 'K')]
    )

    class(out) <- 'eutility'
    out
}
