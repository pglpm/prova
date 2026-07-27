#' Prepare arguments for util_lprobsyx from data
#'
#' Used in [Pr()], [qPr()], [rPr()], [mutualinfo()]
#'
#' @keywords internal
.lprobsargsyx <- function(
    x, auxmetadata, K, tails = NULL, ids = seq_len(nrow(x))
) {
    Xv <- colnames(x)
    nX <- nrow(x)
    tailsv <- names(tails)

    xV0 <- xV1 <- xV2 <- xVN <- xVB <- matrix(NA_real_, 0, nX)

###
### point probability density
###
    nV0 <- FALSE
    V0mean <- V0sd <- NULL

### R-variates not in 'tails'
    toselect <- which((auxmetadata$name %in% Xv) &
                          !(auxmetadata$name %in% tailsv) &
                          (auxmetadata$mcmctype == 'R'))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV0 <- TRUE
        V0mean <- .learnbind(V0mean,
            K$Rmean[aux$id, , , drop = FALSE])
        V0sd <- .learnbind(V0sd,
            K$Rsd[aux$id, , , drop = FALSE])
        xV0 <- rbind(xV0,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Rout = 'normalized',
                logjacobianOr = NULL
            )))
        )
    }

### C-variates not in 'tails' and with some non-boundary value
    toselect <- which((auxmetadata$name %in% Xv) &
                          !(auxmetadata$name %in% tailsv) &
                          (auxmetadata$mcmctype == 'C'))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            xx <- x[,auxmetadata$name[i]]
            any(xx > auxmetadata$domainmin[i] & xx < auxmetadata$domainmax[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV0 <- TRUE
        V0mean <- .learnbind(V0mean,
            K$Cmean[aux$id, , , drop = FALSE])
        V0sd <- .learnbind(V0sd,
            K$Csd[aux$id, , , drop = FALSE])
        xV0 <- rbind(xV0,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = 'boundisna',
                logjacobianOr = NULL
            )))
        )
    }
    xV0 <- unname(xV0)

###
### tail probability
###
    nV1 <- FALSE
    V1mean <- V1sd <- NULL

### R-variates in 'tails'
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'R') &
                          (auxmetadata$name %in% tailsv))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean,
                tails[aux$name] * K$Rmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd,
            K$Rsd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
            tails[aux$name] *
                t(as.matrix(.vtransform(
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Rout = 'normalized',
                    logjacobianOr = NULL
                )))
        )
    }

### C-variates in left tails
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'C') &
                          (auxmetadata$name %in% tailsv) &
                          (tails[auxmetadata$name] == 1) )
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean, K$Cmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd, K$Csd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = '1',
                logjacobianOr = NULL
            )))
        )
    }

### C-variates in right tails
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'C') &
                          (auxmetadata$name %in% tailsv) &
                          (tails[auxmetadata$name] == -1) )
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        ## note the minus!
        V1mean <- .learnbind(V1mean, -K$Cmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd, K$Csd[aux$id, , , drop = FALSE])
        ## note the minus!
        xV1 <- rbind(xV1,
            - t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Cout = '-1',
                logjacobianOr = NULL
            )))
        )
    }

### D-variates in left tails
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'D') &
                          (auxmetadata$name %in% tailsv) &
                          (tails[auxmetadata$name] == 1) )
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean, K$Dmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd, K$Dsd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Dout = '1',
                logjacobianOr = NULL
            ))) +
                aux$halfstep / aux$tscale
        )
    }

### D-variates in right tails
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'D') &
                          (auxmetadata$name %in% tailsv) &
                          (tails[auxmetadata$name] == -1) )
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        ## note the minus!
        V1mean <- .learnbind(V1mean, -K$Dmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd, K$Dsd[aux$id, , , drop = FALSE])
        ## note the minus!
        xV1 <- rbind(xV1,
            - t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Dout = '-1',
                logjacobianOr = NULL
            ))) +
                aux$halfstep / aux$tscale
        )
    }

### C-variates not in 'tails' and with left boundary values
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'C') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] <= auxmetadata$domainmin[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean,
                K$Cmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd,
            K$Csd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
                t(as.matrix(.vtransform(
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Cout = 'leftbound',
                    logjacobianOr = NULL
                )))
        )
    }

