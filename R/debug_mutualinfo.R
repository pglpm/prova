#' Calculate mutual information between groups of joint variates
#'
#' @description This function calculates various entropic information measures between two grops of joint variates: the mutual information, the conditional entropies, and the entropies.
#'
#' @details If \eqn{Y_1} and \eqn{Y_2} are two variates, each of which can be a joint variate such as \eqn{Y_1 = (Y_{1,1}, Y_{1,2}, \dotsc)}, and \eqn{X} a third, also possibly join, variate, then the mutual information \eqn{\mathit{MI}} between \eqn{Y_1} and \eqn{Y_2}, conditional on \eqn{X = x}, is given by
#' \deqn{\mathit{MI}(Y_1, Y_2 \vert X = x) \mathrel{:=}
#' \sum_{y_1, y_2}
#' \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, \text{data})
#' \log_2\frac{
#' \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, \text{data})
#' }{
#' \mathrm{Pr}(Y_1 = y_1 \vert X = x, \text{data})
#' \cdot
#' \mathrm{Pr}(Y_2 = y_2 \vert X = x, \text{data})
#' } \, \mathrm{Sh}
#' }
#' an expression which can also be written in several other equivalent ways. It is an information-theoretic measure of association that is model-free, that is, does not depend on assumptions such as linearity, gaussianity, and similar. See `vignette('mutualinfo')` for discussion and example uses, and also the "References" section.  If \eqn{Y_1, Y_2} are *jointly gaussian variates*, then there is a mathematical correspondence between their mutual information and their Pearson correlation coefficient; see output `MI.rGauss` in the "Value" section.
#'
#' The conditional entropy of \eqn{Y_1} with respect to \eqn{Y_2}, conditional on \eqn{X = x}, is given by
#' \deqn{\mathit{CondEn12}(Y_1, Y_2 \vert X = x) \mathrel{:=}
#' -\sum_{y_1, y_2}
#' \mathrm{Pr}(Y_1 = y_1 \vert Y_2 = y_2, X = x, \text{data})
#' \log_2
#' \mathrm{Pr}(Y_1 = y_1 \vert Y_2 = y_2, X = x, \text{data})
#' \cdot
#' \mathrm{Pr}(Y_2 = y_2 \vert X = x, \text{data})
#' \, \mathrm{Sh}
#' }
#'
#' The (differential) entropy of \eqn{Y_1}, conditional on \eqn{X = x}, is given by
#' \deqn{\mathit{En1}(Y_1 \vert X = x) \mathrel{:=}
#' -\sum_{y_1}
#' \mathrm{Pr}(Y_1 = y_1 \vert X = x, \text{data})
#' \log_2
#' \mathrm{Pr}(Y_1 = y_1 \vert  X = x, \text{data})
#' \, \mathrm{Sh}
#' }
#'
#' see "References" section for discussions about entropy and conditional entropy.
#'
#' The function `mutualinfo()` calculates the quantities above for the joint variates specified in the arguments `Y1names` and `Y2names`, conditional on the values of the variates specified in the data frame `X`. If `X` is omitted or `NULL`, then the posterior probabilities \eqn{\mathrm{Pr}(Y_1 | \text{data})} etc. are used. Each variate in the argument `X` can be specified either as a point-value \eqn{X = x} or as a left-open interval \eqn{X \le x} or as a right-open interval \eqn{X \ge x}, through the argument `tails`.
#'
#' The computation of these quantities is done via Monte Carlo integration, using the samples produced by the [learn()] function. The present function also output the numerical error associated with this computation.
#'
#' @param Y1names Character vector: first group of joint variates
#' @param Y2names Character vector or `NULL`: second group of joint variates
#' @param X Matrix or data.frame or `NULL`: values of some variates conditional on which we want the probabilities.
#' @param learnt Either a character with the name of a directory or full path
#'   for an 'learnt.rds' object, or such an object itself.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `X`. For variates in this list, the probability conditional is understood in a semi-open interval sense: \eqn{X \le x} or \eqn{X \ge x}, an so on. See analogous argument in [Pr()].
#' @param quantiles Numeric vector, between 0 and 1: desired quantiles of the revisability of the mutual information. Default `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5% quantiles. See similar argument in [Pr()].
#' @param ns Integer or `Inf` or `NULL` (default): number of Monte Carlo samples in the "learnt" object to use for calculating the mutual information. If `Inf` or `NULL`, use all Monte Carlo samples available in the "learnt" object.
#' @param nv Integer, default 12: number of *duplicates* of Monte Carlo samples in the "learnt" object to use for calculating the revisability of the mutual information.
#' @param unit Either one of 'Sh' for *shannon* (default), 'Hart' for *hartley*, 'nat' for *natural unit*, or a positive real indicating the base of the logarithms to be used.
#' @param parallel Logical or positive integer or cluster object. `TRUE` (default): use roughly half of available cores; `FALSE`: use serial computation; integer: use this many cores. It can also be a cluster object previously created with [parallel::makeCluster()]; in this case the parallel computation will use this object.
#' @param verbose Logical, default `FALSE`: give messages about parallel processing?
#'
#' @return An object of class "MI", which is a list consisting of the following elements:
#'
#' - `$value`, the mutual information between (joint) variates `Y1names` and (joint) variates `Y2names`.
#' - `$quantiles`, a vector with the revisability quantiles for the mutual information.
#' - `$MCaccuracy`, vector with the numerical accuracies (roughly speaking a standard deviation) of the Monte Carlo calculation for the `value` of the mutual information.
#' - `$samples`, a vector with the revisability samples for the mutual information.
#' - `$rGauss`, a vector of `value` and `accuracy`: the absolute value of the Pearson correlation coefficient \eqn{r} of a *multivariate Gaussian distribution* having mutual information `MI`; the two are related by \eqn{\mathrm{MI} = -\ln(1 - r^2)/2}. It may provide a vague intuition for the `MI` value for people more familiar with Pearson's correlation, but should be taken with a grain of salt.
#' - `$unit`, `$Y1names`, `$Y1names`: same as the input arguments.
#'
#' @seealso
#' [Pr()] to calculate probabilities and their revisability.
#'
#' [learn()], which generates the `learnt` objects required by `mutualinfo()`.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## mutual information between variates 'species' and 'bill_len'
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
#'   learnt = learnt, nv = 2, parallel = 1)
#'
#' ## The value:
#' MI$value
#'
#' ## If we had many more data, we could instead expect to obtain values
#' ## within the following ranges, with corresponding probabilities:
#' MI$quantiles
#'
#' @importFrom extraDistr rcatlp
#' @importFrom extraDistr rbern
#' @import parallel
#' @import stats
#' @import utils
#'
#' @keywords debug
#' @noRd
debug_mutualinfo <- function(
    Y1names,
    Y2names = NULL,
    X = NULL,
    learnt,
    tails = NULL,
    quantiles =  c(0.055, 0.25, 0.75, 0.945),
    ns = NULL,
    nv = 12,
    unit = 'Sh',
    parallel = TRUE,
    verbose = FALSE
){
#### Mutual information and conditional entropy between Y2 and Y1
#### conditional on X, data, prior information
#### are calculated by Monte Carlo integration:
#### 0. adjusted component weights are calculated for conditioning on X:
####     all probabilities below are conditional on X & data & prior
#### 1. joint samples of Y1_i, Y2_i are drawn
#### 2. probabilities p(Y1|Y2) are calculated for each sample
####    the conditional entropy is Monte-Carlo approximated by
####    H(Y1|Y2) = - sum_{i} log p(Y1_i | Y2_i)
#### 3. probabilities p(Y1) are calculated for each sample
####    the entropy is Monte-Carlo approximated by
####    H(Y1) = - sum_{i} log p(Y1_i)
#### 4. the mutual info is Monte-Carlo approximated by
####    I(Y1|Y2) = sum_{i} [log p(Y1_i | Y2_i) - log p(Y1_i)]
####           = -H(Y1|Y2) + H(Y1)
####
#### For these computations it is not necessary to transform the Y1,Y2 variates
#### from the internal Monte Carlo representation to the original one

#### Requested parallel processing
    ## NB: doesn't make sense to have more cores than chains
    closeexit <- FALSE
    if ('cluster' %in% class(parallel)){
        ## user provides a cluster object
        cl <- parallel
    } else if (isTRUE(parallel)) {
        ## user wants us to register a parallel backend
        ## and to choose number of cores
        ncores <- max(1,
            floor(parallel::detectCores() / 2))
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

    ## Extract Monte Carlo output & aux-metadata
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
                stop("The argument 'learnt' must be a folder containing learnt.rds, or the path to an rds-file containing the output from 'learn()'.")
            }
        }
    }
    ## Add check to see that learnt is correct type of object?
    auxmetadata <- learnt$auxmetadata
    learnt$auxmetadata <- NULL
    learnt$auxinfo <- NULL
    ncomponents <- nrow(learnt$W)
    nmcs <- ncol(learnt$W)

    if(is.null(ns) || !is.finite(ns) || ns == 'all'){ ns <- nmcs }
    ns <- max(min(ns, nmcs), 2)
    if(is.null(nv) || !is.finite(nv)){ nv <- 2 }
    nv <- max(nv, 2)

    ntot <- ns *nv

    sseq <- sort(sample.int(nmcs, ns))

    if(all(is.na(X))){X <- NULL}
    if(!is.null(X)){
        X <- as.data.frame(X)
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
    if (unit == 'Sh') {
        lbase <- log(2)
    } else if (unit == 'Hart') {
        lbase <- log(10)
    } else if (unit == 'nat') {
        lbase <- 1
    } else if (is.numeric(unit) && unit > 0) {
        lbase <- log(unit)
    } else {
        stop("unit must be 'Sh', 'Hart', 'nat', or a positive real")
    }

    if(!is.character(Y1names) || any(is.na(Y1names))){
        stop('Y1names must be a vector of variate names')
    }
    if(!is.null(Y2names) && (!is.character(Y2names) || any(is.na(Y2names)))){
        stop('Y2names must be NULL or a vector of variate names')
    }

    ## More consistency checks
    if(!all(Y1names %in% auxmetadata$name)) {
        stop('unknown Y1 variates\n')
    }
    if(length(unique(Y1names)) != length(Y1names)) {
        stop('duplicate Y1 variates\n')
    }
    ##
    if(!is.null(Y2names) && !all(Y2names %in% auxmetadata$name)){
        stop('unknown Y2 variates\n')
    }
    if(length(unique(Y2names)) != length(Y2names)) {
        stop('duplicate Y2 variates\n')
    }


    if (!all(Xv %in% auxmetadata$name)) {
        stop('unknown X variates\n')
    }
    if (length(unique(Xv)) != length(Xv)) {
        stop('duplicate X variates\n')
    }
    ##
    if(any(Y1names %in% Y2names)) {
        stop('overlap in Y1 and Y2 variates\n')
    }
    if(any(Y1names %in% Xv)) {
        stop('overlap in Y1 and X variates\n')
    }
    if(any(Y2names %in% Xv)) {
        stop('overlap in Y2 and X variates\n')
    }

    if (!all(tailsv %in% Xv)) {
        warning('variate ',
            paste0(tailsv[!(tailsv %in% Xv)], collapse = ' '),
            ' not among X; ignored\n')
        tails <- tails[tailsv %in% Xv]
        tailsv <- names(tails)
    }
    if (length(unique(tailsv)) != length(tailsv)) {
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


#### Step 0. Adjust component weights W for conditioning on X
    if(is.null(X)){
        lW <- log(learnt$W)
    } else {
        lpargs <- util_lprobsargsyx(
            x = X,
            auxmetadata = auxmetadata,
            learnt = learnt,
            tails = tails
        )

        lW <- util_lprobsbase(
            xVs = lpargs$xVs[[1]],
            params = lpargs$params,
            logW =  log(learnt$W)
        ) # rows=components, columns=samples

    } # end definition of lW if non-null X

#### Combine Y1,Y2 into single Y for speed
    Ynames <- c(Y1names, Y2names)

#### STEP 1. Draw samples of Ynames (that is, Y1names,Y2names)

    ## extraDistr::rcatlp() can use non-normalized probabilities
    ## NOTA BENE: the '1 - ...' is because of a possible bug in rcatlp()
    Ws <- 1 - extraDistr::rcatlp(1, 0) +
        extraDistr::rcatlp(n = ntot, log_prob = t(lW[, sseq, drop = FALSE]))
    ## ## Old version with extraDistr::cat(), can be 10 times slower
    ## Ws <- extraDistr::rcat(n = n, prob = t(
    ##     apply(X = lWnorm[, sseq, drop = FALSE], MARGIN = 2, FUN = function(xx){
    ##         xx <- exp(xx)
    ##         xx / sum(xx, na.rm = TRUE)
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
        totake <- cbind(rep.int(x = aux$id, times = rep(ntot, nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
                mean = learnt$Rmean[totake],
                sd = learnt$Rsd[totake] )
        )
    }

    ## C
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'C'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep.int(x = aux$id, times = rep(ntot, nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
                mean = learnt$Cmean[totake],
                sd = learnt$Csd[totake] )
        )
    }

    ## D
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'D'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep.int(x = aux$id, times = rep(ntot, nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
                mean = learnt$Dmean[totake],
                sd = learnt$Dsd[totake] )
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
            totake <- cbind(Ws, sseq)
            Yout <- c(Yout,
                extraDistr::rcat(n = ntot,
                    prob = apply(
                        X = learnt$Oprob[aux$indexpos + seq_len(aux$Nvalues), ,],
                        MARGIN = 1, FUN = `[`, totake,
                        simplify = TRUE) )
            )
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
            totake <- cbind(Ws, sseq)
            Yout <- c(Yout,
                extraDistr::rcat(n = ntot,
                    prob = apply(
                        X = learnt$Nprob[aux$indexpos + seq_len(aux$Nvalues), ,],
                        MARGIN = 1, FUN = `[`, totake,
                        simplify = TRUE) )
            )
        }
    }

    ## B
    toselect <- which((auxmetadata$name %in% Ynames) &
                          (auxmetadata$mcmctype == 'B'))
    nvrt <- length(toselect)
    if(nvrt > 0){
        aux <- auxmetadata[toselect, ]
        vYout <- c(vYout, aux$name)
        totake <- cbind(rep.int(x = aux$id, times = rep(ntot, nvrt)), Ws, sseq)
        Yout <- c(Yout,
            extraDistr::rbern(n = ntot * nvrt,
                prob = learnt$Bprob[totake])
        )
    }

    dim(Yout) <- c(ntot, length(Ynames))
    Yout <- Yout[, match(Ynames, vYout), drop = FALSE]
    colnames(Yout) <- Ynames

    Yout <- vtransform(Yout,
        auxmetadata = auxmetadata,
        Rout = 'original',
        Cout = 'original',
        Dout = 'original',
        Oout = 'original',
        Nout = 'original',
        Bout = 'original',
        logjacobianOr = NULL)
    ## The rows of Yout corresponds to nv repetitions of ns MCsamples, eg:
    ## MCsample 3
    ## MCsample 5
    ## MCsample 8
    ## MCsample 3 again
    ## MCsample 5 again
    ## MCsample 8 again
    # etc

    Y1transf <- Yout[, Y1names, drop = FALSE]
    Y2transf <- Yout[, Y2names, drop = FALSE]
    rm(Yout)
    gc(full = TRUE)


