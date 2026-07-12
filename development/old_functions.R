## flexiplot <- function(
##     x, y,
##     type = 'l',
##     lty = c(1, 2, 4, 3, 6, 5),
##     lwd = 2,
##     pch = c(1, 2, 0, 5, 6, 3), #, 4,
##     col = palette(),
##     xlab = NULL, ylab = NULL,
##     xlim = NULL, ylim = NULL,
##     add = FALSE,
##     xdomain = NULL, ydomain = NULL,
##     alpha.f = 1,
##     xjitter = NULL,
##     yjitter = NULL,
##     ## c( ## Tol's colour-blind-safe scheme
##     ##     '#4477AA',
##     ##     '#EE6677',
##     ##     '#228833',
##     ##     '#CCBB44',
##     ##     '#66CCEE',
##     ##     '#AA3377' #, '#BBBBBB'
##     ## ),
##     grid = TRUE,
##     cex.main = 1,
##     ...
## ){
##     xat <- yat <- NULL
## 
##     if(missing('x') && !missing('y')){
##         x <- numeric(NROW(y))
##         if(is.null(xdomain) && is.null(xlim)){
##             xat <- 0
##             xdomain <- NA
##             if(!is.null(xjitter)){
##                 xlim <- c(-0.04, 0.04)
##             }
##             if(is.null(xlab)){ xlab <- NA }
##             if(is.null(ylab)){ ylab <- deparse1(substitute(y)) }
##         }
##     } else if(!missing('x') && missing('y')){
##         y <- numeric(NROW(x))
##         if(is.null(ydomain) && is.null(ylim)){
##             yat <- 0
##             ydomain <- NA
##             if(!is.null(yjitter)){
##                 ylim <- c(-0.04, 0.04)
##             }
##             if(is.null(ylab)){ ylab <- NA }
##             if(is.null(xlab)){ xlab <- deparse1(substitute(x)) }
##         }
##     } else if(!missing('x') && !missing('y')){
##         if(is.null(xlab)){ xlab <- deparse1(substitute(x)) }
##         if(is.null(ylab)){ ylab <- deparse1(substitute(y)) }
##     } else {
##         stop('Arguments "x" and "y" cannot both be missing')
##     }
## 
##     ## if x is character, convert to numeric
##     if(is.character(x)){
##         if(is.null(xdomain)){ xdomain <- unique(x) }
##         ## we assume the user has sorted the values in a meaningful order
##         ## because the lexical order may not be correct
##         ## (think of values like 'low', 'medium', 'high')
##         x <- as.numeric(factor(x, levels = xdomain))
##         if(is.null(xjitter)){xjitter <- TRUE}
##         xat <- seq_along(xdomain)
##     }
##     if(isTRUE(xjitter)){x <- jitter(x)}
## 
##     ## if y is character, convert to numeric
##     if(is.character(y)){
##         if(is.null(ydomain)){ ydomain <- unique(y) }
##         ## we assume the user has sorted the values in a meaningful order
##         ## because the lexical order may not be correct
##         ## (think of values like 'low', 'medium', 'high')
##         y <- as.numeric(factor(y, levels = ydomain))
##         if(is.null(yjitter)){yjitter <- TRUE}
##         yat <- seq_along(ydomain)
##     }
##     if(isTRUE(yjitter)){y <- jitter(y)}
## 
##     ## Syntax of xlim and ylim that allows
##     ## for the specification of only upper- or lower-bound
##     if(length(xlim) == 2){
##         if(is.null(xlim[1]) || !is.finite(xlim[1])){ xlim[1] <- min(x[is.finite(x)]) }
##         if(is.null(xlim[2]) || !is.finite(xlim[2])){ xlim[2] <- max(x[is.finite(x)]) }
##     }
##     if(length(ylim) == 2){
##         if(is.null(ylim[1]) || !is.finite(ylim[1])){ ylim[1] <- min(y[is.finite(y)]) }
##         if(is.null(ylim[2]) || !is.finite(ylim[2])){ ylim[2] <- max(y[is.finite(y)]) }
##     }
## 
##     if(is.null(xlab) && !missing(x)) {
##         xlab <- deparse1(substitute(x))
##     }
##     if(is.na(alpha.f)){alpha.f <- 1}
##     col <- adjustcolor(col, alpha.f = alpha.f)
## 
##     graphics::matplot(x, y, xlim = xlim, ylim = ylim, type = type, axes = F,
##         col = col, lty = lty, lwd = lwd, pch = pch, cex.main = cex.main, add = add, xlab = xlab, ylab = ylab, ...)
##     if(!add){
##         graphics::axis(1, at = xat, labels = xdomain, tick = !grid,
##             col = 'black', lwd = 1, lty = 1, ...)
##         graphics::axis(2, at = yat, labels = ydomain, tick = !grid,
##             col = 'black', lwd = 1, lty = 1, ...)
##         if(grid){
##             graphics::grid(nx = NULL, ny = NULL, lty = 1, col = '#BBBBBB80')
##         }
##     }
## }





