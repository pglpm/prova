#' Generate datapoints
#'
#' @description Generates datapoints of chosen joint variates, according to posterior probabilities and posterior conditional probabilities.
#'
#' @details This function generates datapoints according to the posterior probability \eqn{\mathrm{Pr}(Y = y \vert X = x, K)} or \eqn{\mathrm{Pr}(Y = y \vert X \le x, K)} or combinations thereof, for the variates specified in the argument `Y`, and conditional on the variate values specified in the argument `X`. It is somewhat analogous to the `rxxx`-variants of [R distribution functions][stats::Distributions]. If `X` is omitted or `NULL`, then the posterior probability \eqn{\mathrm{Pr}(Y | K)} is used. Each variate in the argument `X` can be specified either as a point-value \eqn{X = x} or as a left-open interval \eqn{X \le x} or as a right-open interval \eqn{X \ge x}, through the argument `tails`.
#'
#' If `rPr()` is called with three unnamed arguments, `rPr(..., ..., ...)`, then it is interpreted as `rPr(n = ..., Ynames = ..., K = ...)`.
#'
#' @param n Positive integer: number of samples to draw.
#' @param Ynames Character vector: names of variates to draw jointly
#' @param X List or data.table or `NULL`: set of values of variates on which we want to condition the joint probability for `Y`. If `NULL` (default), no conditioning is made. Any rows beyond the first are discarded
#' @param K A "Knowledge" object produced by [learn()]. It can also be a path to a 'K.rds' file containing such object, or to a directory containing one.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `X`. For variates in this list, the probability conditional is understood in a semi-open interval sense: \eqn{X \le x} or \eqn{X \ge x}, an so on. See analogous argument in [Pr()].
#' @param mcsamples Vector of integers, or `'all'`, or `NULL` (default): which Monte Carlo samples calculated by the [learn()] function should be used to draw the variate values. The default is to choose a random subset if `n` is smaller than their number, otherwise to recycle them as necessary.
#' @param parallel Not used: this function does not use parallelization.
#'
#' @return A [data frame][base::data.frame()] of joint draws of the variates `Ynames` from the posterior distribution, conditional on `X`. The row names of the data frame report the Monte Carlo sample (from [learn()]) used for that draw, and the total number of draws from that sample so far.
#'
#' @seealso
#' [learn()], which generates the `K` objects required by `qPr()`.
#'
#' [Pr()] to calculate joint and conditional probabilities.
#'
#' [qPr()] to calculate quantiles.
#'
#' @examples
#' ## Use the example "Knowledge" object 'Kexample'
#' ## calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#'
#' ## ## Example 1:
#' ## Generate 10 values of the 'species' variate,
#' ## according to the frequency distribution estimated from the data
#'
#' datapoints <- rPr(10, 'species', Kexample)
#'
#' c(datapoints)
#'
#'
#' ## ## Example 2:
#' ## Generate 5 joint values of the 'species' and 'bill_len' variates.
#'
#' datapoints <- rPr(5, c('species', 'bill_len'), Kexample)
#'
#' print(datapoints, row.names = FALSE) ## row names give MCMC information
#'
#'
#' ## ## Example 3:
#' ## Generate 5 values of the 'species' variate,
#' ## for the subpopulation of penguins having bill length shorter than 40 mm
#'
#' datapoints <- rPr(5, 'species', data.frame(bill_len = 40), Kexample,
#'   tails = list(bill_len = 'lower'))
#'
#' c(datapoints)
#'
#' @import utils
#' @import stats
#'
#' @concept generate
#' @export
rPr <- function(
    n,
    Ynames,
    X = NULL,
    K = NULL,
    tails = NULL,
    mcsamples = NULL,
    parallel = NULL # unused
) {

    ## Figure out unnamed arguments
    if(!is.null(X) && is.null(K)){
        K <- X
        X <- NULL
    }

    ## Check 'K' argument
    K <- .retrieveK(K)
    if(is.null(K)){
        stop("Argument 'K' must be a 'Knowledge' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
    }

    auxmetadata <- K$auxmetadata
    K$auxmetadata <- NULL
    K$auxinfo <- NULL
    ncomponents <- nrow(K$W)
    nmcsamples <- ncol(K$W)

    if(is.null(mcsamples) ||
           (is.character(mcsamples) && mcsamples == 'all') ||
           isTRUE(mcsamples)) {
        mcsamples <- seq_len(nmcsamples)
    } else if (any(!is.finite(mcsamples)) || any(mcsamples < 1)) {
        stop("'mcsamples' should be a list of positive integers or NULL")
    } else {
        mcsamples <- round(mcsamples[mcsamples <= nmcsamples])
    }

    nmcs <- length(mcsamples)
    if(n <= nmcs) {
        sseq <- mcsamples[sort.int(sample.int(n = nmcs, size = n))]
    } else {
        sseq <- c(rep.int(x = mcsamples, times = n %/% nmcs),
            mcsamples[sort.int(sample.int(n = nmcs, size = n %% nmcs))])
    }

    if(all(is.na(X))){X <- NULL}
    if(!is.null(X)){
        if(!is.data.frame(X)){ X <- as.data.frame(X) }
        if (nrow(X) > 1) {
            warning('Only the first row of X is considered')
            X <- X[1, , drop = FALSE]
        }
    }
    Xv <- colnames(X)

    if(!is.null(tails)){
        tails <- as.list(tails)
        if(is.null(names(tails))) {
            stop('Missing variate names in "tails"')
        }
    }
    tailsv <- names(tails)
    tailscentre <- list('==', 0, '0', NULL)
    tailsleft <- list('<=', -1, '-1', 'left', 'lower')
    tailsright <- list('>=', 1, '+1', 'right', 'upper')
    tailsvalues <- c(tailscentre, tailsleft, tailsright)

    ## Consistency checks
    if(!is.character(Ynames) || any(is.na(Ynames))){
        stop('Ynames must be a vector of variate names')
    }
    if(!all(Ynames %in% auxmetadata$name)) {
        stop('unknown Y variates\n')
    }
    if(length(unique(Ynames)) != length(Ynames)) {
        stop('duplicate Y variates\n')
    }

    if(!all(Xv %in% auxmetadata$name)){
        stop('unknown X variates\n')
    }
    if(anyDuplicated(Xv)){
        stop('duplicate X variates\n')
    }
    if(anyDuplicated(c(Ynames, Xv))){
        stop('overlap in Y and X variates\n')
    }

    if(!all(tailsv %in% Xv)){
        warning('"tails" variate ',
            paste0(tailsv[!(tailsv %in% Xv)], collapse = ' '),
            ' not among X; ignored\n')
        tails <- tails[tailsv %in% Xv]
        tailsv <- names(tails)
    }
    if(anyDuplicated(tailsv)){
        stop('duplicate "tails" variates\n')
    }
    if(!all(tails %in% tailsvalues)) {
        stop('"tails" values must be ',
            paste0(tailsvalues, collapse = ' '), '\n')
    }

    ## transform 'tails' to -1, +1
    ## +1: '<=',    -1: '>='
    ## this is opposite of the argument convention because
    ## interval probabilities are calculated with `lower.tail = TRUE`
    ## eg:
    ## pnorm(x, mean, sd, lower.tail = FALSE) ==
    ##     pnorm(-x, -mean, sd, lower.tail = TRUE)
    tails[tails %in% tailscentre] <- NULL
    cleft <- tails %in% tailsleft
    cright <- tails %in% tailsright
    tails[cleft] <- +1
    tails[cright] <- -1
    tails <- unlist(tails)


#### Adjust component weights W for conditioning on X
    if(is.null(X)){
        lW <- log(K$W)
    } else {
        lpargs <- .lprobsargsyx(
            x = X,
            auxmetadata = auxmetadata,
            K = K,
            tails = tails
        )

        lW <- .lprobsbase(
            xVs = lpargs$xVs[[1]],
            params = lpargs$params,
            logW =  log(K$W)
        ) # rows=components, columns=samples

    } # end definition of lW if non-null X


    ## Utility function to avoid finite-precision errors
    ## now externally defined
    ## denorm <- function(lprob) {
    ##     apply(X = lprob, MARGIN = 2, FUN = function(xx) {
    ##         xx - max(xx[is.finite(xx)])
    ##     }, simplify = TRUE)
    ## }

#### Draw samples of Ynames
    Wdenorm <- exp(.denorm(lW[, sseq, drop = FALSE]))
    Ws <- c(t(apply(
        X = Wdenorm, MARGIN = 2,
        FUN = function(xx){sample.int(n = ncomponents, size = 1, prob = xx)},
        simplify = TRUE
    )))
    rm(Wdenorm)
    gc(full = TRUE)
    ## ## Old version with extraDistr::rcatlp()
    ## ## extraDistr::rcatlp() can use non-normalized probabilities
    ## ## NOTA BENE: the '1 - ...' is because of a bug in rcatlp() < 1.10.0.5
    ## Ws <- 1 - extraDistr::rcatlp(n = 1, log_prob = 0) +
    ##     extraDistr::rcatlp(n = n, log_prob = t(lW)[sseq, , drop = FALSE])
    ##
    ## ## Old version with extraDistr::cat(), can be 10 times slower
    ## lWnorm <- .denorm(lW[, sseq, drop = FALSE])
    ## Ws <- extraDistr::rcat(n = n, prob = t(
    ##     apply(X = lWnorm, MARGIN = 2, FUN = function(xx){
    ##         xx <- exp(xx)
    ##         xx/sum(xx, na.rm = TRUE)
    ##     }, simplify = TRUE)
    ## ))

    Yout <- NULL
    vYout <- NULL

    ## R
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'R'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep(x = aux$id, each = n), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = n * nvrt,
                mean = K$Rmean[totake],
                sd = K$Rsd[totake] )
        )
    }

    ## C
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'C'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep(x = aux$id, each = n), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = n * nvrt,
                mean = K$Cmean[totake],
                sd = K$Csd[totake] )
        )
    }

    ## D
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'D'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep(x = aux$id, each = n), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = n * nvrt,
                mean = K$Dmean[totake],
                sd = K$Dsd[totake] )
        )
    }

    ## O
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'O'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        vYout <- c(vYout, auxmetadata$name[toselect])
        for(i in toselect) {
            aux <- auxmetadata[i, ]
            Yout <- c(Yout, mapply(FUN = function(xx, yy){
                sample.int(n = aux$Nvalues, size = 1,
                    prob = K$Oprob[aux$indexpos + seq_len(aux$Nvalues), xx, yy])},
                Ws, sseq, SIMPLIFY = TRUE))
            ## ## old version with extraDistr::rcat()
            ## totake <- cbind(Ws, sseq)
            ## Yout <- c(Yout,
            ##     extraDistr::rcat(n = n,
            ##         prob = apply(
            ##             X = K$Oprob[aux$indexpos + seq_len(aux$Nvalues), ,],
            ##             MARGIN = 1, FUN = `[`, totake,
            ##             simplify = TRUE) )
            ## )
        }
    }

    ## N
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'N'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        vYout <- c(vYout, auxmetadata$name[toselect])
        for(i in toselect) {
            aux <- auxmetadata[i, ]
            Yout <- c(Yout, mapply(FUN = function(xx, yy){
                sample.int(n = aux$Nvalues, size = 1,
                    prob = K$Nprob[aux$indexpos + seq_len(aux$Nvalues), xx, yy])},
                Ws, sseq, SIMPLIFY = TRUE))
            ## ## old version with extraDistr::rcat()
            ## totake <- cbind(Ws, sseq)
            ## Yout <- c(Yout,
            ##     extraDistr::rcat(n = n,
            ##         prob = apply(
            ##             X = K$Nprob[aux$indexpos + seq_len(aux$Nvalues), ,],
            ##             MARGIN = 1, FUN = `[`, totake,
            ##             simplify = TRUE) )
            ## )
        }
    }

    ## B
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'B'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep(x = aux$id, each = n), Ws, sseq)
        Yout <- c(Yout,
            rbinom(n = n * nvrt, size = 1, prob = K$Bprob[totake])
            ## ## Old version
            ## extraDistr::rbern(n = n * nvrt, prob = K$Bprob[totake])
        )
    }

    dim(Yout) <- c(n, length(Ynames))
    Yout <- Yout[, match(Ynames, vYout), drop = FALSE]
    colnames(Yout) <- Ynames

    Yout <- .vtransform(Yout,
        auxmetadata = auxmetadata,
        Rout = 'original',
        Cout = 'original',
        Dout = 'original',
        Oout = 'original',
        Nout = 'original',
        Bout = 'original',
        logjacobianOr = NULL)

    ## row-name scheme: 'mcsample.draw'
    rownames(Yout) <- paste0(sseq, '_', ((seq_len(n) - 1L) %/% nmcs) + 1L)

    Yout
}
