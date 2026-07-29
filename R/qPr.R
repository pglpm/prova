#' Calculate quantiles
#'
#' @description This function calculates the quantiles of posterior probabilities and posterior conditional probabilities. It also outputs the revisability of such quantiles if more training data were available.
#'
#' @details This function calculates the quantiles of \eqn{\mathrm{Pr}(Y = y \vert X = x, \text{data})} or of \eqn{\mathrm{Pr}(Y = y \vert X \le x, \text{data})} or combinations thereof, at specified cumulative-probability levels. In other words, it calculates the values of \eqn{Y} having specified cumulative probabilities or conditional probabilities. It also calculates the revisability of those quantiles if more learning data were provided. It is somewhat analogous to the `qxxx`-variants of [R distribution functions][stats::Distributions]. The revisability can be expressed in the form of quantiles, samples, or both, as in the [Pr()] function. If several joint values are given for the probability levels and for `X`, the function creates a 2D grid of results for all possible combinations of the given probability levels and `X` values. Each variate in the argument `X` can be specified either as a point-value \eqn{X = x} or as a left-open interval \eqn{X \le x} or as a right-open interval \eqn{X \ge x}, through the argument `tails`.
#'
#' @param p Numeric vector of probability levels. Default: `c(0.25, 0.5, 0.75)`.
#' @param Yname Character vector: name of variate whose quantiles will be computed.
#' @param X Matrix or data.table or `NULL` (default): set of values of variates on which we want to condition. If `NULL`, no conditioning is made (except for conditioning on the learning dataset and prior assumptions). One variate per column, one set of values per row.
#' @param K Either a character with the name of a directory or full path for a 'K.rds' object, produced by the [learn()] function, or such an object itself.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `X`. For variates in this list, the probability conditional is understood in a semi-open interval sense: \eqn{X \le x} or \eqn{X \ge x}, an so on. See analogous argument in [Pr()].
## #' @param priorY Numeric vector with the same length as the rows of `Y`, or `TRUE`, or `NULL` (default): prior probabilities or base rates for the `Y` values. If `TRUE`, the prior probabilities are assumed to be all equal. For the moment only the value `NULL` is accepted.
#' @param nsamples Integer or `NULL` or `'all'` (default): desired number of samples of the revisability of the quantile for `Y`. If `NULL`, no samples are reported. If `'all'` (or `Inf`), all samples obtained by the [learn()] function are used.
#' @param quantiles Numeric vector, between 0 and 1, or `NULL`: desired quantiles of the revisability of the quantile for `Y`. Default `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5% quantiles (these are typical quantile values in the Bayesian literature: they give 50% and 89% credibility intervals, which correspond to 1 shannons and 0.5 shannons of uncertainty). If `NULL`, no quantiles are calculated.
#' @param parallel Logical or positive integer or cluster object. `TRUE` (default): use as many cores as in user's [option][base::getOption()] "nc.cores", or 2 if that is `NULL`. `FALSE`: use serial computation. Integer: use this many cores. It can also be a cluster object previously created with [parallel::makeCluster()]; in this case the parallel computation will use this object.
#' @param sep character, default `','`: character to separate variate names and values
#' @param solidus character, default `'|'`: character prepended to names of the variates in the conditional (typically the `X` variates).
#' @param verbose Logical, default `FALSE`: give messages about parallel processing?
#' @param keepYX Logical, default `TRUE`: keep a copy of the `Yname` and `X` arguments in the output? This is used for [plot.probability()].
#' @param tol numeric positive: tolerance in the calculation of quantiles. Default: `.Machine$double.eps * 10` (typically `2.22045e-15`).