### C-variates not in 'tails' and with right boundary values
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'C') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] >= auxmetadata$domainmax[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean,
                - K$Cmean[aux$id, , , drop = FALSE]) # minus sign
        V1sd <- .learnbind(V1sd,
            K$Csd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
               - t(as.matrix(.vtransform( # minus sign
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Cout = 'rightbound',
                    logjacobianOr = NULL
                )))
        )
    }

### D-variates not in 'tails' and with left boundary values
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'D') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] <= auxmetadata$domainminplushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean,
                K$Dmean[aux$id, , , drop = FALSE])
        V1sd <- .learnbind(V1sd,
            K$Dsd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
                t(as.matrix(.vtransform(
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Dout = 'leftbound',
                    logjacobianOr = NULL
                ))) +
                aux$halfstep / aux$tscale
        )
    }

### D-variates not in 'tails' and with right boundary values
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'D') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            any(x[,auxmetadata$name[i]] >= auxmetadata$domainmaxminushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV1 <- TRUE
        V1mean <- .learnbind(V1mean,
                - K$Dmean[aux$id, , , drop = FALSE]) # minus sign
        V1sd <- .learnbind(V1sd,
            K$Dsd[aux$id, , , drop = FALSE])
        xV1 <- rbind(xV1,
               - t(as.matrix(.vtransform( # minus sign
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Dout = 'rightbound',
                    logjacobianOr = NULL
                ))) +
                aux$halfstep / aux$tscale
        )
    }
    xV1 <- unname(xV1)

###
### interval probability
###
    nV2 <- FALSE
    V2mean <- V2sd <- V2steps <- NULL

### D-variates not in 'tails'
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'D') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0) {
        toselect <- toselect[sapply(toselect, function(i){
            xx <- x[,auxmetadata$name[i]]
            any(xx > auxmetadata$domainminplushs[i] &
                    xx < auxmetadata$domainmaxminushs[i],
                na.rm = TRUE)
        })]
    }
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nV2 <- TRUE
        V2mean <- .learnbind(V2mean,
                K$Dmean[aux$id, , , drop = FALSE])
        V2sd <- .learnbind(V2sd,
            K$Dsd[aux$id, , , drop = FALSE])
        V2steps <- aux$halfstep / aux$tscale
        xV2 <- rbind(xV2,
                t(as.matrix(.vtransform(
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Dout = 'boundisna',
                    logjacobianOr = NULL
                )))
        )
    }
    xV2 <- unname(xV2)

###
### discrete case
###
    nVN <- FALSE
    VNprobs <- NULL
    Nshift <- 0L
### O-variates not in 'tails'
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'O') &
                          !(auxmetadata$name %in% tailsv))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nVN <- TRUE
        ## Nindices <- unlist(lapply(seq_len(nrow(aux)), function(i) {
        ##     aux$indexpos[i] + seq_len(aux$Nvalues[i])
        ## }))
        Nindices <- unlist(mapply(FUN = function(i, n) {i + seq_len(n)},
            aux$indexpos, aux$Nvalues,
            SIMPLIFY = FALSE))
        VNprobs <- .learnbind(VNprobs,
            K$Oprob[Nindices, , , drop = FALSE])
        xVN <- rbind(xVN,
                t(as.matrix(.vtransform(
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
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'N'))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nVN <- TRUE
        ## Nindices <- unlist(lapply(seq_len(nrow(aux)), function(i) {
        ##     aux$indexpos[i] + seq_len(aux$Nvalues[i])
        ## }))
        Nindices <- unlist(mapply(FUN = function(i, n) {i + seq_len(n)},
            aux$indexpos, aux$Nvalues,
            SIMPLIFY = FALSE))
        VNprobs <- .learnbind(VNprobs,
            K$Nprob[Nindices, , , drop = FALSE])
        xVN <- rbind(xVN,
                t(as.matrix(.vtransform(
                    x[, aux$name, drop = FALSE],
                    auxmetadata = auxmetadata,
                    Nout = 'numeric',
                    logjacobianOr = NULL
                ))) +
                    Nshift + c(0, cumsum(aux$Nvalues[-1]))
        )
        Nshift <- Nshift + length(Nindices)
    }

### O-variates in 'tails'
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'O') &
                          (auxmetadata$name %in% tailsv))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nVN <- TRUE
        for(i in seq_len(nrow(aux))) {
            VNprobs <- .learnbind(VNprobs,
                if(tails[aux$name[i]] > 0) {
                    .rowcumsum(K$Oprob[
                        aux$indexpos[i] + seq_len(aux$Nvalues[i]), , , drop = FALSE
                    ])
                } else {
                    .rowinvcumsum(K$Oprob[
                        aux$indexpos[i] + seq_len(aux$Nvalues[i]), , , drop = FALSE
                    ])
                }
            )
        }
        xVN <- rbind(xVN,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Oout = 'numeric',
                logjacobianOr = NULL
            ))) +
                Nshift + c(0, cumsum(aux$Nvalues[-1]))
        )
    }
    xVN <- unname(xVN)

