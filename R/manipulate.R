#' Subset variates of an object of class "prova_pr" (probability)
#'
#' @description
#' A utility function to exclude some `Y` or `X` values from an object of class "prova_pr".
#'
#' @details
#' An object of class "prova_pr" (probability), obtained with the [Pr()] function, holds the probabilities for all possible combinations of values of a set of joint variates `Y` conditional on a set of joint variates `X`, together with the revisabilities of these probabilities and some other information. In some cases one may want to exclude some of the values of the `Y` or `X` variates. For instance, `Y` in the probability-class object could include the variate "age" with values from 18 to 100, and one may want to retain only the values from 60 to 80.
#'
#' @param x Object of class "prova_pr" (probability), obtained with [Pr()].
#' @param subsetY Expression, indicating `Y` values to select from the probability-class object. Note that `subset` will be evaluated in the probability-class object, so `Y` variates can be referred to (by name) as variables in the expression (see the examples).
#' @param subsetX Expression, indicating `X` values to select from the probability-class object. Note that `select` will be evaluated in the probability-class object, so `X` variates can be referred to (by name) as variables in the expression (see the examples).
#'
#' @return An object of class "prova_pr" (probability), identical to the original object `x` except for a reduced range of values in some if its `Y` or `X` variates
#'
#' @seealso
#' [Pr()], to generate probability objects.
#'
#' [merge.prova_pr()], to merge two probability objects.
#'
#' [plot.prova_pr()] to plot probabilities and quantiles calculated by `Pr()'.
#'
#' [hist.prova_pr()] to plot histograms of the probability distributions calculated by `Pr()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## Calculate the probability object for the three values of variate 'species',
#' ## given values 43 and 44 of variate 'bill_len';
#' ## this object contains probabilities, quantiles, and other information
#' probs <- Pr(
#'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
#'   X = data.frame(bill_len = c(43, 44)),
#'   K = K
#' )
#'
#' probs$value
#'
#' ## Subset by retaining the values 'Adelie' and 'Gentoo' for species,
#' ## and 44 for bill length
#' newprobs <- subset(
#'   probs,
#'   subsetY = species %in% c('Adelie', 'Gentoo'),
#'   subsetX = bill_len == 43)
#' )
#'
#' newprobs$value
#'
#' ## Plot these conditional probabilities and their revisabilities
#' plot(newprobs)
#'
#' hist(newprobs)
#'
#' @concept manipulate
#' @export
subset.prova_pr <- function(
    x,
    subsetY = TRUE,
    subsetX = TRUE
){
    totakeY <- eval(substitute(subsetY), x$Y, parent.frame())
    totakeX <- eval(substitute(subsetX), x$X, parent.frame())
    out <- list(
        value = x$value[totakeY, totakeX, drop = FALSE],
        quantiles = x$quantiles[totakeY, totakeX, , drop = FALSE],
        samples = x$samples[totakeY, totakeX, , drop = FALSE],
        value.acc = x$value.acc[totakeY, totakeX, drop = FALSE],
        quantiles.acc = x$quantiles.acc[totakeY, totakeX, , drop = FALSE],
        density = x$density[totakeY, drop = FALSE],
        Y = x$Y[totakeY, , drop = FALSE],
        X = x$X[totakeX, , drop = FALSE],
        tails = x$tails,
        K = x$K
    )
    class(out) <- 'prova_pr'
    out
}


