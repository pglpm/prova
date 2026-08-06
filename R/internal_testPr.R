#' Test posterior probabilities
#'
#' @description This function calculates a posterior probability or probability density. It does so in a way that is inefficient but different from [Pr()] and with clearer code. It can therefore be used to test the correct functioning of [Pr()]. Note that, unlike [Pr()], this function does not do consistency checks of its arguments.
#'
#' @param Y named list of values; list names must be valid variate names.
#' @param X named list of values; list names must be valid variate names.
#' @param K Either a character with the name of a directory or full path for a 'K.rds' object, produced by the [learn()] function, or such an object itself.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `Y` and `X`. For variates in this list, the probability arguments are understood in a semi-open interval sense: \eqn{Y \le y} or \eqn{Y \ge y}, an so on. This is true for `Y` and `X` variates (on the left and on the right of the conditional sign \eqn{\,\vert\,}). A left-open interval \eqn{Y \le y} is indicated by `'<='` or `'lower'` or`'left'` or `-1`; a right-open interval \eqn{Y \ge y} is indicated by `'>='` or `'upper'`  or `'right'` or `+1`. Values `NULL`, `'=='`, `0` indicate that a point value `Y = y` (not an interval) should be calculated. **NB**: the semi-open intervals *always* include the given value; this is important for ordinal or rounded variates. For instance, if \eqn{Y} is an integer variate, then to calculate  \eqn{\mathrm{Pr}(Y < 3)} you should require \eqn{\mathrm{Pr}(Y \le 2)}; for this reason we also have that \eqn{\mathrm{Pr}(Y \le 2)} and  \eqn{\mathrm{Pr}(Y \ge 2)} generally add up to *more* than 1.
#' @return A list consisting of the following elements:
#'
#' - `value`: value of \eqn{\mathrm{Pr}(Y = y \vert X = x, \text{data})}.
#' - `samples`: a vector with the revisability samples of the probability above.
#' - `jacobians`: a vector with the Jacobian of the internal transformation.
#'
#' @import stats
#' @import utils
#'
#' @keywords internal
.testPr <- function(
    Y,
    X = NULL,
    K = NULL,
    tails = NULL
){
    Qerror <- pnorm(c(-1, 1))

    ## Figure out unnamed arguments
    Kname <- c(deparse(substitute(K)), deparse(substitute(X)))
    if(!is.null(X) && is.null(K)){
        K <- X
        X <- NULL
        Kname <- Kname[2]
    } else if(!is.null(X) && !is.null(K) && is.null(tails) &&
                  !is.null(.retrieveK(X))){
            tails <- K
            K <- X
            X <- NULL
            Kname <- Kname[2]
    } else {
        Kname <- Kname[1]
    }

    ## Check 'K' argument
    K <- .retrieveK(K)
    if(is.null(K)){
        stop("Argument 'K' must be a 'prova_K' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
    }

    auxmetadata <- K$auxmetadata
    K$auxmetadata <- NULL
    K$auxinfo <- NULL
    ncomponents <- nrow(K$W)
    nmcsamples <- ncol(K$W)

    Yv <- names(Y)
    Xv <- names(X)

    tailscentre <- list('==', 0, '0', NULL)
    tailsleft <- list('<=', -1, '-1', 'left', 'lower')
    tailsright <- list('>=', 1, '+1', 'right', 'upper')
    tailsvalues <- c(tailscentre, tailsleft, tailsright)
    ## transform 'tails' to -1, +1
    ## +1: '<=',    -1: '>='
    ## this is opposite of the argument convention because
    ## interval probabilities are calculated with `lower.tail = TRUE`
    ## eg:
    ## pnorm(x, mean, sd, lower.tail = FALSE) ==
    ##     pnorm(-x, -mean, sd, lower.tail = TRUE)
    tails[tails %in% tailscentre] <- NULL
    ## cleft <- tails %in% tailsleft
    ## cright <- tails %in% tailsright
    ## tails[cleft] <- +1
    ## tails[cright] <- -1
    tails <- unlist(tails)

    ## Function to calculate and lum log-kernels log(K)
    logK <- function(Z){
        logprob <- 0

        for(vrt in names(Z)){
            mctype <- auxmetadata[auxmetadata$name == vrt, 'mcmctype']
            auxid <- auxmetadata[auxmetadata$name == vrt, 'id']

            if(mctype == 'R'){
                val <- unlist(.vtransform(Z[vrt], Rout = 'normalized',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))

                if(!(vrt %in% names(tails))){
                    logP <- dnorm(x = val,
                        mean = K$Rmean[auxid, , ],
                        sd = K$Rsd[auxid, , ],
                        log = TRUE)

                } else if(tails[vrt] %in% tailsleft){
                    logP <- pnorm(q = val,
                        mean = K$Rmean[auxid, , ],
                        sd = K$Rsd[auxid, , ],
                        lower.tail = TRUE, log.p = TRUE)

                } else if(tails[vrt] %in% tailsright){
                    logP <- pnorm(q = val,
                        mean = K$Rmean[auxid, , ],
                        sd = K$Rsd[auxid, , ],
                        lower.tail = FALSE, log.p = TRUE)
                }


            } else if(mctype == 'C'){
                ## at first, boundary values are set to NA
                xorig <- Z[[vrt]]
                domainmax <- auxmetadata[auxmetadata$name == vrt,
                    'domainmax']
                domainmin <- auxmetadata[auxmetadata$name == vrt,
                    'domainmin']
                val <- unlist(.vtransform(Z[vrt], Cout = 'boundisna',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))

                if(!(vrt %in% names(tails))){
                    if(is.finite(val)){
                        logP <- dnorm(x = val,
                            mean = K$Cmean[auxid, , ],
                            sd = K$Csd[auxid, , ],
                            log = TRUE)
                    } else if(xorig > domainmin){
                        val <- unlist(.vtransform(Z[vrt], Cout = 'rightbound',
                            auxmetadata = auxmetadata, logjacobianOr = NULL))
                        logP <- pnorm(q = val,
                            mean = K$Cmean[auxid, , ],
                            sd = K$Csd[auxid, , ],
                            lower.tail = FALSE, log.p = TRUE)
                    } else if(xorig < domainmax){
                        val <- unlist(.vtransform(Z[vrt], Cout = 'leftbound',
                            auxmetadata = auxmetadata, logjacobianOr = NULL))
                        logP <- pnorm(q = val,
                            mean = K$Cmean[auxid, , ],
                            sd = K$Csd[auxid, , ],
                            lower.tail = TRUE, log.p = TRUE)
                    } else {
                        stop('Vrt ', vrt, ' has strange value')
                    }

                } else if(tails[vrt] %in% tailsleft){
                    val <- unlist(.vtransform(Z[vrt], Cout = '1',
                        auxmetadata = auxmetadata, logjacobianOr = NULL))
                    logP <- pnorm(q = val,
                        mean = K$Cmean[auxid, , ],
                        sd = K$Csd[auxid, , ],
                        lower.tail = TRUE, log.p = TRUE)

                } else if(tails[vrt] %in% tailsright){
                    val <- unlist(.vtransform(Z[vrt], Cout = '-1',
                        auxmetadata = auxmetadata, logjacobianOr = NULL))
                    logP <- pnorm(q = val,
                        mean = K$Cmean[auxid, , ],
                        sd = K$Csd[auxid, , ],
                        lower.tail = FALSE, log.p = TRUE)
                }


            } else if(mctype == 'D'){
                xorig <- Z[[vrt]]
                val <- unlist(.vtransform(Z[vrt], Dout = 'boundisna',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))
                hstep <- auxmetadata[auxmetadata$name == vrt, 'halfstep'] /
                    auxmetadata[auxmetadata$name == vrt, 'tscale']
                domainmaxminushs <- auxmetadata[auxmetadata$name == vrt,
                    'domainmaxminushs']
                domainminplushs <- auxmetadata[auxmetadata$name == vrt,
                    'domainminplushs']

                if(!(vrt %in% names(tails))){
                    if(!is.na(val)){
                        logP <- pnorm(q = val + hstep,
                            mean = K$Dmean[auxid, , ],
                            sd = K$Dsd[auxid, , ],
                            lower.tail = TRUE, log.p = TRUE)
                        logP <- logP + log(-expm1(
                            pnorm(q = val - hstep,
                                mean = K$Dmean[auxid, , ],
                                sd = K$Dsd[auxid, , ],
                                lower.tail = TRUE, log.p = TRUE) - logP
                        ))
                        ##
                        ## ## this alternate form seems less precise,
                        ## ## compared with infinite-precision results
                        ## logP <- log(
                        ##     pnorm(q = val + hstep,
                        ##         mean = K$Dmean[auxid, , ],
                        ##         sd = K$Dsd[auxid, , ],
                        ##         lower.tail = TRUE, log.p = FALSE) -
                        ##         pnorm(q = val - hstep,
                        ##             mean = K$Dmean[auxid, , ],
                        ##             sd = K$Dsd[auxid, , ],
                        ##             lower.tail = TRUE, log.p = FALSE)
                        ## )

                    } else if(xorig <= domainmaxminushs){
                        val <- unlist(.vtransform(Z[vrt], Dout = 'leftbound',
                            auxmetadata = auxmetadata, logjacobianOr = NULL))
                        logP <- pnorm(q = val + hstep,
                            mean = K$Dmean[auxid, , ],
                            sd = K$Dsd[auxid, , ],
                            lower.tail = TRUE, log.p = TRUE)

                    } else if(xorig >= domainminplushs){
                        val <- unlist(.vtransform(Z[vrt], Dout = 'rightbound',
                            auxmetadata = auxmetadata, logjacobianOr = NULL))
                        logP <- pnorm(q = val - hstep,
                            mean = K$Dmean[auxid, , ],
                            sd = K$Dsd[auxid, , ],
                            lower.tail = FALSE, log.p = TRUE)
                    }

                } else if(tails[vrt] %in% tailsleft){
                    val <- unlist(.vtransform(Z[vrt], Dout = '1',
                        auxmetadata = auxmetadata, logjacobianOr = NULL))
                    logP <- pnorm(q = val + hstep,
                        mean = K$Dmean[auxid, , ],
                        sd = K$Dsd[auxid, , ],
                        lower.tail = TRUE, log.p = TRUE)

                } else if(tails[vrt] %in% tailsright){
                    val <- unlist(.vtransform(Z[vrt], Dout = '-1',
                        auxmetadata = auxmetadata, logjacobianOr = NULL))
                    logP <- pnorm(q = val - hstep,
                        mean = K$Dmean[auxid, , ],
                        sd = K$Dsd[auxid, , ],
                        lower.tail = FALSE, log.p = TRUE)
                }


            } else if(mctype == 'N'){
                val <- unlist(.vtransform(Z[vrt], Nout = 'index',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))
                logP <- log(K$Nprob[val, , ])


            } else if(mctype == 'O'){
                Nvals <- auxmetadata[auxmetadata$name == vrt, 'Nvalues']
                seqO <- auxmetadata[auxmetadata$name == vrt, 'indexpos'] +
                    seq_len(Nvals)
                allP <- K$Oprob[seqO, , , drop = FALSE]
                val <- unlist(.vtransform(Z[vrt], Oout = 'numeric',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))

                if(!(vrt %in% names(tails))){
                    logP <- log(allP[val, , ])
                } else if(tails[vrt] %in% tailsleft){
                    logP <- log(apply(allP[1:val, , , drop = FALSE],
                        c(2,3), sum))
                } else if(tails[vrt] %in% tailsright){
                    logP <- log(apply(allP[val:Nvals, , , drop = FALSE],
                        c(2,3), sum))
                }

            } else if(mctype == 'B'){
                val <- unlist(.vtransform(Z[vrt], Bout = 'numeric',
                    auxmetadata = auxmetadata, logjacobianOr = NULL))
                if(val == 0){
                    logP <- log(1 - K$Bprob[auxid, , ])
                } else {
                    logP <- log(K$Bprob[auxid, , ])
                }
            }
## cat(vrt, ':', logP[,1532],'\n')

            logprob <- logprob + logP
        }
        c(logprob)
    }

    logKY <- logK(Y)

    ## Conditional formula sum(W KX KY)/sum(W kX), sum over components
    if(is.null(X)){
        FF <- colSums(x = exp(log(K$W) + logKY), na.rm = TRUE)
        ## logKX <- log(K$W)
        ## FF <- colSums(x = exp(logKX + logKY), na.rm = TRUE) /
        ##     colSums(x = exp(logKX), na.rm = TRUE)
    } else {
        logKX <- log(K$W) + logK(X)
        FF <- colSums(x = exp(logKX + logKY), na.rm = TRUE) /
        colSums(x = exp(logKX), na.rm = TRUE)
    }

    y <- Y
    y[names(Y) %in% names(tails)] <- NA
    jacobians <- exp(rowSums(as.matrix(.vtransform(y,
        auxmetadata = auxmetadata, logjacobianOr = TRUE)),
        na.rm = TRUE
    ))
    rm(y)

    FF <- FF * jacobians

    list(value = mean(FF), samples = FF, jacobians = jacobians)
}