#### Possibly for future versions
## #' Summary for an object of class 'probability'
## #'
## #' Should this be 'print'?
## #'
## #' @export
## summary.probability <- function(x, ...){print.default(x, ...)}





#### The following functions are not used for the moment,
#### but may be useful in future versions.

## #' Calculate quantile width through batches
## #'
## #' Modified from
## #' from https://github.com/LaplacesDemonR/LaplacesDemon/blob/master/R/ESS.R
## #'
## #' @param x A matrix, rows being MC samples and columns being quantities whose MCSE is to be estimated.
## #'
## #' @return Estimates of the MC standard error for each trace. Division by sqrt(N) is already performed.
## #'
## #' @import stats
## #'
## #' @keywords internal
## funMCEI <- function(x, fn, p = c(0.055, 0.945), ...) {
##     N <- length(x)
##     a <- floor(sqrt(N))
##     b <- N %/% a
##     y <- x[rep(x = seq_len(a), each = b) +
##                round(seq(from = 0, to = N-a, length.out = b))]
##     dim(y) <- c(b, a)
##     quantile(x = apply(y, 2, FUN = fn, ...),
##         probs = p, na.rm = FALSE, names = FALSE, type = 6)
## }


## #' Calculate MC effective sample size using LaplacesDemon's algorithm
## #'
## #' Modified from
## #' from https://github.com/LaplacesDemonR/LaplacesDemon/blob/master/R/ESS.R
## #'
## #' @param x A matrix, rows being MC samples and columns being quantities whose MCSE is to be estimated.
## #'
## #' @return Estimates of the effective sample size for each trace.
## #'
## #' @import stats
## #'
## #' @keywords internal
## funESSLD <- function(x){
##     x <- as.matrix(x)
##     N <- nrow(x)
##     M <- ncol(x)
##     v0 <- order <- rep(0, M)
##     names(v0) <- names(order) <- colnames(x)
##     z <- 1:N
##     for (i in 1:M) {
##         lm.out <- lm(x[, i] ~ z)
##         ## if(!isTRUE(all.equal(sd(residuals(lm.out)), 0))) {
##             ar.out <- try(ar(x[,i], aic=TRUE), silent=TRUE)
##             if(!inherits(ar.out, "try-error")) {
##                 v0[i] <- ar.out$var.pred / {1 - sum(ar.out$ar)}^2
##                 ## order[i] <- ar.out$order
##             }
##         ## }
##     }
##     ## spec <- list(spec=v0, order=order)
##     ## spec <- spec$spec
##     Y <- x - matrix(colMeans(x), N, M, byrow = TRUE)
##     temp <- N * (N * colMeans(Y * Y) / (N - 1)) / v0
##     v0[which(v0 != 0)] <- temp[which(v0 != 0)]
##     v0[which(v0 < .Machine$double.eps)] <- .Machine$double.eps
##     v0[which(v0 > N)] <- N
##     v0
## }


## #' Calculate MC standard error, from Geyer's mcmc package
## #'
## #' @param x A matrix, rows being MC samples and columns being quantities whose MCSE is to be estimated.
## #'
## #' @return Estimates of the MC standard error for each trace. Division by sqrt(N) is already performed.
## #'
## #' @keywords internal
## funMCSEGeyer <- function(x){
##     x <- as.matrix(x)
##     N <- nrow(x)
##     apply(x, 2, function(atrace){
##         sqrt(mcmc::initseq(atrace)$var.con / N)
##     })
## }

## #' Function for calculating MC standard error, from Geyer's mcmc package
## #'
## #' @param x A matrix, rows being MC samples and columns being quantities whose ESS is to be estimated.
## #'
## #' @return Estimates of ESS for each trace.
## #'
## #' @keywords internal
## funESSGeyer <- function(x){
##     x <- as.matrix(x)
##     (apply(x, 2, sd) / funMCSE2(x))^2
## }