#'
#' @return A list of the following elements:
#' - `$values`: a matrix with the requested \eqn{Y}-quantiles `p` conditional on the requested \eqn{X}-values in `X`, for all combinations of `p` (rows) and `X` (columns).
#' - `$quantiles` (possibly `NULL`): an array with the revisability quantiles (3rd dimension of the array) for the quantiles of the `value` element.
#' - `$samples` (possibly `NULL`): an array with the revisability samples (3rd dimension of the array) for such quantiles.
#' - `$Y`, `$X` `$tails`: copies of the `Y`, `X`, `tails` arguments.
#' - `$K`: name of the `K` object used in the calculation.
#'
#' @references
#' - Porta Mana (2025): *What's special about 89% credibility intervals?* <doi:10.5281/zenodo.17072199>.
#'
#' @seealso
#' [learn()], which generates the `K` objects required by `qPr()`.
#'
#' [Pr()] to calculate joint and conditional probabilities.
#'
#' [rPr()] to generate datapoints.
#'
#' @examples
#' ### WARNING: the following examples, if run, might even take a minute or more.
#'
#' \donttest{
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## ## Example 1:
#' ## Calculate the 5.5%-, 50%-, and 94.5%-quantiles for the variate "bill lengt",
#' ## that is, the values of "bill length" having such cumulative probabilities
#'
#' quants <- qPr(Yname = 'bill_len', K = K)
#'
#' ## display the quantile values
#' quants$values
#'
#' ## verify these values, within numerical error, using Pr():
#' probs <- Pr(
#'   Y = data.frame(bill_len = c(quants$values)),
#'   tails = list(bill_len = -1),
#'   K = K
#' )
#' probs$values
#'
#' ## display the revisability about the quantiles
#' quants$quantiles
#'
#'
#' ## ## Example 2:
#' ## Calculate the 5.5%-, 50%-, and 94.5%-quantiles for the variate "bill lengt",
#' ## for the subpopulation of species 'Adelie'
#'
#' quants <- qPr(Yname = 'bill_len', X = data.frame(species = 'Adelie'), K = K)
#'
#' ## display the quantile values
#' quants$values
#'
#' ## verify these values, within numerical error, using Pr():
#' probs <- Pr(
#'   Y = data.frame(bill_len = c(quants$values)),
#'   X = data.frame(species = 'Adelie'),
#'   tails = list(bill_len = -1),
#'   K = K)
#' probs$values
#' }
#'
#' @import parallel
#' @import utils
#' @import stats
#'
#' @concept probability
#' @export
qPr <- function(
    p = c(0.25, 0.5, 0.75),
    Yname,
    X = NULL,
    K,
    tails = NULL,
    ## priorY = NULL,
    nsamples = 'all',
    quantiles = c(0.055, 0.5, 0.945),
    parallel = TRUE,
    sep = ',',
    solidus = '|',
    verbose = FALSE,
    keepYX = TRUE,
    tol = .Machine$double.eps * 10

) {
    ## #' @param usememory Logical, default `TRUE`: save partial results to disc, to avoid excessive RAM use. (For the moment only possible value is `TRUE`.)
    usememory <- TRUE

    Qerror <- pnorm(c(-1, 1))

#### Requested parallel processing
    ## NB: doesn't make sense to have more cores than chains
    closeexit <- FALSE
    if (inherits(parallel, "cluster")){
        ## user provides a cluster object
        ## use only as many nodes as necessary
        ncores <- length(parallel)
        cl <- parallel
    } else if (isTRUE(parallel)) {
        ## user wants us to register a parallel backend
        ## and to choose number of cores
        ncores <- getOption("cl.cores", 2)
        cl <- parallel::makeCluster(ncores)
        closeexit <- TRUE
        if(verbose){message('Registered ', capture.output(print(cl)), '.')}
    } else if (isFALSE(parallel)) {
        ## user wants us not to use parallel cores
        ncores <- 1
        cl <- parallel::makeCluster(ncores)
        closeexit <- TRUE
    } else if (is.numeric(parallel) &&
                   is.finite(parallel) && parallel >= 1) {
        ## user wants us to register 'parallel' # of cores
        ncores <- parallel
        cl <- parallel::makeCluster(ncores)
        closeexit <- TRUE
        if(verbose){message('Registered ', capture.output(print(cl)), '.')}
    } else {
        stop("Unknown value of argument 'parallel'.")
    }

    ## Close parallel connections if any were opened
    if(closeexit) {
        closecoresonexit <- function(){
            if(verbose){message('Closing connections to cores.')}
            parallel::stopCluster(cl)
            ## parallel::setDefaultCluster(NULL)
        }
        on.exit(closecoresonexit())
    }

    ## Extract Monte Carlo output & auxmetadata
    ## If K is a string, check if it's a folder name or file name
    Kname <- deparse(substitute(K))
    if (is.character(K)) {
        ## Check if 'K' is a folder containing K.rds
        if (file_test('-d', K) &&
                file.exists(file.path(K, 'K.rds'))) {
            K <- readRDS(file.path(K, 'K.rds'))
        } else {
            ## Assume 'K' the full path of K.rds
            ## possibly without the file extension '.rds'
            K <- paste0(sub('.rds$', '', K), '.rds')
            if (file.exists(K)) {
                K <- readRDS(K)
            } else {
                stop("The argument 'K' must be a folder containing 'K.rds', or the path to an rds-file containing the output from 'learn()'.")
            }
        }
    }

    ## Add check to see that K is correct type of object?
    auxmetadata <- K$auxmetadata
    K$auxmetadata <- NULL
    K$auxinfo <- NULL
    ncomponents <- nrow(K$W)
    nmcsamples <- ncol(K$W)

    if(is.null(nsamples)){
        nsamples <- 0
    } else if(is.numeric(nsamples)){
        if(is.na(nsamples) || nsamples < 1) {
            nsamples <- NULL
        } else if(!is.finite(nsamples)) {
            nsamples <- nmcsamples
        }
    } else if (is.character(nsamples) && nsamples == 'all'){
        nsamples <- nmcsamples
    }


    if(length(Yname) > 1){stop('Specify only one variate in "Yname".')}

    if(all(is.na(X))){X <- NULL}
    if(!is.null(X)){X <- as.data.frame(X)}
    Xv <- colnames(X)

    if(!is.null(tails)){
        tails <- as.list(tails)
        if(is.null(names(tails))) {
            stop('Missing variate names in "tails"')
        }
    }

    tailscentre <- list('==', 0, '0', NULL)
    tailsleft <- list('<=', -1, '-1', 'left', 'lower')
    tailsright <- list('>=', 1, '+1', 'right', 'upper')
    tailsvalues <- c(tailscentre, tailsleft, tailsright)

    ## Consistency checks

    if(!all(Yname %in% auxmetadata$name)){
        stop('unknown Y variate ',
            paste0(Yname[!(Yname %in% auxmetadata$name)], collapse = ' '),
            '\n')
    }
    if(auxmetadata[auxmetadata$name == Yname, 'mcmctype'] %in% c('B', 'N')){
        stop('quantiles are undefined for binary and nominal variates.')
    }
    if(anyDuplicated(Yname)){
        stop('duplicate Y variates\n')
    }

    if(!all(Xv %in% auxmetadata$name)){
        stop('unknown X variate ',
            paste0(Xv[!(Xv %in% auxmetadata$name)], collapse = ' '),
            '\n')
    }
    if(anyDuplicated(Xv)){
        stop('duplicate X variates\n')
    }

    if(anyDuplicated(c(Yname, Xv))){
        stop('overlap in Y and X variates\n')
    }

    tailsv <- names(tails)
    if(!all(tailsv %in% Xv)){
        warning('"tails" variate ',
            paste0(tailsv[!(tailsv %in% Xv)], collapse = ' '),
            ' not among X; ignored\n')
        tails <- tails[(tailsv %in% Xv)]
        tailsv <- names(tails)
    }
    if(anyDuplicated(tailsv)){
        stop('duplicate "tails" variates\n')
    }
    if(!all(tails %in% tailsvalues)){
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

#### 'priorY' Reserved for future use
    priorY <- NULL
    ## Check if a prior for Y is given, in that case Y and X will be swapped
    if(!is.null(priorY) && (isFALSE(priorY) || any(is.na(priorY)))){
        priorY <- NULL
    }

    if(!is.null(priorY)){
        ## Conditions for using priorY
        if(is.null(X)){ stop("'X' must be non-null if 'priorY' is given") }

        if(anyDuplicated(Y)){
            stop("All rows in 'Y' must be unique if 'priorY' is given")
        }

        ## if priorY is TRUE, the user wants a uniform prior distribution
        if(isTRUE(priorY)){
            priorY <- 1 + numeric(nrow(Y))
        }
        if(length(priorY) != nrow(Y)){
            stop("'priorY' must have as many entries as rows of 'Y'")
        }
        if(!is.numeric(priorY) || any(priorY < 0)) {
            stop("'priorY' contains invalid probabilities")
        }

        ## Swap X and Y, to use Bayes's theorem
        ## And consider all values of Y, if it only has discrete variates
        . <- Y
        Y <- X
        X <- .
        ## ## ## Alternative version: calculate for all possible Y-values,
        ## ## ## if Y has finite domain
        ## ## 'X' used below will contain all values of the original Y-variates
        ## if(all(auxmetadata[auxmetadata$name %in% Yv, 'mcmctype'] %in%
        ##            c('B', 'O', 'N'))){
        ##     X <- do.call(what = expand.grid,
        ##         args = c(setNames(
        ##             object = lapply(X = Yv, FUN = vrtgrid,
        ##                 K = list(auxmetadata = auxmetadata)),
        ##             nm = Yv),
        ##             list(KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
        ##         ) )
        ##
        ##     Ytokeep <- match(do.call(paste0, Y0), do.call(paste0, X))
        ##
        ## } else {
        ##     X <- Y0
        ##     Ytokeep <- TRUE
        ## }

        . <- Yv
        Yv <- Xv
        Xv <- .
        rm(.)
        gc(full = TRUE)

    }

    nY <- length(p)
    nX <- max(nrow(X), 1L)
    auxY <- auxmetadata[auxmetadata$name == Yname, ]

#### tmp dir where to save X and Y objects
    temporarydir <- tempdir()


#### Calculate and save arrays for X values:
    if (is.null(X)) {
        lprobX <- log(K$W)
        saveRDS(lprobX,
            file.path(temporarydir,
                paste0('__X', 1, '__.rds'))
        )
    } else {
        ## Construction of the arguments for util_lprobs, X argument
        lpargs <- .lprobsargsyx(
            x = X,
            auxmetadata = auxmetadata,
            K = K,
            tails = tails
        )

        invisible(parallel::parLapply(cl = cl,
            X = lpargs$xVs,
            fun = .lprobsbase,
            params = lpargs$params,
            logW = c(log(K$W)),
            temporarydir = temporarydir,
            lab = '__X'
        ))
    }

#### Determine the type of Y variate, set params accordingly
    if(auxY$mcmctype == 'O'){
        params1 = log(apply(
            K$Oprob[auxY$indexpos + seq_len(auxY$Nvalues), ,],
            c(2, 3), cumsum
        ))
        params2 <- NULL
        util_qYX <- .qYXdiscr
    } else if(auxY$mcmctype == 'R'){
        params1 <- K$Rmean[auxY$id, ,]
        params2 <- K$Rsd[auxY$id, ,]
        util_qYX <- .qYXcont
    } else if(auxY$mcmctype == 'D'){
        params1 <- K$Dmean[auxY$id, ,]
        params2 <- K$Dsd[auxY$id, ,]
        util_qYX <- .qYXcont
    } else if(auxY$mcmctype == 'C'){
        params1 <- K$Cmean[auxY$id, ,]
        params2 <- K$Csd[auxY$id, ,]
        util_qYX <- .qYXcont
    } else {
        stop('type of Yname not found')
    }

#### Calculation with all pY and X combinations
    ## keys <- c('values', 'quantiles', 'samples', 'values.MCaccuracy', 'quantiles.MCaccuracy')
    keys <- c('values', 'quantiles', 'samples')
    ##
    combfnr <- function(...){setNames(do.call(mapply,
        c(FUN = `rbind`, lapply(X = ..., FUN = `[`, keys, drop = FALSE))),
        keys)}
    ## combfnc <- function(...){setNames(do.call(mapply, c(FUN=cbind, lapply(list(...), `[`, keys))), keys)}

    doquantiles <- !is.null(quantiles)
    dosamples <- (nsamples > 0)

    out <- combfnr(apply(#parallel::parApply(cl = cl,
            X = expand.grid(pY = p, jx = seq_len(nX)),
            MARGIN = 1,
            FUN = util_qYX,
            params1 = params1, params2 = params2,
            auxmetadata = auxY,
            temporarydir = temporarydir, usememory = usememory,
            doquantiles = doquantiles, quantiles = quantiles,
            dosamples = dosamples, nsamples = nsamples,
            Qerror = Qerror,
            tol = tol
    ))

    ## clean temp files
    if(usememory) {
        unlink(x = sapply(seq_len(nX), function(jx){
            file.path(temporarydir, paste0('__X', jx, '__.rds'))
            }))
    }


    ## if(is.null(priorY)){
    ##     y <- Y
    ##     y[, colnames(Y) %in% tailsv] <- NA
    ##     jacobians <- exp(rowSums(
    ##         as.matrix(.vtransform(y,
    ##             auxmetadata = auxmetadata,
    ##             logjacobianOr = TRUE)),
    ##         na.rm = TRUE
    ##     ))
    ##     rm(y)
    ## }

    ## transform to grid
    ## in the output-list elements the Y & X values are the rows
    dim(out$values) <- c(nY, nX)

    if(nsamples > 0){
        dim(out$samples) <- c(nY, nX, nsamples)
    }

    if(doquantiles){
        dim(out$quantiles) <- c(nY, nX, length(quantiles))
    }


    ## report whether the probabilities are 'tails' or not
    if(!is.null(tails)){
        outtails <- list()
        outtails[colnames(X)] <- ''
        outtails[names(tails)[tails == -1]] <- '>'
        outtails[names(tails)[tails == 1]] <- '<'
    } else {
        outtails <- NULL
    }


    ## Dimension & value names for variates
    Ynames <- setNames(object = list(p), nm = Yname)

    if(!is.null(X)){
        Xnames <- setNames(object = list(
            apply(X = X, MARGIN = 1, FUN = paste0, collapse = sep,
                simplify = TRUE)),
            nm = paste0(solidus,
                paste0(colnames(X), outtails[colnames(X)], collapse = sep)) )
    } else {
        Xnames <- list(NULL)
    }

    dimnames(out$values) <- c(Ynames, Xnames)

    if(doquantiles){
        temp <- list(Q = names(quantile(x = NA, probs = quantiles,
            names = TRUE, na.rm = TRUE)))
        dimnames(out$quantiles) <- c(Ynames, Xnames, temp)
    }

    if(dosamples){
        temp <- list(sample = round(seq(1, nmcsamples, length.out = nsamples)))
        dimnames(out$samples) <- c(Ynames, Xnames, temp)
    }

    if(isTRUE(keepYX)){
        ## save Y and X values in the output; useful for plotting methods
        if(is.null(priorY)){
            out$pY <- Ynames
            out$X <- X
        } else {
            out$Y <- X
            out$X <- Y
            }
    }
    if(!is.null(outtails)){
        out$tails <- outtails[!(outtails == '')]
    }
    out$K <- Kname

    class(out) <- 'probability'
    out
}


#' Calculate quantiles for continuous Y by bisection
#'
#' Used in 'qPr()'.
#'
#' @import stats
#'
#' @keywords internal
.qYXcont <- function(
    iyx,
    params1, params2,
    auxmetadata,
    temporarydir, usememory = TRUE,
    doquantiles, quantiles,
    dosamples, nsamples,
    Qerror,
    tol = .Machine$double.eps * 3
){
    pY <- iyx['pY']

    if(usememory) {
        lprobX <- readRDS(file.path(temporarydir,
            paste0('__X', iyx['jx'], '__.rds')
        ))
    }
    sumlpX <- colSums(exp(lprobX), na.rm = TRUE)

    nmaxsamples <- ncol(params1)

#### Calculate quantile for the posterior probability distribution

    Yvals <- .Machine$double.xmax * c(-0.125, 0.125)

    values <- (Yvals[1] + Yvals[2]) / 2

    FF <- mean(colSums(exp(
        lprobX + pnorm(q = values, mean = params1, sd = params2,
            lower.tail = TRUE, log.p = TRUE)
    ), na.rm = TRUE) / sumlpX) - pY

    while(abs(FF) > tol && Yvals[2] - Yvals[1] > tol){
        Yvals[(FF > 0) + 1L] <- values
        values <- (Yvals[1] + Yvals[2]) / 2
        FF <- mean(colSums(exp(
            lprobX + pnorm(q = values,
                mean = params1, sd = params2,
                lower.tail = TRUE, log.p = TRUE)
        ), na.rm = TRUE) / sumlpX) - pY
    }

    values <- unname(unlist(.vtransform(values,
        auxmetadata = auxmetadata,
        Rout = 'original',
        Cout = 'original',
        Dout = 'original',
        Oout = 'original',
        Nout = 'original',
        Bout = 'original',
        variates <- auxmetadata$name,
        logjacobianOr = NULL)))

#### Calculate quantile for the frequency samples
    if(doquantiles){
        selsamples <- TRUE
    } else if(dosamples) {
        nmaxsamples <- nsamples
        selsamples <- round(seq(1, ncol(params1), length.out = nsamples))
    }

    if(doquantiles || dosamples) {
        params1 <- t(params1[, selsamples])
        params2 <- t(params2[, selsamples])
        lprobX <- t(lprobX[, selsamples])

        Yvals <- rep.int(x = .Machine$double.xmax * c(-0.125, 0.125),
            times = rep.int(x = nmaxsamples, times = 2))
        dim(Yvals) <- c(nmaxsamples, 2)
        sampleseq <- 1:nmaxsamples

        samples <- (Yvals[, 1] + Yvals[, 2]) / 2
        FF <- rowSums(exp(
            lprobX + pnorm(q = samples,
                mean = params1, sd = params2,
                lower.tail = TRUE, log.p = TRUE)
        ), na.rm = TRUE) / sumlpX - pY

        tocheck <- abs(FF) > tol
        while(any(tocheck)) {
            choose <- c(sampleseq[tocheck], (FF[tocheck] > 0) + 1L)
            dim(choose) <- c(sum(tocheck), 2)
            Yvals[choose] <- samples[tocheck]
            samples[tocheck] <- (Yvals[tocheck, 1] + Yvals[tocheck, 2]) / 2
            FF <- rowSums(exp(
                lprobX + pnorm(q = samples,
                    mean = params1, sd = params2,
                    lower.tail = TRUE, log.p = TRUE)
            ), na.rm = TRUE) / sumlpX - pY
        tocheck <- abs(FF) > tol & Yvals[, 2] - Yvals[, 1] > tol
        }
        samples <- unname(unlist(.vtransform(samples,
            auxmetadata = auxmetadata,
            Rout = 'original',
            Cout = 'original',
            Dout = 'original',
            Oout = 'original',
            Nout = 'original',
            Bout = 'original',
            variates <- auxmetadata$name,
            logjacobianOr = NULL)))
    }

    list(
        values = values,
        ##
        quantiles = if(doquantiles) {
            quantile(x = samples, probs = quantiles, type = 6,
                na.rm = TRUE, names = FALSE)
        },
        ##
        samples = if(dosamples) {
            samples[round(seq(1, length(samples), length.out = nsamples))]
        }
        ## values.MCaccuracy
        ## quantiles.MCaccuracy
)
}


#' Calculate quantiles for discrete Y by bisection
#'
#' Used in 'qPr()'.
#'
#' @import stats
#'
#' @keywords internal
.qYXdiscr <- function(
    iyx,
    params1, params2,
    auxmetadata,
    temporarydir, usememory = TRUE,
    doquantiles, quantiles,
    dosamples, nsamples,
    Qerror = NULL,
    tol = NULL
){
    pY <- iyx['pY']

    if(usememory) {
        lprobX <- readRDS(file.path(temporarydir,
            paste0('__X', iyx['jx'], '__.rds')
        ))
    }
    sumlpX <- colSums(exp(lprobX), na.rm = TRUE)

    nmaxsamples <- dim(params1)[3]
    Nvalues <- auxmetadata$Nvalues

#### Calculate quantile for the posterior probability distribution

    values <- 1L

    FF <- mean(colSums(exp(
        lprobX + params1[values, ,]
    ), na.rm = TRUE) / sumlpX)

    while(FF < pY && values <= Nvalues){
        values <- values + 1L
        FF <- mean(colSums(exp(
            lprobX + params1[values, ,]
        ), na.rm = TRUE) / sumlpX)
    }
    values <- unname(unlist(.vtransform(values,
        auxmetadata = auxmetadata,
        Rout = 'original',
        Cout = 'original',
        Dout = 'original',
        Oout = 'original',
        Nout = 'original',
        Bout = 'original',
        variates <- auxmetadata$name,
        logjacobianOr = NULL)))

#### Calculate quantile for the frequency samples
    if(doquantiles){
        selsamples <- TRUE
    } else if(dosamples) {
        nmaxsamples <- nsamples
        selsamples <- round(seq(1, ncol(params1), length.out = nsamples))
    }

    if(doquantiles || dosamples) {
        params1 <- aperm(a = params1[, , selsamples],
            perm = c(1, 3, 2), resize = TRUE)
        lprobX <- t(lprobX[, selsamples])

        samples <- rep.int(x = 1L, times = nmaxsamples)

        i <- 1L

        FF <- rowSums(exp(
            lprobX + params1[i, ,]
        ), na.rm = TRUE) / sumlpX

        tocheck <- FF < pY
        while(any(tocheck)) {
            i <-  i + 1L
            samples[tocheck] <- i
            FF <- rowSums(exp(
            lprobX + params1[i, ,]
            ), na.rm = TRUE) / sumlpX
            tocheck <- FF < pY
        }
        samples <- unname(unlist(.vtransform(samples,
            auxmetadata = auxmetadata,
            Rout = 'original',
            Cout = 'original',
            Dout = 'original',
            Oout = 'original',
            Nout = 'original',
            Bout = 'original',
            variates <- auxmetadata$name,
            logjacobianOr = NULL)))
    }

    list(
        values = values,
        ##
        quantiles = if(doquantiles) {
            quantile(x = samples, probs = quantiles, type = 6,
                na.rm = TRUE, names = FALSE)
        },
        ##
        samples = if(dosamples) {
            samples[round(seq(1, length(samples), length.out = nsamples))]
        }
        ## values.MCaccuracy
        ## quantiles.MCaccuracy
)
}