###
### binary case
###
    nVB <- FALSE
    VBprobs <- NULL
### B-variates
    toselect <- which((auxmetadata$name %in% Xv) &
                          (auxmetadata$mcmctype == 'B'))
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        nVB <- TRUE
        VBprobs <- .learnbind(VBprobs,
            K$Bprob[aux$id, , , drop = FALSE])
        xVB <- rbind(xVB,
            t(as.matrix(.vtransform(
                x[, aux$name, drop = FALSE],
                auxmetadata = auxmetadata,
                Bout = 'numeric',
                logjacobianOr = NULL
            )))
        )
    }
    xVB <- unname(xVB)


    list(
        params = list(
            nV0 = nV0, V0mean = V0mean, V0sd = V0sd,
            nV1 = nV1, V1mean = V1mean, V1sd = V1sd,
            nV2 = nV2, V2mean = V2mean, V2sd = V2sd,
            V2steps = V2steps,
            nVN = nVN, VNprobs = VNprobs,
            nVB = nVB, VBprobs = VBprobs
        ),
        xVs = lapply(seq_len(nX), function(i){
            list(
                ii = ids[i],
                xV0 = xV0[,i], # point vrts, handled by dnorm()
                xV1 = xV1[,i], # tail vrts, handled by pnorm()
                xV2 = xV2[,i], # interval vrts, handled by pnorm()-diff.
                xVN = xVN[,i], # nominal vrts, handled directly
                xVB = xVB[,i] # binary vrts, handled directly
            )})
    )
}



#' Calculate collection of log-probabilities for different components and samples
#'
#' Used in [Pr()], [qPr()], [rPr()], [mutualinfo()], [.Pcheckpoints()].
#'
#' @return Matrix of log-probabilities, with as many rows as components and as many cols as samples.
#' @keywords internal
.lprobsbase <- function(
    xVs, params, logW,
    temporarydir = NULL, lab = ''
) {
    with(c(xVs, params), {
    out <- logW
    ## point probability density
    if(nV0) {
        out <- out + colSums(
            x = dnorm(x = xV0, mean = V0mean, sd = V0sd, log = TRUE),
            na.rm = TRUE, dims = 1)
    }
    ## tail probability
    if(nV1) {
        out <- out + colSums(
            x = pnorm(q = xV1, mean = V1mean, sd = V1sd,
                log.p = TRUE, lower.tail = TRUE),
            na.rm = TRUE, dims = 1)
    }
    ## interval probability
    if(nV2) {
        pright <- pnorm(q = xV2 + V2steps, mean = V2mean, sd = V2sd,
            log.p = TRUE, lower.tail = TRUE)
        ##
        out <- out + colSums(
            x = pright + log(-expm1(
                pnorm(q = xV2 - V2steps, mean = V2mean, sd = V2sd,
                    log.p = TRUE, lower.tail = TRUE) - pright
            )),
            na.rm = TRUE, dims = 1)
        ##
        ## ## this alternate form seems less precise,
        ## ## compared with infinite-precision results
        ## out <- out + colSums(x = log(
        ##     pnorm(q = xV2 + V2steps, mean = V2mean, sd = V2sd,
        ##         log.p = FALSE, lower.tail = TRUE) -
        ##         pnorm(q = xV2 - V2steps, mean = V2mean, sd = V2sd,
        ##             log.p = FALSE, lower.tail = TRUE) ),
        ##     na.rm = TRUE, dims = 1)
        ##
        ## ## this alternate form leads to infinities in some cases
        ## pleft <- pnorm(q = xV2 - V2steps, mean = V2mean, sd = V2sd,
        ##     log.p = TRUE, lower.tail = TRUE)
        ## ##
        ## out <- out + colSums(
        ##     x = pleft + log(expm1(
        ##         pnorm(q = xV2 + V2steps, mean = V2mean, sd = V2sd,
        ##             log.p = TRUE, lower.tail = TRUE) - pleft
        ##     )),
        ##     na.rm = TRUE, dims = 1)
    }
    ##
    if(nVN) {
        out <- out + colSums(
            x = log(VNprobs[xVN, , , drop = FALSE]),
            na.rm = TRUE, dims = 1)
    }
    ##
    if(nVB) {
        ## VBprob is the probability that x = 1 (V2, 2nd value)
        out <- out + colSums(
            x = log(1 - xVB - VBprobs + 2 * xVB * VBprobs),
            na.rm = TRUE, dims = 1)
    }

    if(is.null(temporarydir)){
        out
    }else{
        saveRDS(out, file.path(temporarydir, paste0(lab, ii, '__.rds')))
    }
    })
}



