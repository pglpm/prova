#' Calculate mutual information between groups of joint variates
#'
#' @description Calculate the mutual information between two grops of joint variates, as well as its revisability.
#'
#' @details If \eqn{Y_1} and \eqn{Y_2} are two variates, each of which can be a joint variate such as \eqn{Y_1 = (Y_{1,1}, Y_{1,2}, \dotsc)}, and \eqn{X} a third, also possibly join, variate, then the mutual information \eqn{\mathit{MI}} between \eqn{Y_1} and \eqn{Y_2}, conditional on \eqn{X = x} and the knowledge \eqn{K} about data and metadata, is given by
#' \deqn{\mathit{MI}(Y_1, Y_2 \vert X = x) \mathrel{:=}
#' \sum_{y_1, y_2}
#' \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, K)
#' \log_2\frac{
#' \mathrm{Pr}(Y_1 = y_1, Y_2 = y_2 \vert X = x, K)
#' }{
#' \mathrm{Pr}(Y_1 = y_1 \vert X = x, K)
#' \cdot
#' \mathrm{Pr}(Y_2 = y_2 \vert X = x, K)
#' } \, \mathrm{Sh}
#' }
#' an expression which can also be written in several other equivalent ways. It is a model-free information-theoretic measure of association, that is, it does not depend on assumptions such as linearity, gaussianity, and similar. See `vignette('mutualinfo')` for discussion and example uses, and also the "References" section.  If \eqn{Y_1, Y_2} are *jointly gaussian variates*, then there is a mathematical correspondence between their mutual information and their Pearson correlation coefficient; see output `rGauss` in the "Value" section.
#'
#' The function `mutualinfo()` calculates the mutual information above for the joint variates specified in the arguments `Y1names` and `Y2names`, conditional on the values of the variates specified in the [data frame][base::data.frame()] `X`. If `X` is omitted or `NULL`, then the posterior probabilities \eqn{\mathrm{Pr}(Y_1 | K)} etc. are used. Each variate in the argument `X` can be specified either as a point-value \eqn{X = x} or as a left-open interval \eqn{X \le x} or as a right-open interval \eqn{X \ge x}, through the argument `tails`.
#'
#' The computation of these quantities is done via Monte Carlo integration, using the samples produced by the [learn()] function. The present function also output the numerical error associated with this computation. Note that the computation can take tens of minutes; it can be sped up by using more nodes (if available) in parallel, through the argument `parallel =`.
#'
#' @param Y1names Character vector: first group of joint variates
#' @param Y2names Character vector or `NULL`: second group of joint variates
#' @param X Matrix or data.frame or `NULL`: values of some variates conditional on which we want the probabilities.
#' @param K A "Knowledge" object produced by [learn()]. It can also be a path to a 'K.rds' file containing such object, or to a directory containing one.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `X`. For variates in this list, the probability conditional is understood in a semi-open interval sense: \eqn{X \le x} or \eqn{X \ge x}, an so on. See analogous argument in [Pr()].
#' @param quantiles Numeric vector, between 0 and 1: desired quantiles of the revisability of the mutual information. Default `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5% quantiles. See similar argument in [Pr()].
#' @param ns Integer or `Inf` or `NULL` (default): number of Monte Carlo samples in the "K" object to use for calculating the mutual information. If `Inf` or `NULL`, use all Monte Carlo samples available in the "K" object.
#' @param nv Integer, default 12: number of *duplicates* of Monte Carlo samples in the "K" object to use for calculating the revisability of the mutual information.
#' @param unit Either one of 'Sh' for *shannon* (default), 'Hart' for *hartley*, 'nat' for *natural unit*, or a positive real indicating the base of the logarithms to be used.
#' @param parallel One of the following values:
#' - A "cluster" object previously created with [parallel::makeCluster()].
#' - Positive integer: create a parallel cluster with this number of nodes (it will be stopped at the end).
#' - `FALSE`: do not use clusters (one node is still generated, in order to eliminate temporary objects from the computation).
#' - `TRUE` (default): use the cluster that was set as default with [parallel::setDefaultCluster()]; if no such object exists, then generate a cluster with as many nodes as in the [option][base::getOption()] "nc.cores"; if this option is unset, then use 2 nodes.
#' @param sep character, default `','`: character to separate the output's variate names and values.
#' @param solidus character, default `'|'`: character prepended to the output's names of the variates in the conditional (typically the `X` variates).
#' @param verbose Logical, default `FALSE`: give messages about parallel processing?
#' @param keepX Logical, default `TRUE`: keep a copy of the `X` argument in the output? This is used for [hist.mi()].
#'
#' @return An object of class "mi", which is a list consisting of the following elements:
#'
#' - `'value'`, the mutual information between (joint) variates `Y1names` and (joint) variates `Y2names`.
#' - `'quantiles'`, a vector with the revisability quantiles for the mutual information.
#' - `'value.acc'`, `quantiles.acc` number and vector with the numerical accuracies (roughly speaking a standard deviation) of the Monte Carlo calculation for the `'value'` and the `'quantiles'` elements.
#' - `'samples'`, a vector with the revisability samples for the mutual information.
#' - `'rGauss'`, a vector of `value` and `accuracy`: the absolute value of the Pearson correlation coefficient \eqn{r} of a *multivariate Gaussian distribution* having mutual information `MI`; the two are related by \eqn{\mathrm{MI} = -\ln(1 - r^2)/2}. It may provide a vague intuition for the `MI` value for people more familiar with Pearson's correlation, but should be taken with a grain of salt.
#' - `'unit'`, `'Y1names'`, `'Y1names'`, `'tails'`: copies of the homonymous input arguments.
#' - `'K'`: name of the "Knowledge" object used in the calculation.
#'
#' @seealso
#' [print.mi()] ] to plot mutual information and quantiles calculated by `mutualinfo()`
#'
#' [hist.mi()] to plot the revisability of the mutual information.
#'
#' [Pr()] to calculate probabilities and their revisability.
#'
#' [learn()], which generates the `K` objects required by `mutualinfo()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## mutual information between variates 'species' and 'bill_len'
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len', K = K, nv = 2)
#'
#' ## The value and its numerical Monte Carlo accuracy
#' c(MI$value, MI$value.acc)
#'
#' ## If we had many more data, we could instead expect to obtain values
#' ## within the following probable ranges:
#' signif(MI$quantiles, 3)
#'
#' @import parallel
#' @import stats
#' @import utils
#'
#' @concept association
#' @export
mutualinfo <- function(
    Y1names,
    Y2names,
    X = NULL,
    K,
    tails = NULL,
    quantiles =  c(0.055, 0.25, 0.75, 0.945),
    ns = NULL,
    nv = 12,
    unit = 'Sh',
    parallel = TRUE,
    sep = ',',
    solidus = '|',
    verbose = FALSE,
    keepX = TRUE
){
#### Mutual information between Y2 and Y1
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
    if (inherits(parallel, "cluster")){
        ## user provides a cluster object
        ## use only as many nodes as necessary
        ncores <- length(parallel)
        cl <- parallel
    } else if (isTRUE(parallel)) {
        ## user wants us to check for or register a parallel backend
        ## and to choose number of cores
        cl <- parallel::getDefaultCluster()
        if(is.null(cl)){
            ncores <- getOption("cl.cores", 2)
            cl <- parallel::makeCluster(ncores)
            closeexit <- TRUE
            if(verbose){message('Registered ', capture.output(print(cl)), '.')}
        }
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
    nmcs <- ncol(K$W)

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
    if(!all(Y1names %in% auxmetadata$name)){
        stop('unknown Y1 variates\n')
    }
    if(anyDuplicated(Y1names)){
        stop('duplicate Y1 variates\n')
    }
    ##
    if(!is.null(Y2names) && !all(Y2names %in% auxmetadata$name)){
        stop('unknown Y2 variates\n')
    }
    if(anyDuplicated(Y2names)){
        stop('duplicate Y2 variates\n')
    }


    if(!all(Xv %in% auxmetadata$name)){
        stop('unknown X variates\n')
    }
    if(anyDuplicated(Xv)){
        stop('duplicate X variates\n')
    }
    ##
    if(anyDuplicated(c(Y1names, Y2names))){
        stop('overlap in Y1 and Y2 variates\n')
    }
    if(anyDuplicated(c(Y1names, Xv))){
        stop('overlap in Y1 and X variates\n')
    }
    if(anyDuplicated(c(Y2names, Xv))){
        stop('overlap in Y2 and X variates\n')
    }

    if(!all(tailsv %in% Xv)){
        warning('variate ',
            paste0(tailsv[!(tailsv %in% Xv)], collapse = ' '),
            ' not among X; ignored\n')
        tails <- tails[tailsv %in% Xv]
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


#### Step 0. Adjust component weights W for conditioning on X
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

#### Combine Y1,Y2 into single Y for speed
    Ynames <- c(Y1names, Y2names)

#### STEP 1. Draw samples of Ynames (that is, Y1names,Y2names)
    Wdenorm <- exp(.denorm(lW[, sseq, drop = FALSE]))
    Ws <- c(replicate(n = nv, expr = apply(
        X = Wdenorm, MARGIN = 2,
        FUN = function(xx){sample.int(n = ncomponents, size = 1, prob = xx)},
        simplify = TRUE
    ), simplify = 'array'))
    rm(Wdenorm)
    gc(full = TRUE)
    ## ## ## Old version with extraDistr::rcatlp()
    ## ## extraDistr::rcatlp() can use non-normalized probabilities
    ## ## NOTA BENE: the '1 - ...' is because of a bug in rcatlp() < 1.10.0.5
    ## Ws <- 1 - extraDistr::rcatlp(n = 1, log_prob = 0) +
    ##     extraDistr::rcatlp(n = ntot, log_prob = t(lW[, sseq, drop = FALSE]))
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
        totake <- cbind(rep.int(x = aux$id,
            times = rep.int(x = ntot, times = nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
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
        totake <- cbind(rep.int(x = aux$id,
            times = rep.int(x = ntot, times = nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
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
        totake <- cbind(rep.int(x = aux$id,
            times = rep.int(x = ntot, times = nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rnorm(n = ntot * nvrt,
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
            Yout <- c(Yout, mapply(
                FUN = function(xx, yy){
                sample.int(n = aux$Nvalues, size = 1,
                    prob = K$Oprob[aux$indexpos + seq_len(aux$Nvalues),
                        xx, yy])},
                Ws, sseq, SIMPLIFY = TRUE) )
            ## ## old version with extraDistr::rcat()
            ## totake <- cbind(Ws, sseq)
            ## Yout <- c(Yout,
            ##     extraDistr::rcat(n = ntot,
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
            Yout <- c(Yout, mapply(
                FUN = function(xx, yy){
                sample.int(n = aux$Nvalues, size = 1,
                    prob = K$Nprob[aux$indexpos + seq_len(aux$Nvalues),
                        xx, yy])},
                Ws, sseq, SIMPLIFY = TRUE) )
            ## ## old version with extraDistr::rcat()
            ## totake <- cbind(Ws, sseq)
            ## Yout <- c(Yout,
            ##     extraDistr::rcat(n = ntot,
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
        totake <- cbind(rep.int(x = aux$id,
            times = rep.int(x = ntot, times = nvrt)), Ws, sseq)
        Yout <- c(Yout,
            rbinom(n = ntot * nvrt, size = 1, prob = K$Bprob[totake])
            ## ## Old version
            ## extraDistr::rbern(n = ntot * nvrt, prob = K$Bprob[totake])
        )
    }

    dim(Yout) <- c(ntot, length(Ynames))
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

    lpargs1 <- .lprobsargsyx(
        x = Y1transf,
        auxmetadata = auxmetadata,
        K = K,
        tails = NULL,
        ids = ids
    )

    lpargs2 <- .lprobsargsyx(
        x = Y2transf,
        auxmetadata = auxmetadata,
        K = K,
        tails = NULL,
        ids = ids
    )

    ## each instance of .lprobsmi() takes one datapoint
    out <- do.call(rbind,
        parallel::parLapply(cl = cl,
            X = mapply(c, lpargs1$xVs, lpargs2$xVs, SIMPLIFY = FALSE),
            fun = .lprobsmi,
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
    ##     as.matrix(.vtransform(Y1transf,
    ##         auxmetadata = auxmetadata,
    ##         logjacobianOr = FALSE)),
    ##     na.rm = TRUE)
    ##
    ## logjacobians2 <- rowSums(
    ##     as.matrix(.vtransform(Y2transf,
    ##         auxmetadata = auxmetadata,
    ##         logjacobianOr = FALSE)),
    ##     na.rm = TRUE)

    ## Separate columns for MI with columns for its revisability
    outsamples <- out[, 'fMI']
    ## ids <- out[,3] # for debugging
    ## dim(ids) <- c(ns, nv) # for debugging
    out <- out[, 'pMI']

    dim(outsamples) <- c(ns, nv)
    outsamples <- rowMeans(x = outsamples, na.rm = TRUE)
    outsamples[outsamples < 0] <- 0

    ## report whether the probabilities are 'tails' or not
    if(!is.null(tails)){
        outtails <- list()
        outtails[colnames(X)] <- ''
        outtails[names(tails)[tails == -1]] <- '>'
        outtails[names(tails)[tails == 1]] <- '<'
    } else {
        outtails <- NULL
    }

    ## Output
    ## Important that MI is in *nats* now to calculate rGauss later
    MI <- mean(out)
    if(MI < 0){ MI <- 0 }

    acc <- .funMCSELD(x = out)
    ## acc <- sd(out, na.rm = TRUE) / sqrt(ntot)
    dim(MI) <- dim(acc) <- length(MI)

    outquantiles <- quantile(outsamples, probs = quantiles, type = 6,
        na.rm = TRUE, names = TRUE)

    Qerror <- pnorm(c(-1, 1))
    temp <- .funMCEQ(x = outsamples, prob = quantiles, Qpair = Qerror)
    quantiles.acc <- (temp[2, ] - temp[1, ]) / 2

    qnames <- names(outquantiles) # used later, lost below
    dim(outquantiles) <- dim(quantiles.acc) <- c(1, length(quantiles))
    dim(outsamples) <- c(1, length(outsamples))

    ## report whether the probabilities are 'tails' or not
    if(!is.null(tails)){
        outtails <- list()
        outtails[colnames(X)] <- ''
        outtails[names(tails)[tails == -1]] <- '>'
        outtails[names(tails)[tails == 1]] <- '<'
    } else {
        outtails <- NULL
    }

    if(!is.null(X)){
        Xnames <- setNames(object = list(
            apply(X = X, MARGIN = 1, FUN = paste0, collapse = sep,
                simplify = TRUE)),
            nm = paste0(solidus,
                paste0(colnames(X), outtails[colnames(X)], collapse = sep)) )
    } else {
        Xnames <- list(NULL)
    }

    dimnames(MI) <- dimnames(acc) <- Xnames
    dimnames(outquantiles) <- dimnames(quantiles.acc) <-
        c(Xnames, list(qnames))
    dimnames(outsamples) <- c(Xnames, list(NULL))

    out <- c(list(
        value = MI / lbase,
        value.acc = acc / lbase,
        quantiles = outquantiles / lbase,
        quantiles.acc = quantiles.acc / lbase,
        samples = outsamples / lbase,
        rGauss = sqrt(1 - exp(-2 * MI)),
        unit = unit,
        Y1names = Y1names,
        Y2names = Y2names
        ## , ids = rowMeans(ids) # for debugging
    ),
    if(isTRUE(keepX)){
                list(X = X)
    },
    if(!is.null(outtails)){
        list(tails = outtails[!(outtails == '')])
    },
    list(K = Kname)
    )

    class(out) <- 'mi'
    out
}



#' Calculate mutual information between groups of joint variates having finite domains
#'
#' @description Calculate the mutual information between two grops of joint variates having finite domains, as well as its revisability.
#'
#' @details This function is a *much* (100 times or more) faster and more accurate implementation of [mutualinfo()]; but it only works correctly with variates having *finite* domain, typically nominal or ordinal variates (see [metadata]).
#'
#' It can also be used with continuous variates, but its results can be in error in this case, and there is no error estimate.
#'
#' See [mutualinfo()] for other details.
#'
#' @param Y1names Character vector: first group of joint variates
#' @param Y2names Character vector or `NULL`: second group of joint variates
#' @param X Matrix or data.frame or `NULL`: values of some variates conditional on which we want the probabilities.
#' @param K A "Knowledge" object produced by [learn()]. It can also be a path to a 'K.rds' file containing such object, or to a directory containing one.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `X`. For variates in this list, the probability conditional is understood in a semi-open interval sense: \eqn{X \le x} or \eqn{X \ge x}, an so on. See analogous argument in [Pr()].
#' @param quantiles Numeric vector, between 0 and 1: desired quantiles of the revisability of the mutual information. Default `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5% quantiles. See similar argument in [Pr()].
#' @param unit Either one of 'Sh' for *shannon* (default), 'Hart' for *hartley*, 'nat' for *natural unit*, or a positive real indicating the base of the logarithms to be used.
#' @param parallel One of the following values:
#' - A "cluster" object previously created with [parallel::makeCluster()].
#' - Positive integer: create a parallel cluster with this number of nodes (it will be stopped at the end).
#' - `FALSE`: do not use clusters (one node is still generated, in order to eliminate temporary objects from the computation).
#' - `TRUE` (default): use the cluster that was set as default with [parallel::setDefaultCluster()]; if no such object exists, then generate a cluster with as many nodes as in the [option][base::getOption()] "nc.cores"; if this option is unset, then use 2 nodes.
#' @param sep character, default `','`: character to separate the output's variate names and values.
#' @param solidus character, default `'|'`: character prepended to the output's names of the variates in the conditional (typically the `X` variates).
#' @param verbose Logical, default `FALSE`: give messages about parallel processing?
#' @param keepX Logical, default `TRUE`: keep a copy of the `X` argument in the output? This is used for [hist.mi()].
#'
#' @return An object of class "mi", which is a list consisting of the following elements:
#'
#' - `'value'`, the mutual information between (joint) variates `Y1names` and (joint) variates `Y2names`.
#' - `'quantiles'`, a vector with the revisability quantiles for the mutual information.
#' - `'value.acc'`, `quantiles.acc` number and vector with the numerical accuracies (roughly speaking a standard deviation) of the Monte Carlo calculation for the `'value'` and the `'quantiles'` elements.
#' - `'samples'`, a vector with the revisability samples for the mutual information.
#' - `'rGauss'`, a vector of `value` and `accuracy`: the absolute value of the Pearson correlation coefficient \eqn{r} of a *multivariate Gaussian distribution* having mutual information `MI`; the two are related by \eqn{\mathrm{MI} = -\ln(1 - r^2)/2}. It may provide a vague intuition for the `MI` value for people more familiar with Pearson's correlation, but should be taken with a grain of salt.
#' - `'unit'`, `'Y1names'`, `'Y1names'`, `'tails'`: copies of the homonymous input arguments.
#' - `'K'`: name of the "Knowledge" object used in the calculation.
#'
#' @seealso
#' [print.mi()] ] to plot mutual information and quantiles calculated by `mutualinfo()`
#'
#' [hist.mi()] to plot the revisability of the mutual information.
#'
#' [Pr()] to calculate probabilities and their revisability.
#'
#' [learn()], which generates the `K` objects required by `mutualinfo()`.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## mutual information between variates 'species' and 'bill_len'
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len', K = K, nv = 2)
#'
#' ## The value and its numerical Monte Carlo accuracy
#' c(MI$value, MI$value.acc)
#'
#' ## If we had many more data, we could instead expect to obtain values
#' ## within the following probable ranges:
#' signif(MI$quantiles, 3)
#'
#' @import parallel
#' @import stats
#' @import utils
#'
#' @concept association
#' @export
mutualinfoF <- function(
    Y1names,
    Y2names,
    X = NULL,
    K,
    tails = NULL,
    quantiles =  c(0.055, 0.25, 0.75, 0.945),
    unit = 'Sh',
    parallel = TRUE,
    sep = ',',
    solidus = '|',
    verbose = FALSE,
    keepX = TRUE
){
#### Requested parallel processing
    ## NB: doesn't make sense to have more cores than chains
    closeexit <- FALSE
    if (inherits(parallel, "cluster")){
        ## user provides a cluster object
        ## use only as many nodes as necessary
        ncores <- length(parallel)
        cl <- parallel
    } else if (isTRUE(parallel)) {
        ## user wants us to check for or register a parallel backend
        ## and to choose number of cores
        cl <- parallel::getDefaultCluster()
        if(is.null(cl)){
            ncores <- getOption("cl.cores", 2)
            cl <- parallel::makeCluster(ncores)
            closeexit <- TRUE
            if(verbose){message('Registered ', capture.output(print(cl)), '.')}
        }
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

    auxmetadata <- K$auxmetadata

    if(all(is.na(X))){X <- NULL}
    if(!is.null(X)){
        X <- as.data.frame(X)
        ## if (nrow(X) > 1) {
        ##     warning('Only the first row of X is considered')
        ##     X <- X[1, , drop = FALSE]
        ## }
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
    if(!all(Y1names %in% auxmetadata$name)){
        stop('unknown Y1 variates\n')
    }
    if(anyDuplicated(Y1names)){
        stop('duplicate Y1 variates\n')
    }
    ##
    if(!is.null(Y2names) && !all(Y2names %in% auxmetadata$name)){
        stop('unknown Y2 variates\n')
    }
    if(anyDuplicated(Y2names)){
        stop('duplicate Y2 variates\n')
    }


    if(!all(Xv %in% auxmetadata$name)){
        stop('unknown X variates\n')
    }
    if(anyDuplicated(Xv)){
        stop('duplicate X variates\n')
    }
    ##
    if(anyDuplicated(c(Y1names, Y2names))){
        stop('overlap in Y1 and Y2 variates\n')
    }
    if(anyDuplicated(c(Y1names, Xv))){
        stop('overlap in Y1 and X variates\n')
    }
    if(anyDuplicated(c(Y2names, Xv))){
        stop('overlap in Y2 and X variates\n')
    }

    if(!all(tailsv %in% Xv)){
        warning('variate ',
            paste0(tailsv[!(tailsv %in% Xv)], collapse = ' '),
            ' not among X; ignored\n')
        tails <- tails[tailsv %in% Xv]
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

    ## Calculate probabilities over the domains created with vrtgrid()
    p1 <- Pr(vrtgrid(vrt = Y1names, K = K), X = X, K = K, parallel = cl)
    p2 <- Pr(vrtgrid(vrt = Y2names, K = K), X = X, K = K, parallel = cl)
    p12 <- Pr(vrtgrid(vrt = c(Y1names, Y2names), K = K), X = X, K = K,
        parallel = cl)

    ## Calculate MIs as entropy differences
    ## Important that MI is in *nats* now to calculate rGauss later
    MI <- colSums(p12[['value']] * log(p12[['value']]), na.rm = TRUE) -
        colSums(p1[['value']] * log(p1[['value']]), na.rm = TRUE) -
        colSums(p2[['value']] * log(p2[['value']]), na.rm = TRUE)

    acc <- colSums(abs(
        p12[['value.acc']] * log(p12[['value']]) +
            p12[['value']] * log1p(p12[['value.acc']] / p12[['value']])
    ), na.rm = TRUE) +
        colSums(abs(
        p1[['value.acc']] * log(p1[['value']]) +
            p1[['value']] * log1p(p1[['value.acc']] / p1[['value']])
        ), na.rm = TRUE) +
        colSums(abs(
        p2[['value.acc']] * log(p2[['value']]) +
            p2[['value']] * log1p(p2[['value.acc']] / p2[['value']])
    ), na.rm = TRUE)

    dim(MI) <- dim(acc) <- length(MI)

    outsamples <- colSums(p12[['samples']] * log(p12[['samples']]),
        na.rm = TRUE) -
        colSums(p1[['samples']] * log(p1[['samples']]), na.rm = TRUE) -
        colSums(p2[['samples']] * log(p2[['samples']]), na.rm = TRUE)
    rm(p12, p1, p2)

    ## report whether the probabilities are 'tails' or not
    if(!is.null(tails)){
        outtails <- list()
        outtails[colnames(X)] <- ''
        outtails[names(tails)[tails == -1]] <- '>'
        outtails[names(tails)[tails == 1]] <- '<'
    } else {
        outtails <- NULL
    }

    if(!is.null(X)){
        Xnames <- setNames(object = list(
            apply(X = X, MARGIN = 1, FUN = paste0, collapse = sep,
                simplify = TRUE)),
            nm = paste0(solidus,
                paste0(colnames(X), outtails[colnames(X)], collapse = sep)) )
    } else {
        Xnames <- list(NULL)
    }

    dimnames(MI) <- dimnames(acc) <- Xnames

    Qerror <- pnorm(c(-1, 1))
    outquantiles <- t(apply(
        X = outsamples, MARGIN = 1,
        FUN = function(FF){
            temp <- .funMCEQ(x = FF, prob = quantiles,
                Qpair = Qerror)
            c(
                quantile(x = FF, probs = quantiles, type = 6,
                    na.rm = TRUE, names = FALSE),
                (temp[2, ] - temp[1, ]) / 2
            )}
    ))

    temp <- list(Q = rep.int(x = names(quantile(x = NA, probs = quantiles,
        names = TRUE, na.rm = TRUE)), times = 2))
    dimnames(outquantiles) <- c(Xnames, temp)

    ## Output
    out <- c(list(
        value = MI / lbase,
        value.acc = acc / lbase,
        quantiles = outquantiles[ , seq_along(quantiles), drop = FALSE] / lbase,
        ## quantile(outsamples, probs = quantiles,
        ##     type = 6, na.rm = TRUE, names = TRUE) / lbase,
        quantiles.acc = outquantiles[ , -seq_along(quantiles), drop = FALSE] / lbase,
        ## {
        ##     temp <- .funMCEQ(x = outsamples, prob = quantiles, Qpair = Qerror)
        ##     (temp[2, ] - temp[1, ]) / (2 * lbase)
        ## },
        samples = outsamples / lbase,
        rGauss = sqrt(1 - exp(-2 * MI)),
        unit = unit,
        Y1names = Y1names,
        Y2names = Y2names
        ## , ids = rowMeans(ids) # for debugging
    ),
    if(isTRUE(keepX)){
                list(X = X)
    },
    if(!is.null(outtails)){
        list(tails = outtails[!(outtails == '')])
    },
    list(K = Kname)
    )

    class(out) <- 'mi'
    out
}
