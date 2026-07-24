#' Create a grid of values for a variate
#'
#' @description This function creates a data frame of values for one variate, or a combination of values for several variates.
#'
#' @details The value ranges are based on the information from data and metadata stored in the `learnt` object (see [learn()]) provided in the `learnt =` argument; they include, and extend slightly beyond, the ranges observed in the data used in the [learn()] function. Variate domains are always respected.
#'
#' The set of chosen values, for each variate, depends on the type of variate (nominal or continuous, rounded, and so on, see [metadata]):
#'
#' - For a discrete (nominal or ordinal) variate, all possible values are chosen.
#' - For a continuous, *non-rounded* variate, a number of values as specified in the `length.out` argument; or 129 values if `length.out` is missing or `NA`.
#' - For a continuous, *rounded* variate, a number of values as specified in the `length.out` argument; or, if `length.out` is missing or `NA`, the output values are separated by the variates's rounding interval (field `datastep` in the [`metadata`]).
#'
#' The output is a [data frame][base::data.frame()] that can be used directly in functions like [Pr()].
#'
#' @param vrt Character vector: names of the variates; they must match variate names in the `metadata` file provided to the [learn()] function.
#' @param learnt Either a character with the name of a directory or full path for a 'learnt.rds' object, produced by the [learn()] function, or such an object itself.
#' @param length.out Vector or list with positive integer values, or `NA` (default): number of values to be created; used only for continuous variates; see "Details". If `length.out` has names, the value under the corresponding name is used for each variate; otherwise, the values in `length.out` are used in the order given and recycled if necessary.
#' @param out Desired class of the returned value, entered directly or as character; default `list`. Other useful choices could be [`data.frame`][base::data.frame()], [`c`][base::c()], [`cbind`][base::cbind()], [`rbind`][base::rbind()].
#'
#' @return A [data frame][base::data.frame()] with columns corresponding to the `vrt` argument, and one row for each combination of the variate values.
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
#' valuesBill <- vrtgrid(vrt = 'bill_len', learnt = learnt, length.out = 5)
#'
#' print(valuesBill)
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
    length.out = NA
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
    if(!all(vrt %in% learnt$auxmetadata$name)){
        stop("'vrt' contains unknown variate names.")
    }

    if(is.null(names(length.out))){
        if(length(length.out) != length(vrt)){
            length.out <- rep(x = length.out, length.out = length(vrt))
        }
        names(length.out) <- vrt
    } else if(!all(names(length.out) %in% vrt)){
                stop("Missing variates in 'length.out'.")
    }

    expand.grid(setNames(
        object = lapply(X = vrt, FUN = function(avrt){
    adata <- as.list(learnt$auxmetadata[learnt$auxmetadata$name == avrt, ])

    if(adata$mcmctype %in% c('R', 'C')){
        if(is.na(length.out[avrt])){length.out[avrt] <- 129}
        temp <- seq(adata$plotmin, adata$plotmax, length.out = length.out[avrt])
    } else if(adata$mcmctype == 'D'){
        if(is.na(length.out[avrt])){
            temp <- seq(adata$plotmin, adata$plotmax, by = 2 * adata$halfstep)
        } else {
            temp <- seq(adata$plotmin, adata$plotmax, length.out = length.out[avrt])
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
        temp <- unname(unlist(adata[paste0('V', seq_len(adata$Nvalues))]))
    }
        }),
    nm = vrt), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
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