## #### Function for calculating number of needed MCMC iterations
## #' @keywords internal
## mcmcstop <- function(
##     traces,
##     nsamples,
##     availiter,
##     relerror,
##     ## diagnESS,
##     ## diagnIAT,
##     ## diagnBMK,
##     ## diagnMCSE,
##     ## diagnStat,
##     ## diagnBurn,
##     ## diagnBurn2,
##     ## diagnThin,
##     thinning
## ) {
##     ## Based on doi.org/10.1080/10618600.2015.1044092
##
##     ## ## 'mcse' is 'w' or 'sigma/sqrt(n)' in doi.org/10.1080/10618600.2015.1044092
##     ## mcse <- funMCSE(traces)
##     ## N <- nrow(traces)
##     ## ## 'sds' is 'lambda' in doi.org/10.1080/10618600.2015.1044092
##     ## sds <- apply(traces, 2, sd)
##     ## avg <- apply(traces, 2, mean)
##
##     relmcse <- funMCSE(traces) / apply(traces, 2, sd)
##     ## relmcse2 <- (mcse + 1/N) / sds
##
##     ess <- funESS(traces)
##
##     ## autothinning <- ceiling(1.5 * nrow(traces)/ess)
##     autothinning <- ceiling(nrow(traces)/ess)
##
##     if(is.null(thinning)) {
##         thinning <- max(autothinning)
##     }
##
##     missingsamples <- thinning * (nsamples - 1) - availiter
##
##     if(max(relmcse) <= relerror) {
##         ## sampling could be stopped,
##         ## unless we still lack the required number of samples
##         reqiter <- max(0, missingsamples)
##     } else {
##         ## sampling should continue
##         reqiter <- max(ceiling(thinning * sqrt(nsamples)),
##             missingsamples)
##     }
##
##     list(
##         reqiter = reqiter,
##         proposed.thinning = thinning,
##         toprint = list(
##             'rel. MC standard error' = relmcse,
##             'eff. sample size' = ess,
##             'needed thinning' = autothinning,
##             'average' = apply(traces, 2, mean)
##         )
##     )
## }


## #### Function for calculating number of needed MCMC iterations
## #' @keywords internal
## mcmcstopess <- function(
##     traces,
##     nsamples,
##     availiter,
##     reqess,
##     ## diagnESS,
##     ## diagnIAT,
##     ## diagnBMK,
##     ## diagnMCSE,
##     ## diagnStat,
##     ## diagnBurn,
##     ## diagnBurn2,
##     ## diagnThin,
##     thinning
## ) {
##     ## Based on doi.org/10.1080/10618600.2015.1044092
##
##     ## ## 'mcse' is 'w' or 'sigma/sqrt(n)' in doi.org/10.1080/10618600.2015.1044092
##     ## mcse <- funMCSE(traces)
##     ## N <- nrow(traces)
##     ## ## 'sds' is 'lambda' in doi.org/10.1080/10618600.2015.1044092
##     ## sds <- apply(traces, 2, sd)
##     ## avg <- apply(traces, 2, mean)
##
##     relmcse <- funMCSE(traces) / apply(traces, 2, sd)
##     ## relmcse2 <- (mcse + 1/N) / sds
##
##     ess <- funESS(traces)
##
##     ## autothinning <- ceiling(1.5 * nrow(traces)/ess)
##     autothinning <- ceiling(nrow(traces)/ess)
##
##     if(is.null(thinning)) {
##         thinning <- max(autothinning)
##     }
##
##     missingsamples <- thinning * (nsamples - 1) - availiter
##     reqsamples <- thinning * (reqess + 2) - availiter
##
##     if(min(ess) >= reqess + 2) {
##         ## sampling could be stopped,
##         ## unless we still lack the required number of samples
##         reqiter <- max(0, missingsamples)
##     } else {
##         ## sampling should continue
##         reqiter <- max(reqsamples, missingsamples)
##     }
##
##     list(
##         reqiter = reqiter,
##         proposed.thinning = thinning,
##         toprint = list(
##             'rel. MC standard error' = relmcse,
##             'eff. sample size' = ess,
##             'needed thinning' = autothinning,
##             'average' = apply(traces, 2, mean)
##         )
##     )
## }







## #' Calculate collection of log-probabilities for different components and samples
## #' @return Matrix with as many rows as components and as many cols as samples
## #' @keywords internal
## util_lprobssave <- function(xVs, params, logW, temporarydir, lab) {
## 
##     out <- util_lprobsbase(xVs = xVs, params = params, logW = logW)
## 
##     saveRDS(out,
##         file.path(temporarydir,
##             paste0(lab, xVs$ii, '__.rds'))
##     )
## }











