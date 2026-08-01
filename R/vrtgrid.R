#' Create a grid of values for a variate
#'
#' @description Create a data frame of values for one variate, or a combination of values for several variates.
#'
#' @details The value ranges are based on the information from data and metadata stored in the `K`nowledge object (see [learn()]) provided in the `K =` argument; they include, and extend slightly beyond, the ranges observed in the data used in the [learn()] function. Variate domains are always respected.
#'
#' The set of chosen values, for each variate, depends on the type of variate (nominal or continuous, rounded, and so on, see [metadata]):
#'
#' - For a discrete (nominal or ordinal) variate, all possible values are chosen.
#' - For a continuous, *non-rounded* variate, a number of values as specified in the `length.out` argument; or 257 values if `length.out` is missing or `NA`.
#' - For a continuous, *rounded* variate, a number of values as specified in the `length.out` argument; or, if `length.out` is missing or `NA`, the output values are separated by the variates's rounding interval (field `datastep` in the [`metadata`]).
#'
#' The output is a [data frame][base::data.frame()] that can be used directly in functions like [Pr()].
#'
#' @param vrt Character vector: names of the variates; they must match variate names in the `metadata` file provided to the [learn()] function.
#' @param K A "Knowledge" object produced by [learn()]. It can also be a path to a 'K.rds' file containing such object, or to a directory containing one.
#' @param length.out Vector or list of positive integers or `NA` values, possibly named: number of values to be created for each variate. Elements with names are used for the homonymous variates in `vrt`. Unnamed elements are used for the remaining variates, recycled as necessary. See "Details" for the meaning of `NA` values. Default `NA`.
#'
#' @return A [data frame][base::data.frame()] with columns corresponding to the `vrt` argument, and one row for each combination of the variate values.
#'
#' @seealso
#' [learn()], which generates the `K` objects required by `vrtgrid()`.
#'
#' [Pr()] to calculate probabilities and their revisabilities.
#'
#' [base::expand.grid()] to create a data frame with combination of specified values of several variates.
#'
#' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## set of values for the variate "species";
#' ## since this variate is of a nominal kind, all values are included
#' valuesSpecies <- vrtgrid(vrt = 'species', K = K)
#'
#' print(valuesSpecies)
#'
#' ## create a small set of values for the variate "bill length";
#' ## this variate is continuous and rounded
#' valuesBill <- vrtgrid(vrt = 'bill_len', K = K, length.out = 4)
#'
#' print(valuesBill)
#'
#' ## calculate the conditional probabilities for the 'bill_len' values above,
#' ## given the values of 'species'
#' probs <- Pr(Y = valuesBill, X = valuesSpecies, K = K)
#'
#'
#' ## Create a data frame with all possible combinations of the values above;
#' ## the 'length.out' argument does not apply to the discrete variate 'species'
#' valuesAll <- vrtgrid(vrt = c('species', 'bill_len'), K = K, length.out = 4)
#'
#' print(valuesAll)
#'
#' ## base::expand.grid() would give a similar result
#' valuesAll2 <- expand.grid(species = unlist(valuesSpecies), bill_len = unlist(valuesBill))
#'
#' print(valuesAll2)
#'
#' @import utils
#'
#' @concept probability
#' @export
vrtgrid <- function(
    vrt,
    K,
    length.out = NA
){
    ## default number of points for continuous non-rounded variates
    lodefault <- 129

    ## Check 'K' argument
    Kname <- deparse(substitute(K))
    K <- .retrieveK(K)
    if(is.null(K)){
        stop("Argument 'K' must be a 'Knowledge' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
    }

    ## Consistency checks
    if(!all(vrt %in% K$auxmetadata$name)){
        stop("'vrt' contains unknown variate names.")
    }

    if(is.null(names(length.out))){names(length.out) <- ''}
    inlo <- names(length.out)[names(length.out) %in% vrt]
    outlo <- vrt[!(vrt %in% inlo)]
    lo <- length.out[names(length.out) == '']
    length.out = c(length.out[inlo],
        setNames(object = rep(x = lo, length.out = length(outlo)),
            nm = outlo)
    )

    expand.grid(setNames(
        object = lapply(X = vrt, FUN = function(avrt){
    adata <- as.list(K$auxmetadata[K$auxmetadata$name == avrt, ])

    if(adata$mcmctype %in% c('R', 'C')){
        if(is.na(length.out[avrt])){length.out[avrt] <- lodefault}
        temp <- seq(adata$plotmin, adata$plotmax, length.out = length.out[avrt])
    } else if(adata$mcmctype == 'D'){
        if(is.na(length.out[avrt])){
            seq(adata$plotmin, adata$plotmax, by = 2 * adata$halfstep)
        } else {
            seq(adata$plotmin, adata$plotmax, length.out = length.out[avrt])
        }
        ## step <- as.integer(ceiling((adata$plotmax - adata$plotmin) /
        ##                                (2 * adata$halfstep)))
        ## seqstep <- seq_len(step)
        ## factors <- seqstep[!(step %% seqstep)]
        ## step <- factors[which.min(abs(factors - length.out + 1))] *
        ##     2 * adata$halfstep
        ## temp <- seq(adata$plotmin, adata$plotmax,
        ##     length.out = 1 + round((adata$plotmax - adata$plotmin)/step))
    } else if(adata$mcmctype %in% c('B', 'O', 'N')){
        unname(unlist(adata[paste0('V', seq_len(adata$Nvalues))]))
    }
        }),
    nm = vrt), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
}