#### STEP 2. Calculate, for each generated datapoint:
#### log2_p(Y1|Y2),
#### log2_p(Y2|Y1)
#### log2_p(Y1)
#### log2_p(Y2)

    ## Keep track of the MC-sample id of each datapoint
    ids <- rep.int(x = sseq, times = nv)

    lpargs1 <- util_lprobsargsyx(
        x = Y1transf,
        auxmetadata = auxmetadata,
        learnt = learnt,
        tails = NULL,
        ids = ids
    )

    lpargs2 <- util_lprobsargsyx(
        x = Y2transf,
        auxmetadata = auxmetadata,
        learnt = learnt,
        tails = NULL,
        ids = ids
    )

    ## each instance of util_lprobsmi() takes one datapoint
    out <- do.call(rbind,
        parallel::parLapply(cl = cl,
            X = mapply(c, lpargs1$xVs, lpargs2$xVs, SIMPLIFY = FALSE),
            fun = util_lprobsmi,
            params1 = lpargs1$params,
            params2 = lpargs2$params,
            lW = lW)
    )
    ## 'out' is a matrix with as many rows as the datapoints,
    ## and with columns corresponding to
    ## their probabilities (calculated from all MC samples)
    ## and their "limit frequencies" (calculated from MC samples
    ## from which the corresponding input datapoints were drawn)

    ## ## Jacobian factors unneeded because we only output the MI
    ## logjacobians1 <- rowSums(
    ##     as.matrix(vtransform(Y1transf,
    ##         auxmetadata = auxmetadata,
    ##         logjacobianOr = FALSE)),
    ##     na.rm = TRUE)
    ##
    ## logjacobians2 <- rowSums(
    ##     as.matrix(vtransform(Y2transf,
    ##         auxmetadata = auxmetadata,
    ##         logjacobianOr = FALSE)),
    ##     na.rm = TRUE)

    ## Separate columns for MI with columns for its revisability
    outva <- out[, 'fMI']
    ## ids <- out[,3] # for debugging
    ## dim(ids) <- c(ns, nv) # for debugging
    out <- out[, 'pMI']

    dim(outva) <- c(ns, nv)
    outva <- rowMeans(x = outva, na.rm = TRUE)
    outva[outva < 0] <- 0

    ## Output
    MI <- mean(out)
    if(MI < 0){ MI <- 0 }
    out <- list(
        value = MI / lbase,
        quantiles = quantile(outva, probs = quantiles,
            type = 6, na.rm = TRUE, names = TRUE) / lbase,
        MCaccuracy = sd(out, na.rm = TRUE) / (sqrt(ntot) * lbase),
        samples = outva / lbase,
        rGauss = sqrt(1 - exp(-2 * MI)),
        unit = unit,
        Y1names = Y1names,
        Y2names = Y2names
        ## , ids = rowMeans(ids) # for debugging
        )
    class(out) <- 'MI'
    out
}