## TO BE WRITTEN
## This function checks whether data and metadata are mutually consistent.
## Below are some snippets of checks that were included in other scripts

    ## if (xinfo$type == 'binary') { # seems binary variate
    ##   if (length(unique(x)) != 2) {
    ##     cat('Warning: inconsistencies with variate', xn, '\n')
##   }
## }





#' Convert 'learnt'-object with R/C/Dvar into 'learnt'-object with R/C/Dsd
#'
#' Old versions of **Prova** (called **inferno**) used variance-parameters in the MCMC. Present versions use SD-parameters instead, making the use of 'Pr()' and its relatives faster.
#'
#' This function converts a 'learnt' object from the previous versions into a new one.
#'
#' @keywords internal
util_learntvar2sd <- function(file){
    learnt <- readRDS(file = file)
    ## Swap variances and standard deviations
    if(!is.null(learnt$Rvar)){
        learnt$Rvar <- sqrt(learnt$Rvar)
        names(learnt)[which(names(learnt) == 'Rvar')] <- 'Rsd'
    } else if(!is.null(learnt$Rsd)){
        learnt$Rsd <- learnt$Rsd^2
        names(learnt)[which(names(learnt) == 'Rsd')] <- 'Rvar'
    }
    ##
    if(!is.null(learnt$Cvar)){
        learnt$Cvar <- sqrt(learnt$Cvar)
        names(learnt)[which(names(learnt) == 'Cvar')] <- 'Csd'
    } else if(!is.null(learnt$Csd)){
        learnt$Csd <- learnt$Csd^2
        names(learnt)[which(names(learnt) == 'Csd')] <- 'Cvar'
    }
    ##
    if(!is.null(learnt$Dvar)){
        learnt$Dvar <- sqrt(learnt$Dvar)
        names(learnt)[which(names(learnt) == 'Dvar')] <- 'Dsd'
    } else if(!is.null(learnt$Dsd)){
        learnt$Dsd <- learnt$Dsd^2
        names(learnt)[which(names(learnt) == 'Dsd')] <- 'Dvar'
    }
    ##
    saveRDS(object = learnt, file = file)
}





#' Format datapoints used for MCMC monitoring
#'
#' Used in 'util_Pcheckpoints()' within 'learn()'.
#'
#' @param x Datapoints to be used for checking MCMC progress
#' @param auxmetadata auxmetadata object
#' @param pointsid Id of datapoints
#'
#' @return some arguments to be repeatedly used in util_Pcheckpoints
#'
#' @keywords internal
util_oldprepPcheckpoints <- function(
    x, auxmetadata, pointsid = NULL
){

    nX <- nrow(x)

    auxV0a <- auxV0b <- auxV1a <- auxV1b <- auxV1c <- auxV1d <- NULL
    auxV2 <- auxVNO <- auxVNN <- auxVB <- NULL
    V2steps <- NULL

    nV0 <- nV1 <- nV2 <- nVN <- nVB <- FALSE

    xV0 <- xV1 <- xV2 <- xVN <- xVB <- matrix(data = NA_real_,
        nrow = 0, ncol = nX, dimnames = NULL)

###
### point probability density
###

### R-variates not in 'cumul'
    toselect <- which(auxmetadata$mcmctype == 'R')
    if(length(toselect) > 0){
        nV0 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV0a <- aux$id
        xV0 <- rbind(xV0,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Rout = 'normalized',
                logjacobianOr = NULL
            )))
        )
    }

### C-variates not in 'cumul' and with some non-boundary value
    toselect <- which(auxmetadata$mcmctype == 'C')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] > auxmetadata$domainmin[i] &
                    x[,auxmetadata$name[i]] < auxmetadata$domainmax[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV0 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV0b <- aux$id
        xV0 <- rbind(xV0,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = 'boundisna',
                logjacobianOr = NULL
            )))
        )
    }

###
### tail probability
###

### C-variates not in 'cumul' and with left boundary values
    toselect <- which(auxmetadata$mcmctype == 'C')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] <= auxmetadata$domainmin[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV1 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV1a <- aux$id
        xV1 <- rbind(xV1,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = 'leftbound',
                logjacobianOr = NULL
            )))
        )
    }

