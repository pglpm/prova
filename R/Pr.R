#' Calculate posterior probabilities
#'
#' @description Calculate posterior probabilities and probability densities, cumulative posterior probabilities, and mixtures thereof. Output the "revisability" of such probabilities if more training data were available, and the Monte Carlo Standard Error for the calculated posterior probabilities.
#'
#' @details This function calculates the posterior probability \eqn{\mathrm{Pr}(Y = y \vert X = x, K)}, where \eqn{Y = y} and \eqn{X = x} are two (non overlapping) sets of joint variate values, inputted as [data frame][base::data.frame()] arguments `Y` and `X`, and \eqn{K} is the information in the data and metadata. It is somewhat analogous to the `dxxx`-variants and `pxxx`-variants of [R distribution functions][stats::Distributions]. If `X` is omitted or `NULL`, then the posterior probability \eqn{\mathrm{Pr}(Y = y \vert K)} is calculated.
#'
#' For some variates in `Y` or `X`, tail values can also be prescribed, so that this function calculates mixed probabilities such as \deqn{\mathrm{Pr}(Y_1 = y_1, Y_2 \le y_2, \dotsc \vert X_1 = x_1, X_2 \ge x_2, \dotsc, K)\ .} Tail values are inputted via the `'tails'` argument; see "Usage".
#'
#' This function also outputs the "revisability" of the posterior probabilities above, that is, probabilities such as \eqn{\mathrm{Pr}(Y = y \vert X = x, \text{new data}, K)} that we could have if more learning data were provided, as well as a number of samples of the possible values of such probability. This revisability can be outputted in two ways; the user can choose either, or both, or none:
#'
#' - As samples (default 3600 samples, depending on the 'nsamples' argument given to the [learn()] function) of the alternative values that the posterior probability could have.
#' - As quantiles (default 5.5%, 25%, 75%, 94.5%) of the possible revisability.
#'
#' If several joint values are given for `Y` or `X`, the function will create a 2D grid of results for all possible combinations of the given `Y` and `X` values.
#'
#' This function also allows for base-rate or other prior-probability corrections: If a prior (for instance, a base rate) for the data corresponding to rows `Y` is given, the function will calculate the probability \eqn{\mathrm{Pr}(Y = y \vert X = x, K, \text{prior})} from \eqn{\mathrm{Pr}(X = x \vert Y = y, K)} and the prior, by means of Bayes's theorem
#' \deqn{\mathrm{Pr}(Y = y \vert X = x, K, \text{prior})
#' =
#' \frac{
#' \mathrm{Pr}(X = x \vert Y = y, K) \cdot
#' \mathrm{Pr}(Y = y \vert \text{prior})
#' }{
#' \sum_{y'} \mathrm{Pr}(X = x \vert Y = y', K) \cdot
#' \mathrm{Pr}(Y = y' \vert \text{prior})
#' }
#' \ .}
#' *Important*: any values *not* present in the `Y` data frame are given *zero* prior probability; in other words, the normalization \eqn{\sum_{y'}} only counts the $y$ values appearing in the data frame `Y`.
#'
#' Each variate in each argument `Y`, `X` can be specified either as a point-value \eqn{Y = y} or as a left-open interval \eqn{Y \le y} or as a right-open interval \eqn{Y \ge y}, through the argument `tails`.
#'
#' See `vignette('intro')` for example uses.
#'
#' @param Y Matrix or data.table: set of values of variates of which we want
#'   the joint probability of. One variate per column, one set of values per row.
#' @param X Matrix or data.table or `NULL` (default): set of values of variates on which we want to condition the joint probability of `Y`. If `NULL`, no conditioning is made (except for conditioning on the learning dataset and prior assumptions). One variate per column, one set of values per row.
#' @param K A "Knowledge" object produced by [learn()]. It can also be a path to a 'K.rds' file containing such object, or to a directory containing one.
#' @param tails Named vector or list, or `NULL` (default). The names must match some or all of the variates in arguments `Y` and `X`. For variates in this list, the probability arguments are understood in a semi-open interval sense: \eqn{Y \le y} or \eqn{Y \ge y}, an so on. This is true for `Y` and `X` variates (on the left and on the right of the conditional sign \eqn{\,\vert\,}). A left-open interval \eqn{Y \le y} is indicated by `'<='` or `'lower'` or`'left'` or `-1`; a right-open interval \eqn{Y \ge y} is indicated by `'>='` or `'upper'` or `'right'` or `+1`. Values `NULL`, `'=='`, `0` indicate that a point value `Y = y` (not an interval) should be calculated. **NB**: the semi-open intervals *always* include the given value; this is important for ordinal or rounded variates. For instance, if \eqn{Y} is an integer variate, then to calculate  \eqn{\mathrm{Pr}(Y < 3)} you should require \eqn{\mathrm{Pr}(Y \le 2)}; for this reason we also have that \eqn{\mathrm{Pr}(Y \le 2)} and  \eqn{\mathrm{Pr}(Y \ge 2)} generally add up to *more* than 1.
#' @param priorY Numeric vector with the same length as the rows of `Y`, or `TRUE`, or `NULL` (default): prior probabilities or base rates for the `Y` values. If `TRUE`, the prior probabilities are assumed to be all equal.
#' @param nsamples Integer or `NULL` or `'all'` (default): desired number of samples of the revisability of the probability for `Y`. If `NULL` or 0, no samples are reported. If `'all'` or `Inf`, all samples obtained by the [learn()] function are used.
#' @param quantiles Numeric vector, between 0 and 1, or `NULL`: desired quantiles of the revisability of the probability for `Y`. Default `c(0.055, 0.25, 0.75, 0.945)`, that is, the 5.5%, 25%, 75%, 94.5% quantiles. These are typical quantile values in the Bayesian literature: they give 50% and 89% credibility intervals, which correspond to 1 shannons and 0.5 shannons of uncertainty (see <doi:10.5281/zenodo.17072199>). If `NULL`, no quantiles are calculated.
#' @param parallel One of the following values:
#' - A "cluster" object previously created with [parallel::makeCluster()].
#' - Positive integer: create a parallel cluster with this number of nodes (it will be stopped at the end).
#' - `FALSE`: do not use clusters (one node is still generated, in order to eliminate temporary objects from the computation).
#' - `TRUE` (default): use the cluster that was set as default with [parallel::setDefaultCluster()]; if no such object exists, then generate a cluster with as many nodes as in the [option][base::getOption()] "nc.cores"; if this option is unset, then use 2 nodes.
#' @param sep character, default `','`: character to separate the output's variate names and values.
#' @param solidus character, default `'|'`: character prepended to the output's names of the variates in the conditional (typically the `X` variates).
#' @param verbose Logical, default `FALSE`: give messages about parallel processing?
#' @param keepYX Logical, default `TRUE`: keep a copy of the `Y` and `X` arguments in the output? This is used for [plot.probability()].
#'
#' @return An object of class "probability", which is a list consisting of the following elements:
#'
#' - `'value'`: a matrix with the probabilities \eqn{\mathrm{Pr}(Y = y \vert X = x, K)}, for all joint values \eqn{y} of the \eqn{Y}-variates (rows) and  all joint values \eqn{x} of the \eqn{X}-variates (columns).
#' - `'quantiles'` (possibly `NULL`): an array with the revisability quantiles (3rd dimension of the array) for such probabilities.
#' - `'samples'` (possibly `NULL`): an array with the revisability samples (3rd dimension of the array) for such probabilities.
#' - `'value.acc'`, `quantiles.acc`: arrays with the numerical accuracies (roughly speaking a standard deviation) of the Monte Carlo calculations for the `'values'` and `'quantiles'` elements.
#' - `'density'`: numerical vector as long as number of rows in `Y`, used mainly for [plot.probability()]. It is the order of the probability density the `Y`-values: values with `0` are actual probabilities; values with `1` are one-dimensional probability densities \eqn{\mathrm{p}(\dotso)\,\mathrm{d}y}; values with `2` are two-dimensional probability densities \eqn{\mathrm{p}(\dotso)\,\mathrm{d}y_1\,\mathrm{d}y_2}; and so on.
#' - `'Y'`, `'X'`, `'tails'`: copies of the `Y`, `X`, `tails` arguments.
#' - `'K'`: name of the "Knowledge" object used in the calculation.
#'
#' @references
#'
#' - Lindley, Novick (1981): *The role of exchangeability in inference*, <doi:10.1214/aos/1176345331>.
#' - Bernardo, Smith (2000): *Bayesian Theory*, Wiley <doi:10.1002/9780470316870>.
#' - Fortini, Petrone (2024): *Prediction-based uncertainty quantification for exchangeable sequences*, <doi:10.1098/rsta.2022.0142>.
#' - Jaynes (2003): *Probability Theory: The Logic of Science*, Cambridge University Press <doi:10.1017/CBO9780511790423>.
#' - MacKay (2005): *Information Theory, Inference, and Learning Algorithms*, Cambridge University Press <https://www.inference.org.uk/itila/book.html>.
#' - Porta Mana (2025): *What's special about 89% credibility intervals?*, <doi:10.5281/zenodo.17072199>.
#'
#' @seealso
#' [learn()], which generates the `K`nowledge objects required by `Pr()`.
#'
#' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()`.
#'
#' [hist.probability()] to plot histograms of the probability distributions calculated by `Pr()`.
#'
#' [print.probability()] to print the main elements of the probabilities calculated by `Pr()`.
#'
#' [qPr()] to calculate quantiles for a specific variate, that is, the variate values having given probabilities.
#'
#' [rPr()] to generate datapoints.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## ## Example 1:
#' ## Calculate the probability that an unknown penguin from this population
#' ## is of species 'Adelie'
#'
#' probs <- Pr(Y = data.frame(species = 'Adelie'), K = K)
#'
#' ## display the probability value
#' probs$value
#'
#' ## the full-population frequency of 'Adelie' penguins is unknown;
#' ## display the 5.5%- and 94.5%-probability values
#' ## for such frequency
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#' ## we can also plot the probability distribution for this full-population frequency
#' hist(probs, legend = 'topright')
#'
#'
#' ## ## Example 2:
#' ## Calculate the 3 probabilities that an unknown penguin from this population
#' ## is of species 'Adelie', 'Chinstrap', 'Gentoo'
#'
#' probs <- Pr(
#'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
#'   K = K
#' )
#'
#' ## display the 3 probability values
#' probs$value
#'
#' ## the full-population frequencies of the three species are unknown;
#' ## display the 5.5%- and 94.5%-probability values
#' ## for such frequencies
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#' ## plot the probabilities and quantiles
#' plot(probs)
#'
#' ## plot the probability distribution for the full-population frequency
#' ## of each species
#' hist(probs)
#'
#' ## ## Example 3:
#' ## Calculate the probability that an unknown penguin is of species 'Adelie'
#' ## GIVEN that its bill length is 43 mm
#'
#' probs <- Pr(
#'   Y = data.frame(species = 'Adelie'),
#'   X = data.frame(bill_len = 43),
#'   K = K
#' )
#'
#' ## display the probability value
#' probs$value
#'
#' ## the full-subpopulation frequency of 'Adelie' penguins,
#' ## among penguins having bill length of 43 mm, is unknown;
#' ## display the 5.5%- and 94.5%-probability values
#' ## for such conditional frequency
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#'
#' ## ## Example 4:
#' ## Calculate the probability that
#' ## an unknown penguin is of species 'Adelie' AND its bill length is 43 mm
#'
#' probs <- Pr(Y = data.frame(species = 'Adelie', bill_len = 43), K = K)
#'
#' ## display the probability value
#' probs$value
#'
#' ## display the 5.5%- and 94.5%-probability values
#' ## for the full-population frequency of 'Adelie' penguins with 43 mm bills
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#'
#' ## ## Example 5:
#' ## Calculate the 3 x 2 probabilities for the 3 species
#' ## GIVEN bill-lengths of 43 mm and 44 mm
#'
#' Y <- data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo'))
#'
#' X <- data.frame(bill_len = c(43, 44))
#'
#' probs <- Pr(Y = Y, X = X, K = K)
#'
#' ## display the 3 x 2 probability values
#' probs$value
#'
#' ## display the 5.5%- and 94.5%-probability values
#' ## for the full-population joint frequencies
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#' ## plot the probabilities and quantiles
#' plot(probs)
#'
#'
#' ## ## Example 6:
#' ## Calculate the 3 x 2 joint probabilities for the 3 species
#' ## AND bill-lengths of 43 mm and 44 mm
#'
#' Y <- expand.grid(
#'   species = c('Adelie', 'Chinstrap', 'Gentoo'),
#'   bill_len = c(43, 44)
#' )
#'
#' probs <- Pr(Y = Y, K = K)
#'
#' ## display the 6 joint-probability values
#' probs$value
#'
#' ## display the 5.5%- and 94.5%-probability values
#' ## for the full-population joint frequencies
#' probs$quantiles[, , c('5.5%', '94.5%')]
#'
#'
#' @import parallel
#' @import stats
#' @import utils
#'
#' @concept probability
#' @export
Pr <- function(
    Y,
    X = NULL,
    K = NULL,
    tails = NULL,
    priorY = NULL,
    nsamples = 'all',
    quantiles = c(0.055, 0.25, 0.75, 0.945),
    parallel = TRUE,
    sep = ',',
    solidus = '|',
    verbose = FALSE,
    keepYX = TRUE
){
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

    ## Figure out unnamed arguments
    Kname <- c(deparse(substitute(K)), deparse(substitute(X)))
    if(!is.null(X) && is.null(K)){
        K <- X
        X <- NULL
        Kname <- Kname[2]
    } else if(!is.null(X) && !is.null(.retrieveK(X)) &&
                  !is.null(K) && is.null(tails)){
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
        stop("Argument 'K' must be a 'Knowledge' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
    }

    auxmetadata <- K$auxmetadata
    K$auxmetadata <- NULL
    K$auxinfo <- NULL
    ncomponents <- nrow(K$W)
    nmcsamples <- ncol(K$W)

    if(is.null(nsamples)){
        nsamples <- 0
    } else if(is.numeric(nsamples)){
        if(is.na(nsamples) || nsamples < 1) {
            nsamples <- 0
        } else if(nsamples > nmcsamples){
            nsamples <- nmcsamples
        }
    } else if (is.character(nsamples) && nsamples == 'all'){
        nsamples <- nmcsamples
    }

    if(!is.data.frame(Y)){ Y <- as.data.frame(as.list(Y)) }
    Yv <- colnames(Y)

    if(all(is.na(X))){X <- NULL}
    if(!is.null(X) && !is.data.frame(X)){ X <- as.data.frame(as.list(X)) }
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

    if(!all(Yv %in% auxmetadata$name)) {
        stop('unknown Y variate ',
            paste0(Yv[!(Yv %in% auxmetadata$name)], collapse = ' '),
            '\n')
    }
    if(anyDuplicated(Yv)){
        stop('duplicate Y variates\n')
    }

    if (!all(Xv %in% auxmetadata$name)) {
        stop('unknown X variate ',
            paste0(Xv[!(Xv %in% auxmetadata$name)], collapse = ' '),
            '\n')
    }
    if(anyDuplicated(Xv)){
        stop('duplicate X variates\n')
    }

    if(anyDuplicated(c(Yv, Xv))){
        stop('overlap in Y and X variates\n')
    }

    tailsv <- names(tails)
    if(!all(tailsv %in% c(Yv, Xv))) {
        warning('"tails" variate ',
            paste0(tailsv[!(tailsv %in% c(Yv, Xv))], collapse = ' '),
            ' not among Y and X; ignored\n')
        tails <- tails[tailsv %in% c(Yv, Xv)]
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
    tailsv <- names(tails)

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

    nY <- nrow(Y)
    nX <- max(nrow(X), 1L)

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

        ## each instance of .lprobsbase() takes one datapoint
        invisible(parallel::parLapply(cl = cl,
            X = lpargs$xVs,
            fun = .lprobsbase,
            params = lpargs$params,
            logW = c(log(K$W)),
            temporarydir = temporarydir,
            lab = '__X'
        ))
    }


#### Calculate and save arrays for Y values:

    ## Construction of the arguments for util_lprobs, Y argument
    ## jacobians <- exp(-rowSums(
    ##     log(.vtransform(Y,
    ##         auxmetadata = auxmetadata,
    ##         invjacobian = TRUE)),
    ##     na.rm = TRUE
    ## ))

    lpargs <- .lprobsargsyx(
        x = Y,
        auxmetadata = auxmetadata,
        K = K,
        tails = tails
    )

    ## each instance of .lprobsbase() takes one datapoint
    invisible(parallel::parLapply(cl = cl,
        X = lpargs$xVs,
        fun = .lprobsbase,
        params = lpargs$params,
        logW = 0,
        temporarydir = temporarydir,
        lab = '__Y'
    ))

    ## Calculation with all Y and X combinations
    keys <- c('value', 'quantiles', 'samples', 'value.acc', 'quantiles.acc')
    ##
    combfnr <- function(...){setNames(do.call(mapply,
        c(FUN = `rbind`, lapply(X = ..., FUN = `[`, keys, drop = FALSE))),
        keys)}
    ## combfnc <- function(...){setNames(do.call(mapply, c(FUN=cbind, lapply(list(...), `[`, keys))), keys)}

    doquantiles <- !is.null(quantiles)
    dosamples <- (nsamples > 0)

    if(is.null(priorY)){
        out <- combfnr(parallel::parApply(cl = cl,
            X = expand.grid(
                jy = seq_len(nY), # these will be rows
                jx = seq_len(nX), # these will be cols
                KEEP.OUT.ATTRS = TRUE, stringsAsFactors = FALSE),
            MARGIN = 1,
            FUN = .combineYX,
            temporarydir = temporarydir, usememory = usememory,
            doquantiles = doquantiles, quantiles = quantiles,
            dosamples = dosamples, nsamples = nsamples,
            Qerror = Qerror
        ))
    } else {
        out <- combfnr(parallel::parApply(cl = cl,
            X = expand.grid(
                jx = seq_len(nX), # these will be rows
                jy = seq_len(nY), # these will be cols
                KEEP.OUT.ATTRS = TRUE, stringsAsFactors = FALSE),
            MARGIN = 1,
            FUN = .combineYX,
            temporarydir = temporarydir, usememory = usememory,
            doquantiles = doquantiles, quantiles = quantiles,
            dosamples = dosamples, nsamples = nsamples,
            Qerror = Qerror
        ))
    }

    ## clean temp files
    if(usememory) {
        unlink(x = c(
            sapply(seq_len(nX), function(jx){
                file.path(temporarydir, paste0('__X', jx, '__.rds'))
            }),
            sapply(seq_len(nY), function(jy){
                file.path(temporarydir, paste0('__Y', jy, '__.rds'))
            })
        ))
    }

    ## transform to grid
    ## in the output-list elements the Y & X values are the rows
    if(is.null(priorY)){
        dim(out$value) <- dim(out$value.acc) <- c(nY, nX)

        if(dosamples){
            dim(out$samples) <- c(nY, nX, nsamples)
        }

        if(doquantiles){
            dim(out$quantiles) <- dim(out$quantiles.acc) <-
                c(nY, nX, length(quantiles))
        }

    } else {
        dim(out$value) <- dim(out$value.acc) <- c(nX, nY)
        ## now: *original Y* are rows, *original X* are cols
        ## apply Bayes's theorem
        out$value <- t(out$value * priorY)
        out$value.acc <- t(out$value.acc * priorY)
        ## now: *original X* are rows, *original Y* are cols

        normf <- rowSums(x = out$value, na.rm = TRUE)

        ## error propagation:
        out$value.acc <- t(
            out$value.acc / normf +
                out$value *
                rowSums(x = out$value.acc, na.rm = TRUE) /
                (normf^2)
        )
        out$value <- t(out$value / normf)

        ## now: *original Y* are rows, *original X* are cols

        ## ## ## Alternative version, with all Y-values
        ## ## subset to original Y-values
        ## out$value <- out$value[Ytokeep, , drop = FALSE]
        ## out$value.acc <- out$value.acc[Ytokeep, , drop = FALSE]

        if(dosamples){
            dim(out$samples) <- c(nX, nY, nsamples)
            out$samples <- out$samples * priorY
            normf <- c(colSums(x = out$samples, dims = 1, na.rm = TRUE))
            out$samples <- aperm(
                a = aperm(a = out$samples, perm = c(2, 3, 1)) / normf,
                perm = c(3, 1, 2) )

            ## ## ## Alternative version, with all Y-values
            ## ## subset to original Y-values
            ## out$samples <- out$samples[Ytokeep, , , drop = FALSE]

            ## Calculate quantiles from new samples
            if(doquantiles){
                out$quantiles <- aperm(
                    a = apply(
                        X = out$samples, MARGIN = c(1, 2),
                        FUN = function(FF){
                            temp <- .funMCEQ(x = FF, prob = quantiles,
                                Qpair = Qerror)
                            c(
                                quantile(x = FF, probs = quantiles, type = 6,
                                    na.rm = TRUE, names = FALSE),
                                (temp[2, ] - temp[1, ]) / 2
                            )}
                    ), perm = c(2, 3, 1) )

                out$quantiles.acc <- out$quantiles[, ,
                    -seq_along(quantiles), drop = FALSE]
                out$quantiles <- out$quantiles[, ,
                    seq_along(quantiles), drop = FALSE]

                ## ## ## Alternative version, with all Y-values
                ## ## subset to original Y-values
                ## out$quantiles <- out$quantiles[Ytokeep, , , drop = FALSE]
                ## out$quantiles.acc <-
                ##     out$quantiles.acc[Ytokeep, , , drop = FALSE]

            }
        }

        ## swap back Y and X
        ## ## ## Alternative version, with all Y-values
        ## . <- X[Ytokeep, , drop = FALSE]
        . <- X
        X <- Y
        Y <- .
        rm(.)
    }

    ## Jacobian factors
    y <- Y
    y[, colnames(y) %in% tailsv] <- NA
    jacobians <- exp(rowSums(
        as.matrix(.vtransform(y,
            auxmetadata = auxmetadata,
            logjacobianOr = TRUE)),
        na.rm = TRUE
    ))
    rm(y)
    gc(full = TRUE)

    ## report whether the probabilities are 'tails' or not
    if(!is.null(tails)){
        outtails <- list()
        outtails[c(colnames(Y), colnames(X))] <- ''
        outtails[names(tails)[tails == -1]] <- '>'
        outtails[names(tails)[tails == 1]] <- '<'
    } else {
        outtails <- NULL
    }

    ## report whether the probabilities are densities
    temp <- (auxmetadata$name %in% colnames(Y)) &
        (auxmetadata$mcmctype %in% c('R', 'C'))
    if(!is.null(tails)){
        temp <- temp & unname(outtails[auxmetadata$name] == '')
    }
    out$density <- apply(X = Y[, auxmetadata[temp, 'name'], drop = FALSE],
        MARGIN = 1,
        FUN = function(xx){
            sum(xx > auxmetadata[temp ,'domainmin'] &
                    xx < auxmetadata[temp ,'domainmax'])
        }, simplify = TRUE)

    ## Dimension & value names for variates
    Ynames <- setNames(object = list(
        apply(X = Y, MARGIN = 1, FUN = paste0, collapse = sep,
            simplify = TRUE)),
        nm = paste0(colnames(Y), outtails[colnames(Y)], collapse = sep) )

    if(!is.null(X)){
        Xnames <- setNames(object = list(
            apply(X = X, MARGIN = 1, FUN = paste0, collapse = sep,
                simplify = TRUE)),
            nm = paste0(solidus,
                paste0(colnames(X), outtails[colnames(X)], collapse = sep)) )
    } else {
        Xnames <- list(NULL)
    }


    out$value <- out$value * jacobians
    out$value.acc <- out$value.acc * jacobians
    dimnames(out$value) <- dimnames(out$value.acc) <-
        c(Ynames, Xnames)

    if(doquantiles){
        out$quantiles <- out$quantiles * jacobians
        out$quantiles.acc <-out$quantiles.acc * jacobians

        temp <- list(Q = names(quantile(x = NA, probs = quantiles,
            names = TRUE, na.rm = TRUE)))
        dimnames(out$quantiles) <- dimnames(out$quantiles.acc) <-
            c(Ynames, Xnames, temp)
    }

    if(dosamples){
        out$samples <- out$samples * jacobians

        temp <- list(sample = round(seq(1, nmcsamples, length.out = nsamples)))
        dimnames(out$samples) <- c(Ynames, Xnames, temp)
    }

    if(isTRUE(keepYX)){
        ## save Y and X values in the output; useful for plotting methods
        out$Y <- Y
        out$X <- X
    }
    if(!is.null(outtails)){
        out$tails <- outtails[!(outtails == '')]
    }
    out$K <- Kname

    class(out) <- 'probability'
    out
}