#' Calculate probabilities, quantiles, etc, for all Y and X combinations
#'
#' Used in [Pr()].
#'
#' @import stats
#'
#' @keywords internal
.combineYX <- function(
    iyx,
    temporarydir, usememory = TRUE,
    doquantiles, quantiles,
    dosamples, nsamples,
    Qerror
) {
    if(usememory) {
        lprobX <- readRDS(file.path(temporarydir,
            paste0('__X', iyx['jx'], '__.rds')
        ))
        lprobY <- readRDS(file.path(temporarydir,
            paste0('__Y', iyx['jy'], '__.rds')
        ))
    }

    FF <- colSums(x = exp(lprobX + lprobY), na.rm = TRUE) /
        colSums(x = exp(lprobX), na.rm = TRUE)

    list(
        values = mean(x = FF, na.rm = TRUE),
        ##
        quantiles = if(doquantiles){
            quantile(x = FF, probs = quantiles, type = 6,
                na.rm = TRUE, names = FALSE)
        },
        ##
        samples = if(dosamples){
            FF <- FF[!is.na(FF)]
            FF[round(seq(1, length(FF), length.out = nsamples))]
        },
        ##
        values.MCaccuracy = .funMCSELD(x = FF),
        ##
        quantiles.MCaccuracy = if(doquantiles){
            temp <- .funMCEQ(x = FF, prob = quantiles, Qpair = Qerror)
            (temp[2, ] - temp[1, ]) / 2
        }
        ##
        ## error = sd(FF, na.rm = TRUE)/sqrt(nmcsamples)
    )
}


#' Calculate and combine log-probabilities to compute entropies
#'
#' Calculate log2_p(Y1|Y2), log2_p(Y2|Y1), log2_p(Y1), log2_p(Y2) for one datapoint. Used in [mutualinfo()].
#'
#' @return A vector of two pointwise mutual informations; one calculated from all MC samples, the other from the "limit frequencies" (MC sample corresponding to the input datapoint).
#' @keywords internal
.lprobsmi <- function(xVs, params1, params2, lW){

    thisid <- xVs[[1]] # MC-sample id of this datapoint

    lprobY1 <- .lprobsbase(xVs = xVs[1:6], params = params1, logW = 0,
        temporarydir= NULL)
    lprobY2 <- .lprobsbase(xVs = xVs[7:12], params = params2, logW = 0,
        temporarydir = NULL)

    lprobnorm <- .denorm(lW) # subtract max from each prob-col. of lW
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

    c(
        pMI = log(pY1and2) - log(pY1) - log(pY2),
        fMI = log(fY1and2) - log(fY1) - log(fY2)
        ## , id = thisid # for debugging
    )
}


#' Utility function to improve accuracy
#'
#' Used in '.lprobsmi()'.
#'
#' @keywords internal
.denorm <- function(lprob) {
    apply(X = lprob, MARGIN = 2, FUN = function(xx) {
        xx - max(xx[is.finite(xx)])
    }, simplify = TRUE)
}


#' Cumulative sum along first dimension
#'
#' Used in '.lprobsargsyx()'.
#'
#' @keywords internal
.rowcumsum <- function(x){
    for(i in 2:(dim(x)[1])){
        x[i,,] <- x[i,,] + x[i-1,,]
    }
    x
}


#' Inverse cumulative sum along first dimension
#'
#' Used in '.lprobsargsyx()'.
#'
#' @keywords internal
.rowinvcumsum <- function(x){
    for(i in (dim(x)[1] - 1):1){
        x[i,,] <- x[i,,] + x[i+1,,]
    }
    x
}