### C-variates not in 'cumul' and with right boundary values
    toselect <- which(auxmetadata$mcmctype == 'C')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] >= auxmetadata$domainmax[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV1 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV1b <- aux$id
        xV1 <- rbind(xV1,
            - t(as.matrix(vtransform( # minus sign
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = 'rightbound',
                logjacobianOr = NULL
            )))
        )
    }

### D-variates not in 'cumul' and with left boundary values
    toselect <- which(auxmetadata$mcmctype == 'D')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] <= auxmetadata$domainminplushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV1 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV1c <- aux$id
        xV1 <- rbind(xV1,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Dout = 'leftbound',
                logjacobianOr = NULL
            )))
        )
    }

### D-variates not in 'cumul' and with right boundary values
    toselect <- which(auxmetadata$mcmctype == 'D')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] >= auxmetadata$domainmaxminushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV1 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV1d <- aux$id
        xV1 <- rbind(xV1,
            - t(as.matrix(vtransform( # minus sign
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Dout = 'rightbound',
                logjacobianOr = NULL
            )))
        )
    }

###
### interval probability
###

### D-variates not in 'cumul'
    toselect <- which(auxmetadata$mcmctype == 'D')
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] > auxmetadata$domainminplushs[i] &
                    x[,auxmetadata$name[i]] < auxmetadata$domainmaxminushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        nV2 <- TRUE
        aux <- auxmetadata[toselect, ]
        auxV2 <- aux$id
        V2steps <- aux$halfstep / aux$tscale
        xV2 <- rbind(xV2,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Dout = 'boundisna',
                logjacobianOr = NULL
            )))
        )
    }

###
### discrete case
###
    Nshift <- 0L
### O-variates not in 'cumul'
    toselect <- which(auxmetadata$mcmctype == 'O')
    if(length(toselect) > 0){
        nVN <- TRUE
        aux <- auxmetadata[toselect, ]
        auxVNO <- aux$id
        Nindices <- unlist(mapply(FUN = function(i, n) {i + seq_len(n)},
            aux$indexpos, aux$Nvalues,
            SIMPLIFY = FALSE))
        xVN <- rbind(xVN,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Oout = 'numeric',
                logjacobianOr = NULL
            ))) +
                Nshift + c(0, cumsum(aux$Nvalues[-1]))
        )
        Nshift <- Nshift + length(Nindices)
    }
### N-variates
    toselect <- which(auxmetadata$mcmctype == 'N')
    if(length(toselect) > 0){
        nVN <- TRUE
        aux <- auxmetadata[toselect, ]
        auxVNN <- aux$id
        Nindices <- unlist(mapply(FUN = function(i, n) {i + seq_len(n)},
            aux$indexpos, aux$Nvalues,
            SIMPLIFY = FALSE))
        xVN <- rbind(xVN,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Nout = 'numeric',
                logjacobianOr = NULL
            ))) +
                Nshift + c(0, cumsum(aux$Nvalues[-1]))
        )
    }

###
### binary case
###

### B-variates
    toselect <- which(auxmetadata$mcmctype == 'B')
    if(length(toselect) > 0){
        nVB <- TRUE
        aux <- auxmetadata[toselect, ]
        auxVB <- aux$id
        xVB <- rbind(xVB,
            t(as.matrix(vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Bout = 'numeric',
                logjacobianOr = NULL
            )))
        )
    }

    list(
        nV0 = nV0, nV1 = nV1, nV2 = nV2, nVN = nVN, nVB = nVB,
        ## xV0 = xV0, xV1 = xV1, xV2 = xV2, xVN = xVN, xVB = xVB,
        auxV0a = auxV0a, auxV0b = auxV0b,
        auxV1a = auxV1a, auxV1b = auxV1b, auxV1c = auxV1c, auxV1d = auxV1d,
        auxV2 = auxV2,
        auxVNO = auxVNO, auxVNN = auxVNN,
        auxVB = auxVB,
        V2steps = V2steps,
        pointsid = pointsid,
        ##
        xVs = lapply(seq_len(nX), function(i){
            list(
                xV0 = xV0[,i],
                xV1 = xV1[,i],
                xV2 = xV2[,i],
                xVN = xVN[,i],
                xVB = xVB[,i]
            )})
    )
}







