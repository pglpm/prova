#' Create a grid of values for a variate
#'
#' This function creates a set of values for a variate, based on the information from data and metadata stored in a `learnt` object, created by the [learn()] function. The set of values depends on the type of variate (nominal or continuous, rounded, and so on, see [metadata]). The range of values is chosen to include, and extend slightly beyond, the range observed in the data used in the [learn()] function. Variate domains are always respected. The output can be used directly in functions like [Pr()] or together with [base::expand.grid()] to create combinations of values of joint variates.
#'
#' @param vrt Character: name of the variate, must match one of the names in the `metadata` file provided to the [learn()] function.
#' @param learnt Either a character with the name of a directory or full path for a 'learnt.rds' object, produced by the [learn()] function, or such an object itself.
#' @param length.out Numeric positive, or `NULL` (default): number of values to be created; used only for continuous variates (see [`metadata`]). If this argument is `NULL` and the variate is not rounded, then the number of output values is 129; if the variate is rounded, then the output values are separated by the variates's rounding interval (field `datastep` in the [`metadata`]).
#' @param out Desired class of the returned value, entered directly or as character; default `list`. Other useful choices could be [`data.frame`][base::data.frame()], [`c`][base::c()], [`cbind`][base::cbind()], [`rbind`][base::rbind()].
#'
#' @return By default, a named list of values of the `vrt` variate, having that variate name. More generally, a collection of values of class indicated by the `out =` argument, named by the requested variate if naming makes sense for that class.
#'
#' @seealso
#' [learn()], which generates the `learnt` objects required by `vrtgrid()`.
#'
#' [Pr()] to calculate probabilities and their revisabilities.
#'
#' [pexpand.grid()] to create a data frame with combination of values of several variates.
#'
#' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()`.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## set of values for the variate "species";
#' ## since this variate is of a nominal kind, all values are included
#' valuesSpecies <- vrtgrid(vrt = 'species', learnt = learnt)
#'
#' print(valuesSpecies)
#'
#' ## create a small set of values for the variate "bill length";
#' ## this variate is continuous and rounded
#' valuesBill <- vrtgrid(vrt = 'bill_len', learnt = learnt, length.out = 65)
#'
#' range(valuesBill)
#'
#' ## calculate the conditional probabilities for the 'bill_len' values above,
#' ## given the values of 'species'
#' probs <- Pr(Y = valuesBill, X = valuesSpecies, learnt = learnt, parallel = 1)
#'
#' ## plot the conditional probability distributions, and their revisabilities
#' plot(probs)
#'
#' @import utils
#'
#' @concept probability
#' @export
vrtgrid <- function(
    vrt,
    learnt,
    length.out = NULL,
    out = list
){
    ## Extract auxmetadata
    ## If learnt is a string, check if it's a folder name or file name
    if (is.character(learnt)) {
        ## Check if 'learnt' is a folder containing learnt.rds
        if (file_test('-d', learnt) &&
                file.exists(file.path(learnt, 'learnt.rds'))) {
            learnt <- readRDS(file.path(learnt, 'learnt.rds'))
        } else {
            ## Assume 'learnt' the full path of learnt.rds
            ## possibly without the file extension '.rds'
            learnt <- paste0(sub('.rds$', '', learnt), '.rds')
            if (file.exists(learnt)) {
                learnt <- readRDS(learnt)
            } else {
                stop('The argument "learnt" must be a folder containing learnt.rds, or the path to an rds-file containing the output from "learn()".')
            }
        }
    }

    ## Consistency checks
    if(!(vrt %in% learnt$auxmetadata$name)){
        stop("Variate '", vrt, "' not present in the list of variates.")
    }

    adata <- as.list(learnt$auxmetadata[learnt$auxmetadata$name == vrt, ])

    if(adata$mcmctype %in% c('R', 'C')){
        if(is.null(length.out)){length.out <- 129}
        temp <- list(seq(adata$plotmin, adata$plotmax, length.out = length.out))
    } else if(adata$mcmctype == 'D'){
        if(is.null(length.out)){
            temp <- list(seq(adata$plotmin, adata$plotmax,
                by = 2 * adata$halfstep))
        } else {
            temp <- list(seq(adata$plotmin, adata$plotmax,
                length.out = length.out))
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
        temp <- list(unname(unlist(adata[paste0('V', seq_len(adata$Nvalues))])))
    } else {
        stop('Unknown variate type for "', vrt, '".')
    }

    if(!(identical(out, `c`) || identical(out, 'c'))){
        names(temp) <- vrt
    }
    do.call(out, temp)
}



#' Create a data frame from all combinations of variate values
#'
#' This convenience function is just a wrapper around [base::expand.grid()], with its arguments `KEEP.OUT.ATTRS` and `stringsAsFactors` set to `FALSE`, so as to create a data frame that can be used with **Prova** functions like [Pr()]. It creates a data frame from all combinations of the supplied variates. See [base::expand.grid()] for further details.
#'
#' @param ... Character: name of the variate, must match one of the names in the `metadata` file provided to the [learn()] function.
#' @param learnt Either a character with the name of a directory or full path for a 'learnt.rds' object, produced by the [learn()] function, or such an object itself.
#' @param length.out Numeric positive, or `NULL` (default): number of values to be created; used only for continuous variates (see [`metadata`]). If this argument is `NULL` and the variate is not rounded, then the number of output values is 129; if the variate is rounded, then the output values are separated by the variates's rounding interval (field `datastep` in the [`metadata`]).
#' @param out Desired class of the returned value, entered directly or as character; default `list`. Other useful choices could be [`data.frame`][base::data.frame()], [`c`][base::c()], [`cbind`][base::cbind()], [`rbind`][base::rbind()].
#'
#' @return By default, a named list of values of the `vrt` variate, having that variate name. More generally, a collection of values of class indicated by the `out =` argument, named by the requested variate if naming makes sense for that class.
#'
#' @seealso
#' [learn()], which generates the `learnt` objects required by `vrtgrid()`.
#'
#' [Pr()] to calculate probabilities and their revisabilities.
#'
#' [pexpand.grid()] to create a data frame with combination of values of several variates.
#'
#' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()`.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## set of values for the variate "species";
#' ## since this variate is of a nominal kind, all values are included
#' valuesSpecies <- vrtgrid(vrt = 'species', learnt = learnt)
#'
#' print(valuesSpecies)
#'
#' ## create a small set of values for the variate "bill length";
#' ## this variate is continuous and rounded
#' valuesBill <- vrtgrid(vrt = 'bill_len', learnt = learnt, length.out = 65)
#'
#' range(valuesBill)
#'
#' ## calculate the conditional probabilities for the 'bill_len' values above,
#' ## given the values of 'species'
#' probs <- Pr(Y = valuesBill, X = valuesSpecies, learnt = learnt, parallel = 1)
#'
#' ## plot the conditional probability distributions, and their revisabilities
#' plot(probs)
#'
#' @import utils
#'
#' @concept probability
#' @export
pexpand.grid <- function(...){
    expand.grid(..., KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
}
