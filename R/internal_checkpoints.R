#' Format datapoints used for MCMC monitoring
#'
#' Used in '.Pcheckpoints()' within 'learn()'.
#'
#' @param x Datapoints to be used for checking MCMC progress
#' @param auxmetadata auxmetadata object
#' @param pointsid Id of datapoints
#'
#' @return some arguments to be repeatedly used in .Pcheckpoints
#'
#' @keywords internal
.prepPcheckpoints <- function(
    x, auxmetadata, pointsid = NULL
){
    ## Use .lprobsargsyx() as done in Pr(), but throw away some elements
    temp <- .lprobsargsyx(
        x = x, auxmetadata = auxmetadata,
        learnt = list(
            Cmean = array(NA, dim = c(max(auxmetadata$id), 1, 1)),
            Dmean = array(NA, dim = c(max(auxmetadata$id), 1, 1))
        ), tails = NULL
    )
    for(i in seq_len(length(temp$xVs))){temp$xVs[[i]]$ii <- NULL}

    nX <- nrow(x)

    auxV0a <- auxV0b <- auxV1a <- auxV1b <- auxV1c <- auxV1d <- NULL
    auxV2 <- auxVNO <- auxVNN <- auxVB <- NULL

###
### point probability density
###

### R-variates not in 'cumul'
    toselect <- which(auxmetadata$mcmctype == 'R')
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        auxV0a <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV0b <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV1a <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV1b <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV1c <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV1d <- aux$id
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
        aux <- auxmetadata[toselect, ]
        auxV2 <- aux$id
    }

###
### discrete case
###
    Nshift <- 0L
### O-variates not in 'cumul'
    toselect <- which(auxmetadata$mcmctype == 'O')
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        auxVNO <- aux$id
    }
### N-variates
    toselect <- which(auxmetadata$mcmctype == 'N')
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        auxVNN <- aux$id
    }

###
### binary case
###

### B-variates
    toselect <- which(auxmetadata$mcmctype == 'B')
    if(length(toselect) > 0){
        aux <- auxmetadata[toselect, ]
        auxVB <- aux$id
    }

    list(
        nV0 = temp$params$nV0,
        nV1 = temp$params$nV1,
        nV2 = temp$params$nV2,
        nVN = temp$params$nVN,
        nVB = temp$params$nVB,
        auxV0a = auxV0a, auxV0b = auxV0b,
        auxV1a = auxV1a, auxV1b = auxV1b, auxV1c = auxV1c, auxV1d = auxV1d,
        auxV2 = auxV2,
        auxVNO = auxVNO, auxVNN = auxVNN,
        auxVB = auxVB,
        V2steps = temp$params$V2steps,
        pointsid = pointsid,
        ##
        xVs = temp$xVs
    )
}


#' Calculate joint frequencies for MCMC-monitoring checkpoints
#'
#' Used in 'learn()'.
#'
#' @param testdata List of objects calculated with .prepPcheckpoints
#' @param learnt mcsamples object
#'
#' @keywords internal
#'
#' @return The joint frequencies of Y corresponding to the Monte Carlo samples
.Pcheckpoints <- function(
    testdata, learnt
) {
    with(c(testdata, learnt), {

        nsamples <- ncol(W)
        ncomponents <- nrow(W)


###
### point probability density
###
        V0mean <- V0sd <- NULL

### R-variates not in 'cumul'
        if(length(auxV0a) > 0){
            V0mean <- .learnbind(V0mean, Rmean)
            V0sd <- .learnbind(V0sd, sqrt(Rvar)) # still variance
        }

### C-variates not in 'cumul' and with some non-boundary value
        if(length(auxV0b) > 0) {
            V0mean <- .learnbind(V0mean,
                Cmean[auxV0b, , , drop = FALSE])
            V0sd <- .learnbind(V0sd,
                sqrt(Cvar[auxV0b, , , drop = FALSE])) # still variance
        }

###
### tail probability
###
        V1mean <- V1sd <- NULL

### C-variates not in 'cumul' and with left boundary values
        if(length(auxV1a) > 0){
            V1mean <- .learnbind(V1mean,
                Cmean[auxV1a, , , drop = FALSE])
            V1sd <- .learnbind(V1sd,
                sqrt(Cvar[auxV1a, , , drop = FALSE])) # still variance
        }

### C-variates not in 'cumul' and with right boundary values
        if(length(auxV1b) > 0){
            V1mean <- .learnbind(V1mean,
                - Cmean[auxV1b, , , drop = FALSE]) # minus sign
            V1sd <- .learnbind(V1sd,
                sqrt(Cvar[auxV1b, , , drop = FALSE])) # still variance
        }

### D-variates not in 'cumul' and with left boundary values
        if(length(auxV1c) > 0){
            V1mean <- .learnbind(V1mean,
                Dmean[auxV1c, , , drop = FALSE])
            V1sd <- .learnbind(V1sd,
                sqrt(Dvar[auxV1c, , , drop = FALSE])) # still variance
        }

### D-variates not in 'cumul' and with right boundary values
        if(length(auxV1d) > 0){
            V1mean <- .learnbind(V1mean,
                - Dmean[auxV1d, , , drop = FALSE]) # minus sign
            V1sd <- .learnbind(V1sd,
                sqrt(Dvar[auxV1d, , , drop = FALSE])) # still variance
        }

###
### interval probability
###
        V2mean <- V2sd <- NULL

### D-variates not in 'cumul'
        if(length(auxV2) > 0){
            V2mean <- Dmean
            V2sd <- sqrt(Dvar) # still variance
        }

###
### discrete case
###
        VNprobs <- NULL

### O-variates not in 'cumul'
        if(length(auxVNO) > 0){
            VNprobs <- .learnbind(VNprobs,
                Oprob)
        }
### N-variates
        if(length(auxVNN) > 0){
            VNprobs <- .learnbind(VNprobs,
                Nprob)
        }

###
### binary case
###
        VBprobs <- NULL

### B-variates
        if(length(auxVB) > 0){
            VBprobs <- Bprob
        }


        lprobX <- log(W)
        do.call(cbind,
            lapply(
                X = xVs,
                FUN = function(xx){
                    lprobY <- .lprobsbase(
                        xVs = xx,
                        params = list(
                            nV0 = nV0,
                            V0mean = V0mean,
                            V0sd = V0sd,
                            nV1 = nV1,
                            V1mean = V1mean,
                            V1sd = V1sd,
                            nV2 = nV2,
                            V2mean = V2mean,
                            V2sd = V2sd,
                            V2steps = V2steps,
                            nVN = nVN,
                            VNprobs = VNprobs,
                            nVB = nVB,
                            VBprobs = VBprobs
                            ),
                        logW = lprobX,
                        temporarydir = NULL
                    )
                   ## Output: rows=components, columns=samples
                    colSums(exp(lprobY)) / colSums(W)
                })
            )
    }) # Output: rows=components, columns=samples
}