#' Calculate and combine log-probabilities to compute entropies
#'
#' Calculate log2_p(Y1|Y2), log2_p(Y2|Y1), log2_p(Y1), log2_p(Y2) for one datapoint. Used in [mutualinfo()].
#'
#' @return A vector of various probabilities (calculated from all MC samples) and "limit frequencies" (calculated from the MC sample corresponding to the input datapoint).
#' @keywords internal
util_lprobsmi2 <- function(xVs, params1, params2, lW){

    thisid <- xVs[[1]] # MC-sample id of this datapoint

    lprobY1 <- util_lprobsbase(xVs = xVs[1:6], params = params1, logW = 0,
        temporarydir= NULL)
    lprobY2 <- util_lprobsbase(xVs = xVs[7:12], params = params2, logW = 0,
        temporarydir = NULL)

    lprobnorm <- util_denorm(lW) # subtract max from each prob-col. of lW
    celprobnorm <- colSums(exp(lprobnorm))

### Construct log-probabilities from lprobY1, lprobY2
    temp <- colSums(exp(lprobY1 + lprobY2 + lprobnorm)) / celprobnorm
    pY1and2 <- mean(temp, na.rm = TRUE)
    fY1and2 <- temp[thisid]

    temp <- colSums(exp(lprobY1 + lprobnorm)) / celprobnorm
    pY1 <- mean(temp, na.rm = TRUE)
    fY1 <- temp[thisid]

    temp <- colSums(exp(lprobY2 + lprobnorm)) / celprobnorm
    pY2 <- mean(temp, na.rm = TRUE)
    fY2 <- temp[thisid]

    lprobnorm <- util_denorm(lprobY2 + lW)
    temp <- colSums(exp(lprobY1 + lprobnorm)) / colSums(exp(lprobnorm))
    pY1given2 <- mean(temp, na.rm = TRUE)
    fY1given2 <- temp[thisid]

    lprobnorm <- util_denorm(lprobY1 + lW)
    temp <- colSums(exp(lprobY2 + lprobnorm)) / colSums(exp(lprobnorm))
    pY2given1 <- mean(temp, na.rm = TRUE)
    fY2given1 <- temp[thisid]

    c(
        pY1and2 = pY1and2,
        pY1given2 = pY1given2,
        pY2given1 = pY2given1,
        pY1 = pY1,
        pY2 = pY2,
        ##
        fY1and2 = fY1and2,
        fY1given2 = fY1given2,
        fY2given1 = fY2given1,
        fY1 = fY1,
        fY2 = fY2,
        id = thisid
        ## MIalt = (mi + lpY1given2 - lpY1 + lpY2given1 - lpY2) / 3,
    )
}





#' Calculate and combine log-probabilities to compute entropies
#'
#' Calculate log2_p(Y1|Y2), log2_p(Y2|Y1), log2_p(Y1), log2_p(Y2) for one datapoint. Used in [mutualinfo()].
#'
#' @keywords internal
util_lprobsmi <- function(xVs, params1, params2, lW){

    lprobY1 <- util_lprobsbase(xVs = xVs[1:6], params = params1, logW = 0,
        temporarydir= NULL)
    lprobY2 <- util_lprobsbase(xVs = xVs[7:12], params = params2, logW = 0,
        temporarydir = NULL)

    lprobnorm <- util_denorm(lW) # subtract max from each prob-col. of lW
    celprobnorm <- colSums(exp(lprobnorm))

### Construct probabilities from lprobY1, lprobY2
    lpY1and2 <- log(mean(
        colSums(exp(lprobY1 + lprobY2 + lprobnorm)) / celprobnorm,
        na.rm = TRUE))

    lpY1 <- log(mean(
        colSums(exp(lprobY1 + lprobnorm)) / celprobnorm,
        na.rm = TRUE))

    lpY2 <- log(mean(
        colSums(exp(lprobY2 + lprobnorm)) / celprobnorm,
        na.rm = TRUE))


    lprobnorm <- util_denorm(lprobY2 + lW)
    lpY1given2 <- log(mean(
        colSums(exp(lprobY1 + lprobnorm)) / colSums(exp(lprobnorm)),
        na.rm = TRUE))

    lprobnorm <- util_denorm(lprobY1 + lW)
    lpY2given1 <- log(mean(
        colSums(exp(lprobY2 + lprobnorm)) / colSums(exp(lprobnorm)),
        na.rm = TRUE))

    c(
        MI = lpY1and2 - lpY1 - lpY2,
        CondEn12 = -lpY1given2,
        CondEn21 = -lpY2given1,
        En1 = -lpY1,
        En2 = -lpY2,
        id = xVs[[1]]
        ## MIalt = (mi + lpY1given2 - lpY1 + lpY2given1 - lpY2) / 3,
    )
}