#' Merge two objects of class "prova_pr" (probability)
#'
#' @description
#' A utility function to merge two objects of class "prova_pr" (probability).
#'
#' @details
#' This function combines two objects of class "prova_pr" (probability) into one. The two objects must have exactly the same sets (and ordering) of `Y` variates. They must also have the same sets (and ordering) of `X` variates, unless one or both have `NULL` `X`.
#'
#' If the values of the `X` variates are the same, then the probabilities corresponding to different `Y` values are concatenated. If the values of the `Y` variates are the same, then the probabilities corresponding to different `X` values are concatenated. If neither values are in common, the function throws an error.
#'
#' @param x,y Objects of class "prova_pr" (probability), obtained with [Pr()].
#'
#' @return An object of class "prova_pr" (probability), concatenating the `x` and `y` objects either along the `Y` values or along the `X` values.
#'
#' @seealso
#' [Pr()], to generate probability objects.
#'
#' [subset.prova_pr()], to subset a probability object.
#'
#' [plot.prova_pr()] to plot probabilities and quantiles calculated by `Pr()'.
#'
#' [hist.prova_pr()] to plot histograms of the probability distributions calculated by `Pr()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## Calculate the probability object for the three values of variate 'species',
#' ## given values 43 and 44 of variate 'bill_len';
#' ## this object contains probabilities, quantiles, and other information
#' probs <- Pr(
#'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
#'   X = data.frame(bill_len = c(43, 44)),
#'   K = K
#' )
#'
#' probs$value
#'
#' ## Same, but given values 45 of variate 'bill_len';
#' probs2 <- Pr(
#'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
#'   X = data.frame(bill_len = 45),
#'   K = K
#' )
#'
#' probs2$value
#'
#' ## Merge the two probability objects, combining their X values
#' newprobs <- merge(probs, probs2)
#'
#' newprobs$value
#'
#' @concept manipulate
#' @export
merge.prova_pr <- function(x, y){
    ## Check if Y and X variates are the same
    xnames <- names(dimnames(x$value))
    ynames <- names(dimnames(y$value))
    if(!identical(xnames[1], ynames[1]) && (!identical(xnames[2], ynames[2]) ||
               !identical(xnames[2], '') || !identical(ynames[2], ''))){
        stop('Mismatch between Y and X variates')
    }

    ## ## For possible future extension: match besides a shuffle
    ## ovals <- match(do.call(paste, c(x$X, sep = '\r')),
    ##     do.call(paste, c(y$X, sep = '\r')))
    ##     if(identical(x$X, y$X[ovals, onams, drop = FALSE])){ }

    ## If same X, join Y
    ## xaddname <- NULL
    ## yaddname <- NULL
    if(identical(x$X, y$X)){
        tobind <- `rbind`
        tolearnbind <- `.learnbind`
        toindex <- 1
    } else {
        tobind <- `cbind`
        tolearnbind <- `.learnbind2`
        toindex <- 2
        ## if(identical(xnames[2], '')){xaddname <- ''}
        ## if(identical(ynames[2], '')){yaddname <- ''}
    }
    out <- list(
        value = {temp <- tobind(x$value, y$value)
            if(toindex == 2){
                if(identical(ynames[2], '')){
                    names(dimnames(temp)) <- names(dimnames(x$value))
                } else {
                    names(dimnames(temp)) <- names(dimnames(y$value))
                }
            }
            temp},

        quantiles = (if(
            identical(dimnames(x$quantiles)[3], dimnames(y$quantiles)[3])
        ){
            if(toindex == 2){
                if(identical(ynames[2], '')){
                    temp <- dimnames(x$quantiles)
                } else {
                    temp <- dimnames(y$quantiles)
                }
            }
            temp[toindex] <- list(c(dimnames(x$quantiles)[[toindex]], 
                dimnames(y$quantiles)[[toindex]]))
            temp2 <- tolearnbind(x$quantiles, y$quantiles)
            dimnames(temp2) <- temp
            temp2
        } else {
            NULL
        }),

        samples = (if(
            identical(dimnames(x$samples)[3], dimnames(y$samples)[3])
        ){
            if(toindex == 2){
                if(identical(ynames[2], '')){
                    temp <- dimnames(x$samples)
                } else {
                    temp <- dimnames(y$samples)
                }
            }
            temp[toindex] <- list(c(dimnames(x$samples)[[toindex]],
                dimnames(y$samples)[[toindex]]))
            temp2 <- tolearnbind(x$samples, y$samples)
            dimnames(temp2) <- temp
            temp2
        } else {
            NULL
        }),

        value.acc = {temp <- tobind(x$value.acc, y$value.acc)
            if(toindex == 2){
                if(identical(ynames[2], '')){
                    names(dimnames(temp)) <- names(dimnames(x$value.acc))
                } else {
                    names(dimnames(temp)) <- names(dimnames(y$value.acc))
                }
            }
            temp},

        quantiles.acc = (if(
            identical(dimnames(x$quantiles.acc)[3], dimnames(y$quantiles.acc)[3])
        ){
            if(toindex == 2){
                if(identical(ynames[2], '')){
                    temp <- dimnames(x$quantiles.acc)
                } else {
                    temp <- dimnames(y$quantiles.acc)
                }
            }
            temp[toindex] <- list(c(dimnames(x$quantiles.acc)[[toindex]],
                dimnames(y$quantiles.acc)[[toindex]]))
            temp2 <- tolearnbind(x$quantiles.acc, y$quantiles.acc)
            dimnames(temp2) <- temp
            temp2
        } else {
            NULL
        }),

        density = c(x$density, if(toindex == 1){y$density}),
        Y = (if(toindex == 1){rbind(x$Y, y$Y)}else{x$Y}),
        X = (if(toindex == 2){rbind(x$X, y$X)}else{x$X}),
        tails = unique(c(x$tails, y$tails)),
        K = x$K
    )
    class(out) <- 'prova_pr'
    out
}
