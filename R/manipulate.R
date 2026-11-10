#' Subset variates of an object of class "prova_pr" (probability)
#'
#' @description
#' Utility function to exclude some `Y` or `X` values from an object of class "prova_pr".
#'
#' @details
#' An object of class "prova_pr" (probability), obtained with the [Pr()] function, holds the probabilities for all possible combinations of values of a set of joint variates `Y` conditional on a set of joint variates `X`, together with the revisabilities of these probabilities and some other information. In some cases one may want to exclude some of the values of the `Y` or `X` variates. For instance, `Y` in the probability-class object could include the variate "age" with values from 18 to 100, and one may want to retain only the values from 60 to 80.
#'
#' @param x Object of class "prova_pr" (probability), obtained with [Pr()].
#' @param subsetY Expression, indicating `Y` values to select from the probability-class object. Note that `subset` will be evaluated in the probability-class object, so `Y` variates can be referred to (by name) as variables in the expression (see the examples).
#' @param subsetX Expression, indicating `X` values to select from the probability-class object. Note that `select` will be evaluated in the probability-class object, so `X` variates can be referred to (by name) as variables in the expression (see the examples).
#' @param ... Not used at present, left for method compatibility with `base::subset()`.
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
#'   subsetX = bill_len == 43
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
    subsetX = TRUE,
    ...
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
#' Utility function to merge two objects of class "prova_pr" (probability), having same `Y` and `X` variates but different values.
#'
#' @details
#' This function combines two probability objects of class "prova_pr" (probability) into one. The two objects must have exactly the same sets (and ordering) of `Y` variates. They must also have the same sets (and ordering) of `X` variates, unless one or both have `NULL` `X`.
#'
#' The `Pr()` function allows to calculate point and tail probabilities for any given variate, but not both kinds at the same time. For example, `Pr()` can calculate the probability that a variate "age" is equal to 30, storing the result in a "prova_pr" probability object; or that it is larger than 35, storing the result in another probability object. But these two calculations cannot be done within one call to `Pr()`, storing both results at once in one probability object. With the `merge` function such an object can nevertheless be created from the previous two.
#'
#' If the values of the `X` variates are the same, then the probabilities corresponding to different `Y` values are concatenated. If the values of the `Y` variates are the same, then the probabilities corresponding to different `X` values are concatenated. If neither values are in common, the function throws an error.
#'
#' @param x,y Objects of class "prova_pr" (probability), obtained with [Pr()].
#' @param ... Not used, left for consistency with generic `base::merge()`.
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
#' ## Calculate the probability that bill_len <= 43
#' ## given that the species is 'Adelie':
#' probs1 <- Pr(
#'   Y = data.frame(bill_len = 43),
#'   X = data.frame(species = 'Adelie'),
#'   K = K,
#'   tails = list(bill_len = '<=')
#' )
#'
#' probs1
#'
#' ## Calculate the probability that bill_len >= 43.1
#' ## given that the species is 'Adelie':
#' probs2 <- Pr(
#'   Y = data.frame(bill_len = 43.1),
#'   X = data.frame(species = 'Adelie'),
#'   K = K,
#'   tails = list(bill_len = '>=')
#' )
#'
#' probs2
#'
#' ## Combine the two tail probabilities for bill_len in one object
#' probs <- merge(probs1, probs2)
#'
#' probs
#'
#' @concept manipulate
#' @export
merge.prova_pr <- function(x, y, ...){
    ## Check if Y and X variates are the same
    xnames <- names(dimnames(x$value))
    ynames <- names(dimnames(y$value))
    if(xnames[1] != ynames[1]){
        stop('Probabilities must have same Y variates')
    }
    if(xnames[2] != '' && ynames[2] != '' && xnames[2] != ynames[2]){
        stop('Probabilities must have same X variates')
    }

    ## ## For possible future extension: match besides a shuffle
    ## ovals <- match(do.call(paste, c(x$X, sep = '\r')),
    ##     do.call(paste, c(y$X, sep = '\r')))
    ##     if(identical(x$X, y$X[ovals, onams, drop = FALSE])){ }

    ## If same X, join Y
    if(identical(dimnames(x$value)[2], dimnames(y$value)[2])){
        ## select names for Y,X dimensions
        yxdimnames <- list(
            c(dimnames(x$value)[[1]], dimnames(y$value)[[1]]),
            dimnames(x$value)[[2]]
        )
        names(yxdimnames) <- names(dimnames(x$value))

        out <- list(value = NULL, quantiles = NULL, samples = NULL,
            value.acc = NULL, quantiles.acc = NULL)

        ## value
        temp <- rbind(x$value, y$value)
        dimnames(temp) <- yxdimnames
        out$value <- temp

        ## quantiles; check if x and y have same
        if(identical(dimnames(x$quantiles)[3], dimnames(y$quantiles)[3])){
            temp <- .learnbind(x$quantiles, y$quantiles)
            dimnames(temp) <- c(yxdimnames, dimnames(x$quantiles)[3])
            out$quantiles <- temp
        }

        ## samples; check if x and y have same
        if(identical(dimnames(x$samples)[3], dimnames(y$samples)[3])){
            temp <- .learnbind(x$samples, y$samples)
            dimnames(temp) <- c(yxdimnames, dimnames(x$samples)[3])
            out$samples <- temp
        }

        ## value.acc
        temp <- rbind(x$value.acc, y$value.acc)
        dimnames(temp) <- yxdimnames
        out$value.acc <- temp

        ## quantiles.acc; check if x and y have same
        if(identical(dimnames(x$quantiles.acc)[3], dimnames(y$quantiles.acc)[3])){
            temp <- .learnbind(x$quantiles.acc, y$quantiles.acc)
            dimnames(temp) <- c(yxdimnames, dimnames(x$quantiles.acc)[3])
            out$quantiles.acc <- temp
        }

        out$density <- c(x$density, y$density)
        out$Y = rbind(x$Y, y$Y)
        out$X = x$X
        out$tails = unique(c(x$tails, y$tails))
        out$K = x$K


        ## If same Y, join X
    } else if(identical(dimnames(x$value)[1], dimnames(y$value)[1])){
        ## select names for Y,X dimensions appropriately
        ## in case one of the Xs is NULL
        yxdimnames <- list(
            dimnames(x$value)[[1]],
            c(dimnames(x$value)[[2]], dimnames(y$value)[[2]])
        )
        names(yxdimnames) <- (if(ynames[2] == ''){
            names(dimnames(x$value))
        } else {
            names(dimnames(y$value))
        })

        out <- list(value = NULL, quantiles = NULL, samples = NULL,
            value.acc = NULL, quantiles.acc = NULL)

        ## value
        temp <- cbind(x$value, y$value)
        dimnames(temp) <- yxdimnames
        out$value <- temp

        ## quantiles; check if x and y have same
        if(identical(dimnames(x$quantiles)[3], dimnames(y$quantiles)[3])){
            temp <- .learnbind2(x$quantiles, y$quantiles)
            dimnames(temp) <- c(yxdimnames, dimnames(x$quantiles)[3])
            out$quantiles <- temp
        }

        ## samples; check if x and y have same
        if(identical(dimnames(x$samples)[3], dimnames(y$samples)[3])){
            temp <- .learnbind2(x$samples, y$samples)
            dimnames(temp) <- c(yxdimnames, dimnames(x$samples)[3])
            out$samples <- temp
        }

        ## value.acc
        temp <- cbind(x$value.acc, y$value.acc)
        dimnames(temp) <- yxdimnames
        out$value.acc <- temp

        ## quantiles.acc; check if x and y have same
        if(identical(dimnames(x$quantiles.acc)[3], dimnames(y$quantiles.acc)[3])){
            temp <- .learnbind2(x$quantiles.acc, y$quantiles.acc)
            dimnames(temp) <- c(yxdimnames, dimnames(x$quantiles.acc)[3])
            out$quantiles.acc <- temp
        }

        out$density <- x$density
        out$Y = x$Y
        out$X = rbind(x$X, y$X)
        colnames(out$X) <- (if(ynames[2] == ''){
            colnames(x$X)
        } else {
            colnames(y$X)
        })
        out$tails = unique(c(x$tails, y$tails))
        out$K = x$K

    } else {
        stop('Neither the values of Y variates nor of X variates are identical')
    }

    class(out) <- 'prova_pr'
    out
}
