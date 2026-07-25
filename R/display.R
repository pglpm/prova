#' Plot numeric or character values
#'
#' @description
#' Plot function that modifies and expands the **graphics** package's [graphics::matplot()] function in several ways.
#'
#' @details
#' This function is essentially a wrapper around [graphics::matplot()], augmenting the latter with some features useful for plotting data and probabilities handled by **Prova**. Some of the additional features provided by `pplot` are the following:
#'
#' - Either or both `x` and `y` arguments can be [list][base::list()]s. In this case, the first element of `x` is plotted against the first element of `y`, and so on, recycling as necessary. This allows for plots having different numbers of base points. The specifications in arguments like `type`, `lty`, `col`, `alpha.f`, `xjitter`, and similar apply to each list element in turn.
#' - Argument `x`, or each element in `x` if it is a list, can be of class [`base::character`]. In this case, x-axis labels as given in `xdomain` are used, or the unique values in `x` if `xdomain` is `NULL`. Similarly for `y` and `ydomain`. This feature makes it easier to plot nominal and ordinal non-numeric variates.
#' - Additional plot `type`s are available: `'hx'`, `'qx'`, `'hy'`, `'qy'` (internally they use [graphics::polygon()]):
#'   - `'hx'` plots shaded histograms, extending from \eqn{y = 0} to the values given in each column of `y`. The x-values are the corresponding columns of `x`, recycled if necessary.
#'   - `'qx'` plots shaded bands. The first band extends from the line defined by the first column of `y`, to the line defined by the *last* column; the second band is similarly delimited by the second and second-last columns of `y`, and so on (if `y` has an odd number of columns, the central one defines a line rather than a band). The x-values are the corresponding columns of `x`, recycled if necessary. This plot `type` is useful for plotting quantile bands calculated with [Pr()].
#'   - `'hy'`, `'qy'` are analogous `type`s, but with the roles of `x` and `y` switched.
#' - A jitter can be added to each plot, via the `xjitter` and `yjitter` vectors of switches. When either of these arguments is `NA`, it is internally assessed whether jitter is necessary. This feature makes it easier to generate scatter plots of nominal, ordinal, or rounded-continuous variates.
#' - It is possible to specify only a lower or upper limit in the `xlim` and `ylim` arguments, letting the other limit to be found automatically. This feature is useful in plotting probabilities and histograms, when we want to specify the lower as `0` but want the upper limit to be the the maximum probability.
#' - Transparency of lines or markers can be specified through argument `alpha.f`.
#' - Some defaults are different from [base::plot()] and [graphics::matplot()].
#'
#' See the package's vignettes for more examples.
#'
#' @param x Numeric or character or list: vectors of x-coordinates. If an element of `x` is missing, a numeric vector `1:...` is created having as many values as the rows of the corresponding element in `y`.
#' @param y Numeric or character or list: vectors of y-coordinates. If an element of `y` is missing, a numeric vector `1:...` is created having as many values as the rows of the corresponding element in `x`.
#' @param type Character vector or list indicating the type of plot for each element of `x` and `y`. The types of plot are the same as in [base::plot()], in particular `'p'` for points, `'l'` for lines, `'b'` for both points and lines, `'c'` for empty points joined by lines, `'o'` for overplotted points and lines, ``n'` for empty plot. Additional special types `'hx'`, `'qx'`, `'hy'`, `'qy'` are available for plotting histograms and quantile bands; see "Details".
#' @param xdomain,ydomain Character or numeric or `NULL` (default): vector of possible values of the variates represented in the `x`- and `y`-axes, in case the `x` or `y` argument is a character vector. Note that the domains apply to all elements in `x` and `y`. The ordering of the values is respected. If `NULL`, then `unique(x)` or `unique(y)` is used.
#' @param xlim,ylim `NULL` (default) or a vector of two values. If non-`NULL` and any of the two values is not finite (including `NA` or `NULL`), then the `min` or `max` `x`- or `y`-coordinates of the plotted points are used.
#' @param alpha.f Numeric vector or list: opacity of the colours specified with the `col` argument, `0` being completely invisible and `1` completely opaque. Default to 1, except for shaded plots of `type` `'hx'`, `'qx'`, `'hy'`, `'qy'`, for which it defaults to 0.25.
#' @param border Border colour for bands in plots of `type = 'q'`. Can be specified in any of the usual ways, see for instance [grDevices::col2rgb()]. If `NA` (default), no border is drawn.
#' @param xjitter,yjitter Vector or list of logicals or `NA` (default): add [base::jitter()] to `x`- or `y`-values? Useful when plotting discrete variates. If `NA`, jitter is added if both `x` and `y` are of character (or factor) class.
#' @param grid Logical, default `TRUE`: plot a light grid?
#' @param lwd.grid Numeric, default 1: width of grid lines.
#' @param col.grid Color of grid lines, default `'#BBBBBB80'`. Can be specified in any of the usual ways, see for instance [grDevices::col2rgb()].
#' @param lty,lwd,pch,lend,col,xlab,ylab,add,axes,cex.main see analogous arguments in [graphics::matplot()] and [graphics::plot.default()]; defaults are different (see "Usage").
#' @param ... Other parameters to be passed to [graphics::matplot()].
#'
#' @return `NULL`, [invisibly][base::invisible()]; produces a plot, see [graphics::matplot()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to directly plot posterior probabilities and quantiles contained in a probability object.
#'
#' [hist.probability()] to plot the revisability of the probabilities as a distribution.
#'
#' @examples
#' ## Scatter plot of the 'island' vs 'species' nominal variates of the penguins dataset;
#' ## note how jitter is automatically added:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'island'])
#'
#'
#' ## Scatter plot of the 'bill_len' vs 'species' variates of the penguins dataset:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'bill_len'])
#'
#' ## We can add jitter to separate the nominal values:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'bill_len'],
#'   xjitter = TRUE)
#'
#'
#' ## Scatter plot of the 'bill_len' vs 'body_mass' variates;
#' ## in this case we must specify the scatter-plot option `type = 'p'`:
#' flexiplot(x = penguins[, 'body_mass'], y = penguins[, 'bill_len'],
#'   type = 'p')
#'
#' ## Calculate the values of a normal distribution in a restricted range
#' x <- seq(from = -2, to = 2, length.out = 127)
#' y <- dnorm(x, mean = 0, sd = 1)
#'
#' ## plot the distribution, with 0 as the lower plot range:
#' flexiplot(x = x, y = y, ylim = c(0, NA))
#'
#' @import grDevices
#' @import graphics
#'
#' @concept display
#' @export
pplot <- function(
    x, y,
    type = NA,
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    lend = par('lend'),
    pch = c(1, 2, 0, 5, 6, 3), #, 4,
    col = palette(),
    xlab = NA, ylab = NA,
    xlim = NULL, ylim = NULL,
    add = FALSE,
    xdomain = NULL, ydomain = NULL,
    alpha.f = NA,
    xjitter = NA,
    yjitter = NA,
    border = NA,
    ## c( ## Tol's colour-blind-safe scheme
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    grid = TRUE,
    lwd.grid = NULL,
    col.grid = '#BBBBBB80',
    axes = FALSE,
    cex.main = 1,
    ...
){
    if(!is.list(x)){x <- list(x)}
    if(!is.list(y)){y <- list(y)}

    ## Transform all factors to character
    for(ii in seq_along(x)){
        if(is.factor(x[[ii]])){x[[ii]] <- as.character(x[[i]])}
    }
    for(ii in seq_along(y)){
        if(is.factor(y[[ii]])){y[[ii]] <- as.character(y[[i]])}
    }

    if(!is.null(xdomain)){ xdomain <- unlist(xdomain) }
    if(!is.null(ydomain)){ ydomain <- unlist(ydomain) }

    ## Find NULL elements for special handling later
    xnull <- vapply(X = x, FUN = is.null, FUN.VALUE = FALSE, USE.NAMES = FALSE)
    ynull <- vapply(X = y, FUN = is.null, FUN.VALUE = FALSE, USE.NAMES = FALSE)

    ## Check consistency of x, y args; find ranges
    if(all(vapply(X = x[!xnull], FUN = is.numeric,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all x are numeric, find common min max
        xcha <- FALSE
        temp <- unlist(x)
        temp <- temp[is.finite(temp)]
        rgx <- range(temp)
    } else if(all(vapply(X = x[!xnull], FUN = is.character,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all x are character, find domain
        xcha <- TRUE
        temp <- unlist(x)
        temp <- temp[!is.na(temp)]
        if(is.null(xdomain)){ xdomain <- unique(temp) }
        rgx <- c(1, length(xdomain))
    } else {
        stop("Elements in 'x' must be all numeric or all character.")
    }

    if(all(vapply(X = y[!ynull], FUN = is.numeric,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all y are numeric, find common min max
        ycha <- FALSE
        temp <- unlist(y)
        temp <- temp[is.finite(temp)]
        rgy <- range(temp)
    } else if(all(vapply(X = y[!ynull], FUN = is.character,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all y are character, find domain
        ycha <- TRUE
        temp <- unlist(y)
        temp <- temp[!is.na(temp)]
        if(is.null(ydomain)){ ydomain <- unique(temp) }
        rgy <- c(1, length(ydomain))
    } else {
        stop("Elements in 'y' must be all numeric or all character.")
    }

    ## Recycle if necessary; don't forget NULL flags
    if(length(x) < length(y)){
        x <- rep(x, length.out = length(y))
        xnull <- rep(xnull, length.out = length(y))
    }
    if(length(y) < length(x)){
        y <- rep(y, length.out = length(x))
        ynull <- rep(ynull, length.out = length(x))
    }

    ## Discard common NULLs
    temp <- (xnull & ynull)
    if(any(temp)){
        x <- x[!temp]
        xnull <- xnull[!temp]
        y <- y[!temp]
        ynull <- ynull[!temp]
    }

    ## Check if jitter is needed
    if(xcha && ycha) {
        xjitter[is.na(xjitter)] <- TRUE
        yjitter[is.na(yjitter)] <- TRUE
        type[is.na(type)] <- 'p'
    }

    ## Other NAs
    type[is.na(type)] <- 'l'
    xjitter[is.na(xjitter)] <- FALSE
    yjitter[is.na(yjitter)] <- FALSE
    alpha.f[is.na(alpha.f) & (type %in% c('qx', 'hx', 'qy', 'hy'))] <- 0.25
    alpha.f[is.na(alpha.f)] <- 1

    nplots <- length(x)

    ## Recycle type, lty, lwd, etc
    type <- rep(type, length.out = nplots)
    lty <- rep(lty, length.out = nplots)
    lwd <- rep(lwd, length.out = nplots)
    lend <- rep(lend, length.out = nplots)
    pch <- rep(pch, length.out = nplots)
    col <- rep(col, length.out = nplots)
    alpha.f <- rep(alpha.f, length.out = nplots)
    xjitter <- rep(xjitter, length.out = nplots)
    yjitter <- rep(yjitter, length.out = nplots)

    ## Plot ranges
    if(!isTRUE(is.finite(xlim[1]))){
        if(any(xjitter)){ rgx[1] <- rgx[1] - 1/3 }
        if(any(type == 'hx')){ rgx[1] <- min(rgx[1], 0) }
        xlim[1] <- min(rgx)
    }
    if(!isTRUE(is.finite(xlim[2]))){
        if(any(xjitter)){ rgx[2] <- rgx[2] + 1/3 }
        xlim[2] <- max(rgx)
    }

    if(!isTRUE(is.finite(ylim[1]))){
        if(any(yjitter)){ rgy[1] <- rgy[1] - 1/3 }
        if(any(type == 'hy')){ rgy[1] <- min(rgy[1], 0) }
        ylim[1] <- min(rgy)
    }
    if(!isTRUE(is.finite(ylim[2]))){
        if(any(yjitter)){ rgy[2] <- rgy[2] + 1/3 }
        ylim[2] <- max(rgy)
    }

    ## First plot window
    graphics::matplot(x = xlim, y = ylim, type = 'n',
        xlab = xlab, ylab = ylab, xlim = NULL, ylim = NULL,
        cex.main = cex.main, add = add, axes = FALSE, ...)
### List plots
    for(aplot in seq_len(nplots)){
        ## drop unneeded dimensions
        thisx <- drop(x[[aplot]])
        thisy <- drop(y[[aplot]])

        ## Replace NULL values
        if(is.null(thisx)){
            thisx <- seq_len(NROW(thisy))
            if(xcha){thisx <- xdomain[thisx] }
        }
        if(is.null(thisy)){
            thisy <- seq_len(NROW(thisx))
            if(ycha){thisy <- ydomain[thisy] }
        }

        ## convert characters to integers, according to domains
        if(xcha){
            temp <- dim(thisx)
            thisx <- as.numeric(factor(thisx, levels = xdomain))
            dim(thisx) <- temp
        }
        if(ycha){
            temp <- dim(thisy)
            thisy <- as.numeric(factor(thisy, levels = ydomain))
            dim(thisy) <- temp
        }

        col[[aplot]] <- adjustcolor(col[[aplot]], alpha.f = alpha.f[[aplot]])

        ## Check if jitter needed
        if(isTRUE(xjitter[[aplot]])){ thisx <- jitter(thisx, factor = 5/3) }
        if(isTRUE(yjitter[[aplot]])){ thisy <- jitter(thisy, factor = 5/3) }

        ## Plot
        ## checks for type = 'q'
        if(!(type[[aplot]] %in% c('qx', 'qy', 'hx', 'hy'))){

            ## Plot
            graphics::matplot(x = thisx, y = thisy,
                type = type[[aplot]], lty = lty[[aplot]], lwd = lwd[[aplot]],
                lend = lend[[aplot]], pch = pch[[aplot]], col = col[[aplot]],
                add = TRUE, ...)

        } else if(type[[aplot]] %in% c('qx', 'hx')){
            if(is.null(dim(thisx))){ dim(thisx) <- c(length(thisx), 1) }
            if(is.null(dim(thisy))){ dim(thisy) <- c(length(thisy), 1) }
            if(type[[aplot]] == 'hx'){
                temp <- dim(thisy) * c(1, 2)
                thisy <- c(thisy, rep.int(x = 0, times = length(thisy)))
                dim(thisy) <- temp
            }

            nquant <- ncol(thisy)
            temp <- ncol(thisx)
            for(ii in seq_len(floor(nquant / 2))){
                graphics::polygon(
                    x = c(thisx[,(ii - 1) %% temp + 1],
                        rev(thisx[,(ii - 1) %% temp + 1])),
                    y = c(thisy[, ii], rev(thisy[, nquant + 1 - ii])),
                    col = col[[aplot]], lwd = lwd[[aplot]],
                    border = border, xpd = TRUE)
            }
        } else if(type[[aplot]] %in% c('qy', 'hy')){
            if(is.null(dim(thisx))){ dim(thisx) <- c(length(thisx), 1) }
            if(is.null(dim(thisy))){ dim(thisy) <- c(length(thisy), 1) }
            if(type[[aplot]] == 'hy'){
                temp <- dim(thisx) * c(1, 2)
                thisx <- c(thisx, rep.int(x = 0, times = length(thisx)))
                dim(thisx) <- temp
            }

            nquant <- ncol(thisx)
            temp <- ncol(thisy)
            for(ii in seq_len(floor(nquant / 2))){
                graphics::polygon(
                    x = c(thisx[, ii], rev(thisx[, nquant + 1 - ii])),
                    y = c(thisy[,(ii - 1) %% temp + 1],
                        rev(thisy[,(ii - 1) %% temp + 1])),
                    col = col[[aplot]], lwd = lwd[[aplot]],
                    border = border, xpd = TRUE)
            }
        }
    }

    xat <- yat <- xaxp <- yaxp <- NULL

    if(xcha){
        xat <- seq_along(xdomain)
        if(any(xjitter)){
            xaxp <- c(range(xat) + c(-0.5, 0.5), length(xat))
        } else {
            xaxp <- c(range(xat), length(xat) - 1)
        }
    }
    if(ycha){
        yat <- seq_along(ydomain)
        if(any(yjitter)){
            yaxp <- c(range(yat) + c(-0.5, 0.5), length(yat))
        } else {
            yaxp <- c(range(yat), length(yat) - 1)
        }
    }

    ## Final axes
    if(!add || axes){
        graphics::axis(side = 1, at = xat, labels = xdomain, tick = axes,
            col = 'black', lwd = 1, lty = 1, ...)
        graphics::axis(side = 2, at = yat, labels = ydomain, tick = axes,
            col = 'black', lwd = 1, lty = 1, ...)
    }

    ## Final grid
    if(grid){
        ## Save and restore user's par()
        if(!is.null('xaxp')){
            oldparx <- par(xaxp = xaxp)
            on.exit(par(oldparx))
        }
        if(!is.null('yaxp')){
            oldpary <- par(yaxp = yaxp)
            on.exit(par(oldpary), add = TRUE)
        }
        graphics::grid(nx = NULL, ny = NULL, lty = 1,
            lwd = lwd.grid, col = col.grid)
    }
    invisible()
}


#' Plot numeric or character values
#'
#' @description
#' Plot function that modifies and expands the **graphics** package's [graphics::matplot()] function in several ways.
#'
#' @details
#' This function is essentially a wrapper around [graphics::matplot()], augmenting the latter with some additional features useful for plotting data and results handled by **Prova**. Some of the additional features provided by `flexiplot` are the following:
#'
#' - Either or both `x` and `y` arguments can be of class [`base::character`]. In this case, axes labels corresponding to the unique values are used (see arguments `xdomain` and `ydomain`). This makes it easier to plot nominal and ordinal variates.
#' - A jitter can also be added to the generated points, via the `xjitter` and `yjitter` switches. This makes it easier to generate scatter plots of nominal and ordinal variates.
#' - It is possible to specify only a lower or upper limit in the `xlim` and `ylim` arguments, letting the other limit to be found automatically. This can be useful in plotting probabilities, in cases where we want to specify the lower, `0` limit, but want the upper limit to simply be the the maximum probability.
#' - Transparency of lines or markers can be specified through argument `alpha.f`.
#' - The plotting style is different, and default argument `type = 'l'` (line plot) rather than `type = 'p'` (point plot).
#'
#' See the package's vignettes for more examples.
#'
#' @param x Numeric or character: vector of x-coordinates. If missing, a numeric vector `1:...` is created having as many values as the rows of `y`.
#' @param y Numeric or character: vector of y coordinates. If missing, a numeric vector `1:...` is created having as many values as the rows of `x`.
#' @param xdomain,ydomain Character or numeric or `NULL` (default): vector of possible values of the variates represented in the `x`- and `y`-axes, in case the `x` or `y` argument is a character vector. The ordering of the values is respected. If `NULL`, then `unique(x)` or `unique(y)` is used.
#' @param xlim,ylim `NULL` (default) or a vector of two values. In the latter case, if any of the two values is not finite (including `NA` or `NULL`), then the `min` or `max` `x`- or `y`-coordinates of the plotted points are used.
#' @param grid Logical: whether to plot a light grid. Default `TRUE`.
#' @param alpha.f Numeric, default 1: opacity of the colours, `0` being completely invisible and `1` completely opaque.
#' @param xjitter,yjitter Logical or `NULL` (default): add [base::jitter()] to `x`- or `y`-values? Useful when plotting discrete variates. If `NULL`, jitter is added if the values are of character (or factor) class.
#' @param type,lty,lwd,pch,col,xlab,ylab,add,axes,cex.main see analogous arguments in [graphics::matplot()] and [graphics::plot.default()].
#' @param ... Other parameters to be passed to [graphics::matplot()].
#'
#' @return `NULL`, [invisibly][base::invisible()]; produces a plot, see [graphics::matplot()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to directly plot posterior probabilities and quantiles contained in a probability object.
#'
#' [plotquantiles()] to plot quantile ranges.
#'
#' @examples
#' ## Scatter plot of the 'island' vs 'species' nominal variates of the penguins dataset;
#' ## note how jitter is automatically added:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'island'])
#'
#'
#' ## Scatter plot of the 'bill_len' vs 'species' variates of the penguins dataset:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'bill_len'])
#'
#' ## We can add jitter to separate the nominal values:
#' flexiplot(x = penguins[, 'species'], y = penguins[, 'bill_len'],
#'   xjitter = TRUE)
#'
#'
#' ## Scatter plot of the 'bill_len' vs 'body_mass' variates;
#' ## in this case we must specify the scatter-plot option `type = 'p'`:
#' flexiplot(x = penguins[, 'body_mass'], y = penguins[, 'bill_len'],
#'   type = 'p')
#'
#' ## Calculate the values of a normal distribution in a restricted range
#' x <- seq(from = -2, to = 2, length.out = 127)
#' y <- dnorm(x, mean = 0, sd = 1)
#'
#' ## plot the distribution, with 0 as the lower plot range:
#' flexiplot(x = x, y = y, ylim = c(0, NA))
#'
#' @import grDevices
#' @import graphics
#'
#' @concept display
#' @export
flexiplot <- function(
    x, y,
    type = NULL,
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    pch = c(1, 2, 0, 5, 6, 3), #, 4,
    col = palette(),
    xlab = NULL, ylab = NULL,
    xlim = NULL, ylim = NULL,
    add = FALSE,
    xdomain = NULL, ydomain = NULL,
    alpha.f = 1,
    xjitter = NULL,
    yjitter = NULL,
    ## c( ## Tol's colour-blind-safe scheme
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    grid = TRUE,
    axes = FALSE,
    cex.main = 1,
    ...
){
    xat <- yat <- xaxp <- yaxp <- NULL

    if(!missing(x) && is.factor(x)){
        if(is.null(xlab)){ xlab <- deparse1(substitute(x)) }
        x <- as.character(x)
    }
    if(!missing(y) && is.factor(y)){
        if(is.null(ylab)){ ylab <- deparse1(substitute(y)) }
        y <- as.character(y)
    }

    if(missing('x') && !missing('y')){
        x <- y
        x[] <- rep.int(x = seq_len(NROW(y)),
            times = rep.int(x = NCOL(y), times = NROW(y)))
        if(is.null(ylab)){ ylab <- deparse1(substitute(y)) }
        if(is.null(yjitter)){ yjitter <- FALSE }
        if(is.null(xdomain) && is.null(xlim)){
            xat <- seq_len(NCOL(y))
            xdomain <- NA
            ## if(!is.null(xjitter)){
            ##     xlim <- range(x) + c(-0.04, 0.04)
            ## }
            if(is.null(xlab)){ xlab <- NA }
            if(is.null(type)){ type <- 'p' }
        }
    } else if(!missing('x') && missing('y')){
        y <- x
        y[] <- rep.int(x = seq_len(NROW(x)),
            times = rep.int(x = NCOL(x), times = NROW(x)))
        if(is.null(xlab)){ xlab <- deparse1(substitute(x)) }
        if(is.null(xjitter)){ xjitter <- FALSE }
        if(is.null(ydomain) && is.null(ylim)){
            yat <- seq_len(NCOL(x))
            ydomain <- NA
            ## if(!is.null(yjitter)){
            ##     ylim <- range(y) + c(-0.04, 0.04)
            ## }
            if(is.null(ylab)){ ylab <- NA }
            if(is.null(type)){ type <- 'p' }
        }
    } else if(!missing('x') && !missing('y')){
        if(is.null(xlab)){ xlab <- deparse1(substitute(x)) }
        if(is.null(ylab)){ ylab <- deparse1(substitute(y)) }
    } else {
        stop('Arguments "x" and "y" cannot both be missing')
    }

    if(NROW(y) == 1 && NCOL(y) == NCOL(x)){
        y <- rep(x = y, times = rep.int(x = NROW(x), times = length(y)))
        dim(y) <- dim(x)
        if(is.null(type)){ type <- 'p' }
    }
    if(NROW(x) == 1 && NCOL(x) == NCOL(y)){
        x <- rep(x = x, times = rep.int(x = NROW(y), times = length(x)))
        dim(x) <- dim(y)
        if(is.null(type)){ type <- 'p' }
    }

    if(is.character(x) && is.character(y)) {
        if(is.null(xjitter)){xjitter <- TRUE}
        if(is.null(yjitter)){yjitter <- TRUE}
    }

    ## if x is character, convert to numeric
    if(is.character(x)){
        if(is.null(xdomain)){ xdomain <- unique(x) }
        ## we assume the user has sorted the values in a meaningful order
        ## because the lexical order may not be correct
        ## (think of values like 'low', 'medium', 'high')
        . <- dim(x)
        x <- as.numeric(factor(x, levels = xdomain))
        dim(x) <- .
        xat <- seq_along(xdomain)
        xaxp <- c(range(xat), length(xat) - 1)
        if(is.null(type)){ type <- 'p' }
    }
    if(isTRUE(xjitter)){
        xaxp <- c(range(xat) + c(-0.5, 0.5), length(xat))
        ## xaxp <- c(range(xat), length(xat) - 1)
        x <- jitter(x, factor = 5/3)
    }

    ## if y is character, convert to numeric
    if(is.character(y)){
        if(is.null(ydomain)){ ydomain <- unique(y) }
        ## we assume the user has sorted the values in a meaningful order
        ## because the lexical order may not be correct
        ## (think of values like 'low', 'medium', 'high')
        . <- dim(y)
        y <- as.numeric(factor(y, levels = ydomain))
        dim(y) <- .
        yat <- seq_along(ydomain)
        yaxp <- c(range(yat), length(yat) - 1)
        if(is.null(type)){ type <- 'p' }
    }
    if(isTRUE(yjitter)){
        yaxp <- c(range(yat) + c(-0.5, 0.5), length(yat))
        ## yaxp <- c(range(yat), length(yat) - 1)
        y <- jitter(y, factor = 5/3)
    }

    ## Syntax of xlim and ylim that allows
    ## for the specification of only upper- or lower-bound
    if(length(xlim) == 2){
        if(is.null(xlim[1]) || !is.finite(xlim[1])){ xlim[1] <- min(x[is.finite(x)]) }
        if(is.null(xlim[2]) || !is.finite(xlim[2])){ xlim[2] <- max(x[is.finite(x)]) }
    }
    if(length(ylim) == 2){
        if(is.null(ylim[1]) || !is.finite(ylim[1])){ ylim[1] <- min(y[is.finite(y)]) }
        if(is.null(ylim[2]) || !is.finite(ylim[2])){ ylim[2] <- max(y[is.finite(y)]) }
    }

    if(is.null(type)){ type <- 'l' }

    if(is.na(alpha.f)){alpha.f <- 1}
    col <- adjustcolor(col, alpha.f = alpha.f)

    graphics::matplot(x, y, xlim = xlim, ylim = ylim, type = type, axes = FALSE,
        col = col, lty = lty, lwd = lwd, pch = pch, cex.main = cex.main,
        add = add, xlab = xlab, ylab = ylab, ...)
    if(!add || axes){
        graphics::axis(1, at = xat, labels = xdomain, tick = axes,
            col = 'black', lwd = 1, lty = 1, ...)
        graphics::axis(2, at = yat, labels = ydomain, tick = axes,
            col = 'black', lwd = 1, lty = 1, ...)
    }
    if(grid){
        ## Save and restore user's par()
        if(!is.null('xaxp')){
            oldparx <- par(xaxp = xaxp)
            on.exit(par(oldparx))
        }
        if(!is.null('yaxp')){
            oldpary <- par(yaxp = yaxp)
            on.exit(par(oldpary), add = TRUE)
        }
        graphics::grid(nx = NULL, ny = NULL, lty = 1, col = '#BBBBBB80')
        }
    invisible()
}


#' Plot pairs of quantiles
#'
#' @description
#' Utility function to plot pairs of quantiles obtained with [Pr()].
#'
#' @param x Numeric or character: vector of x-coordinates. See [flexiplot()].
#' @param y Numeric: a matrix having as many rows as `x` and an even number of columns, with one column per quantile. Typically these quantiles have been obtained with [Pr()], as their `$quantiles` value. This value is a three-dimensional array, and one of its columns (corresponding to the possible values of the `X` argument of [Pr()]) or one of its rows (corresponding to the possible values of the `Y` argument of [Pr()]) should be selected before being used as `y` input.
#' @param xdomain Character or numeric or `NULL` (default): vector of possible values of the variate represented in the x-axis, if the `x` argument is a character vector. The ordering of the values is respected. If `NULL`, then [`unique(x)`][base::unique()] is used.
#' @param alpha.f Numeric, default 0.25: opacity of the quantile bands, `0` being completely invisible and `1` completely opaque.
#' @param col Fill colour of the quantile bands. Can be specified in any of the usual ways, see for instance [grDevices::col2rgb()]. Default `#4477AA`.
#' @param lwd Width of the border of the quantile bands.
#' @param border Border colour of the quantile bands. Can be specified in any of the usual ways, see for instance [grDevices::col2rgb()]. If `NA` (default), no border is drawn.
#' @param type,grid,axes,... Other parameters to be passed to [flexiplot()].
#'
#' @return `NULL`, [invisibly][base::invisible()]; produces a plot, see [graphics::matplot()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to directly plot posterior probabilities and quantiles contained in a probability object.
#'
#' [flexiplot()] for more general plots.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## create a grid of values for variate "bill length",
#' ## based on the information in the dataset and metadata:
#' valuesBill <- vrtgrid(vrt = 'bill_len', learnt = learnt)
#'
#' ## calculate the probabilities and quantiles
#' probs <- Pr(Y = valuesBill, learnt = learnt, parallel = 1)
#'
#' ## plot the quantiles, setting lower plot range to zero
#' plotquantiles(x = valuesBill, y = probs$quantiles[, 1, ], ylim = c(0, NA),
#'   xlab = 'bill length', ylab = 'probability')
#'
#' ## add a plot of the probabilities in thick dashed red
#' flexiplot(x = valuesBill, y = probs$values, lwd = 5, lty = 2, col = 2, add = TRUE)
#'
#' @import grDevices
#'
#' @concept display
#' @export
plotquantiles <- function(
    x, y,
    xdomain = NULL,
    alpha.f = 0.25,
    col = palette(),
    lwd = 1,
    ##     c( ## Tol's colour-blind-safe scheme
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    border = NA,
    type = 'n',
    grid = TRUE,
    axes = FALSE,
    ...
){
    ## ## TODO: modify so that a vertical plot is also possible
    if(!is.matrix(y) || ncol(y) %% 2 != 0) {
        stop('"y" must be a matrix with an even number of columns.')
    }
    nquant <- ncol(y)

    isfin <- ( (is.numeric(x) & is.finite(x)) | !is.na(x)) &
        apply(y, 1, function(xx){all(is.finite(xx))})
    x <- unname(x[isfin])
    y <- unname(y[isfin, , drop = FALSE])

    ##
    ## col[!grepl('^#',col)] <- palette()[as.numeric(col[!grepl('^#',col)])]
    ## if(is.na(alpha.f)){alpha.f <- 1}
    ## col <- adjustcolor(col, alpha.f = alpha.f)
    ## if(is.na(alpha)){alpha <- ''}
    ## else if(!is.character(alpha)){alpha <- alpha2hex(alpha)}
    ## if(!(is.na(col) | nchar(col)>7)){col <- paste0(col, alpha)}
    ##
    flexiplot(x = x, y = y, xdomain = xdomain, type = 'n',
        xjitter = FALSE, yjitter = FALSE, grid = FALSE, axes = axes, ...)

    ## if x is character, convert to numeric
    if(is.character(x)){
        if(is.null(xdomain)){ xdomain <- unique(x) }
        ## we assume the user has sorted the values in a meaningful order
        ## because the lexical order may not be correct
        ## (think of values like 'low', 'medium', 'high')
        x <- as.numeric(factor(x, levels = xdomain))
    }
    if(is.na(alpha.f)){alpha.f <- 1}
    col <- adjustcolor(col, alpha.f = alpha.f)
    for(ii in seq_len(nquant/2)) {
        graphics::polygon(x = c(x, rev(x)),
            y = c(y[, ii], rev(y[, nquant + 1 - ii])),
            col = col, border = border, xpd = TRUE, lwd = lwd)
    }
    if(grid){
        ## Save and restore user's par()
        if(!is.null('xaxp')){
            oldparx <- par(xaxp = xaxp)
            on.exit(par(oldparx))
        }
        if(!is.null('yaxp')){
            oldpary <- par(yaxp = yaxp)
            on.exit(par(oldpary), add = TRUE)
        }
        graphics::grid(nx = NULL, ny = NULL, lty = 1, col = '#BBBBBB80')
        }
    invisible()
}


#' Plot an object of class "probability"
#'
#' @description
#' This [base::plot()] method is a utility to plot probabilities obtained with [Pr()], as well as their revisabilities. The probabilities are plotted either against `Y`, with one curve for each value of `X`, or vice versa.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param spread One of the values `'quantiles'`, `'samples'`, `'none'` (equivalent to `NA` or `FALSE`), or `NULL` (default), in which case the revisability available in `p` is used. This argument chooses how to represent the revisability of the probability; see [Pr()]. If the requested representation is not available in the object `x`, then a warning is issued and no revisability is plotted.
#' @param subset Named list or named vector: which variate values to display. For the variates corresponding to the names in this list, only the vector of values corresponding to that variate is displayed.
#'
#' @param PvsY Logical or `NULL`: should probabilities be plotted against their `Y` argument? If `NULL`, the argument between `Y` and `X` having larger number of values is chosen. As many probability curves will be plotted as the number of values of the other argument.
#' @param ylab2 A title for the y-axis on the right side of the plot, if displayed.
#' @param legend One of the values `'bottomright'`, `'bottom'`, `'bottomleft'`, `'left'`, `'topleft'`, `'top'`, `'topright'`, `'right'`, `'center'` (see [graphics::legend()]): plot a legend at that position. A value `FALSE` or any other does not plot any legend. Default `'top'`.
#' @param alpha.f Numeric, default 0.25: opacity of the colours, `0` being completely invisible and `1` completely opaque.
#' @param var.alpha.f Numeric: opacity of the quantile bands or of the samples, `0` being completely invisible and `1` completely opaque.
#' @param var.nsamples Integer, default 360: number of samples of long-run frequencies to display
#' @param lty,lwd,pch,col,type,xlab,ylab,main,ylim,grid,axes,add see analogous arguments in [graphics::plot.default()] and [graphics::matplot()].
#' @param ... Other parameters to be passed to [flexiplot()].
#'
#' @return `NULL`, [invisibly][base::invisible()]; produces a plot, see [graphics::matplot()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [hist.probability()] to plot the revisability of the probabilities as a distribution.
#'
#' [flexiplot()] (on which `plot.probability()` is based) for more general plots.
#'
#' [plotquantiles()] to plot quantile ranges.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## create a grid of values for variate "bill length",
#' ## based on the information in the dataset and metadata:
#' valuesBill <- vrtgrid(vrt = 'bill_len', learnt = learnt)
#'
#' ## calculate the probabilities and quantiles
#' probs <- Pr(Y = valuesBill, learnt = learnt, parallel = 1)
#'
#' ## plot the probabilities and quantiles
#' plot(probs)
#'
#' @import grDevices
#'
#' @concept display
#' @export
plot.probability <- function(
    x,
    spread = NULL,
    subset = NULL,
    PvsY = NULL,
    legend = 'top',
    lty = c(1, 2, 4, 3, 6, 5),
    pch = c(1, 2, 0, 5, 6, 3), #, 4,
    lwd = 2,
    col = palette(),
    type = NULL,
    ##     c( ## Tol's colour-blind-safe scheme, or palette()
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    alpha.f = 1,
    var.alpha.f = NULL,
    var.nsamples = 360,
    xlab = NULL,
    ylab = NULL,
    ylab2 = NULL,
    main = NULL,
    ylim = c(0, NA),
    grid = TRUE,
    axes = FALSE,
    add = FALSE,
    ...
){
    ## Replace object x keeping only values given in 'subset'
    if(!is.null(subset)){
        x <- .prsubset(x, subset = subset)
    }

    ## If there's only one probability it doesn't make sense to plot anything:
    ## print() the result instead
    if(length(x[['values']]) == 1){
        return(print(x))
    }



    ## Check how we should represent the revisability
    ## The user can choose among three options
    ## provided that option is available in argument 'x'
    if(is.null(spread)) { # User is not choosing
        ## We choose 'quantiles' or what's available
        if(!is.null(x[['quantiles']])) {
            spread <- 'quantiles'
        } else if(!is.null(x[['samples']])){
            spread <- 'samples'
        } else {
            spread <- 'none'
        }
    } else { # User is choosing
        if(is.na(spread) || isFALSE(spread)){ spread <- 'none'}

        ## handle shortenings
        spread <- match.arg(spread, c('quantiles', 'samples', 'none'))

        ## handle impossible requests
        if(
        (spread == 'quantiles' && is.null(x[['quantiles']])) ||
            (spread == 'samples' && is.null(x[['samples']]))
        ) {
            message('Requested spread not available. Omitting its plot.')
            spread <- 'none'
        }
    }

    Ylen <- nrow(x[['values']])
    Xlen <- ncol(x[['values']])

    ## Rename the revisability object so as to avoid if-else below
    if(spread == 'quantiles'){
        mainpercentiles <- c(5.5, 94.5) # By default we choose an 89% band
        pvar <- x[['quantiles']]
        maxvar <- max(pvar, na.rm = TRUE)
        ## if we are plotting more than one curve, keep only the 89% band
        if(Xlen > 1 && Ylen > 1){
            qnames <- as.numeric(sub('%', '', dimnames(pvar)[[3]]))
            choosepercentiles <- sapply(mainpercentiles,
                function(xx){which.min(abs(qnames - xx))})
            pvar <- pvar[, , choosepercentiles, drop = FALSE]
            qnames <- as.numeric(sub('%', '', dimnames(pvar)[[3]]))
        }
        qnames <- as.numeric(sub('%', '', dimnames(pvar)[[3]]))
        if(is.null(var.alpha.f)){var.alpha.f <- 0.25}

    } else if(spread == 'samples'){
        maxvar <- max(apply(
            X = x[['samples']], MARGIN = c(1, 2), FUN = quantile,
            probs = 0.954, na.rm = TRUE, names = FALSE, type = 6
        ))
        temp <- dim(x[['samples']])[3]
        pvar <- x[['samples']][, , round(seq(from = 1, to = temp,
                length.out = min(var.nsamples, temp))), drop = FALSE]
        if(is.null(var.alpha.f)){var.alpha.f <- 1/ceiling(sqrt(dim(pvar)[3]))}
        ## if(is.null(var.alpha.f)){var.alpha.f <- 1/10}
    } else {
        pvar <- NULL
        maxvar <- -Inf
    }

    ## Handle the case of missing Y and X items in 'x'
    if(is.null(x$Y)){
        x$Y <- data.frame(Y = paste0('Y', seq_len(Ylen)))
        if(Xlen > 1){
            x$X <- data.frame(X = paste0('X', seq_len(Xlen)))
        }
    }

    ## Check for singular-probability values
    isdensity <- any(x$densities > 0)

    ## If 'PvsY' is NULL, then we guess that the longest between Y and X
    ## is meant to be abscissa
    if(is.null(PvsY)){ PvsY <- (Ylen >= Xlen) }

    if(isTRUE(PvsY)){
        xxx <- x$Y
        leg <- x$X
        tempxlab <- 'Y'
        xdeltas <- (x$densities < max(x$densities))
    } else {
        xxx <- x$X
        leg <- x$Y
        tempxlab <- 'X'
        x[['values']] <- t(x[['values']])
        if(!is.null(pvar)){ pvar <- aperm(pvar, c(2, 1, 3)) }
        xdeltas <- FALSE
    }

    ## If the abscissa has more than one variate,
    ## then it becomes tricky to understand which of these we must plot against
    ## Heuristic: if there's one variate with as many unique elements as xxx,
    ## then use that one. Otherwise use a generic 'Y...'
    if(ncol(xxx) == 1){
        tempxlab <- colnames(xxx)
        xxx <- unlist(xxx)
    } else {
        uniquevrts <- apply(xxx, 2, function(xx){length(unique(xx))})
        toselect <- which(uniquevrts == nrow(xxx))[1]
        if(is.na(toselect)){
            xxx <- seq_len(nrow(xxx))
        } else {
            tempxlab <- colnames(xxx)[toselect]
            xxx <- xxx[, toselect]
        }
    }

    if(is.null(xlab)){xlab <- tempxlab}
    if(missing(main)){
        main <- paste0('P(',
            paste0(names(x$Y), collapse = ', '),
            if(!is.null(x$X)){
                paste0(' | ', paste0(names(x$X), collapse = ', '))
            }, ')')
        if(spread == 'quantiles'){
            main <- paste0(main, '\nquantiles: ',
                paste0(round(qnames, 1), '%', collapse = ', '))
        }
    }
    if(is.null(ylab)){
        ylab <- paste0('probability', if(isdensity){' density'})
    }

    if(is.null(type)){
        if(is.character(xxx)){type <- 'b'} else {type <- 'l'}
    }

    if(any(xdeltas)){
        if(is.null(ylab2)){
            ylab2 <- paste0('probability',
                if(max(x$densities[-which.max(x$densities)]) == 0){' density'},
                ' at singular points')
        }
        oldpar <- par(mar = par('mar') + c(0, 0, 0, 1.5))
        on.exit(par(oldpar))
    }


    ## Plot the revisability first
    ## find maximum and minimum y-value first, if needed
    if(is.na(ylim[2])){
        ylim[2] <- max(maxvar, x[['values']])
    }
    if(is.na(ylim[1])){
        ylim[1] <- min(maxvar, x[['values']])
    }

    if(!is.null(pvar)){
        ## prepare window
        flexiplot(x = xxx,
            y = matrix(pvar, nrow = dim(pvar)[1]),
            type = 'n',
            xlab = xlab,
            ylab = ylab,
            ylim = ylim,
            main = main,
            grid = FALSE,
            axes = axes,
            add = add,
            ...)
        add <- TRUE
    }

    if(any(xdeltas)){
        if(spread == 'quantiles'){
            mpvar <- max(pvar[xdeltas, , ], na.rm = TRUE)
        } else if(spread == 'samples'){
            mpvar <- max(apply(
                X = x[['samples']][xdeltas, , , drop = FALSE],
                MARGIN = c(1, 2), FUN = quantile,
                probs = 0.954, na.rm = TRUE, names = FALSE, type = 6
            ))
        } else {
            mpvar <- max(x[['values']][xdeltas, ], na.rm = TRUE)
        }
        ## compute max probability of singular points,
        ## and find conversion scale
        yticks <- axTicks(4)
        ydivs <- length(yticks) - 1
        yloc <- min(yticks)
        yscale <- signif(x = mpvar / ydivs, digits = 1)
        yscale <- (max(yticks) - yloc) / (yscale * ydivs)
        ## ceiling(yscale * 10^(-floor(log10(yscale)) + 1)) *
        ##     10^(floor(log10(yscale)) - 1) * ydivs
        ## add axis for singular probability values
        graphics::axis(4, at = yticks, labels = (yticks - yloc) / yscale,
            tick = !grid, col = 'black', lwd = 1, lty = 1)
    }


    if(spread == 'quantiles'){
        for(i in seq_len(dim(pvar)[2])){
            plotquantiles(x = unlist(xxx)[!xdeltas],
                y = pvar[!xdeltas, i, ],
                col = col[(i - 1) %% length(col) + 1],
                alpha.f = var.alpha.f,
                lty =  lty[(i - 1) %% length(lty) + 1],
                grid = FALSE,
                axes = FALSE,
                add = TRUE,
                ...)

            if(any(xdeltas)){
                for(xd in which(xdeltas)){
                    plotquantiles(x = unlist(xxx)[xd],
                        y = yscale * pvar[, i, ][xd, , drop = FALSE] + yloc,
                        col = col[(i - 1) %% length(col) + 1],
                        border = adjustcolor(col[(i - 1) %% length(col) + 1],
                            alpha.f = var.alpha.f),
                        alpha.f = var.alpha.f,
                        lty =  lty[(i - 1) %% length(lty) + 1],
                        lwd = 10,
                        grid = FALSE,
                        axes = FALSE,
                        add = TRUE,
                        ...)
                }
            }
        }

    } else if(spread == 'samples'){
        ## the samples are plotted alternating between the different subgroups,
        ## rather than one group at a time, in order to avoid that
        ## the samples of the last subgroup cover the previous ones
        nx <- dim(pvar)[2]
        dim(pvar) <- c(dim(pvar)[1], prod(dim(pvar)[-1]))
        flexiplot(x = xxx[!xdeltas], y = pvar[!xdeltas, , drop = FALSE],
            type = type,
            col = col[(seq_len(nx) - 1) %% length(col) + 1],
            alpha.f = var.alpha.f,
            lty =  1, #lty[(seq_len(nx) - 1) %% length(lty) + 1],
            lwd = 0.5, #lwd[(seq_len(nx) - 1) %% length(lwd) + 1] / 4,
            grid = FALSE,
            axes = FALSE,
            add = TRUE,
            ...)

            if(any(xdeltas)){
                for(xd in which(xdeltas)){
        flexiplot(x = xxx[xd], y = yscale * pvar[xd, , drop = FALSE] + yloc,
            type = 'p',
            col = col[(seq_len(nx) - 1) %% length(col) + 1],
            alpha.f = var.alpha.f,
            pch = '-',
            lty =  1, #lty[(seq_len(nx) - 1) %% length(lty) + 1],
            lwd = 0.5, #lwd[(seq_len(nx) - 1) %% length(lwd) + 1] / 4,
            xjitter = FALSE,
            yjitter = FALSE,
            grid = FALSE,
            axes = FALSE,
            add = TRUE,
            ...)
                }
            }
    }

    ## Plot the probabilities
    flexiplot(x = xxx[!xdeltas],
        y = x[['values']][!xdeltas, , drop = FALSE],
        type = type,
        col = col,
        alpha.f = alpha.f,
        lty = lty,
        lwd = lwd,
        xlab = xlab,
        ylab = ylab,
        ylim = ylim,
        main = main,
        grid = grid,
        axes = axes,
        xjitter = FALSE,
        yjitter = FALSE,
        add = add,
        ...)

    if(any(xdeltas)){
    flexiplot(x = xxx[xdeltas],
        y = yscale * x[['values']][xdeltas, , drop = FALSE] + yloc,
        type = 'p',
        col = col,
        alpha.f = alpha.f,
        lty = lty,
        pch = pch,
        lwd = lwd,
        xlab = xlab,
        ylab = ylab,
        ylim = ylim,
        main = main,
        grid = grid,
        axes = axes,
        xjitter = FALSE,
        yjitter = FALSE,
        add = TRUE,
        ...)

    mtext(ylab2, side = 4, line = 2.25)

}
    ## Plot legends
    if(!is.null(leg)){
        ##  && is.character(legend) &&
        ## (legend %in%
        ##      c("bottomright", "bottom", "bottomleft", "left", "topleft",
        ##          "top", "topright", "right", "center"))
        tails <- list()
        tails[names(leg)] <- '='
        tails[names(x$tails)] <- x$tails
        graphics::legend(x = legend,
            legend = apply(leg, 1, function(xxx){
                nxxx <- names(xxx)
                paste0(paste0(nxxx, ' ', tails[nxxx], ' ', xxx),
                    collapse = ', ')
            }),
            bty = 'n',
            col = col,
            lty = lty,
            lwd = lwd,
            ...)
    }
    invisible()
}


#' Plot the revisability of an object of class "probability" as a histogram
#'
#' @description
#' The posterior probabilities calculated with the [Pr()] function, and outputted as a "probability" object, have an associated "revisability" that comes from the finite size of the data sample. This revisability can be interpreted in two ways:
#'
#' - How the probabilities could change, if we collected a much larger (infinite) data sample, and how likely would such change be;
#' - The relative frequency of a particular variate value in the full (sampled and unsampled) population is unknown; we can quantify our uncertainty about this relative frequency with a probability distribution.
#'
#' The `hist()` method for a "probability" object is a utility to visualize this kind of revisability, in the form of a distribution.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param subset Named list or named vector: which variate values to display. For the variates corresponding to the names in this list, only the vector of values corresponding to that variate is displayed.
#' @param breaks `NULL` or as in function [graphics::hist()]. If `NULL` (default), an optimal number of breaks for each probability distribution is computed.
#' @param fill.alpha.f Numeric, default 0.125: opacity of the histogram filling. `0` means no filling.
#' @param legend One of the values `"bottomright"`, `"bottom"`, `"bottomleft"`, `"left"`, `"topleft"`, `"top"`, `"topright"`, `"right"`, `"center"` (see [graphics::legend()]): plot a legend at that position. A value `FALSE` or any other does not plot any legend. Default `"top"`.
#' @param showmean Logical, default `TRUE`: show the means of the probability distributions? The means correspond to the probabilities about the next observed unit.
#' @param lty,lwd,col,alpha.f,xlab,ylab,xlim,ylim,main,grid,axes,add see analogous arguments in [graphics::matplot()]
#' @param ... Other parameters to be passed to [flexiplot()].
#'
#' @return [Invisibly][base::invisible()], an object of class ["histogram"][graphics::hist()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to plot the posterior probabilities.
#'
#' [flexiplot()] (on which `hist.probability()` is based) for more general plots.
#'
#' [plotquantiles()] to plot quantile ranges.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## calculate the probability, and its revisability,
#' ## for the value 'Adelie' of the "species" variate
#' probs <- Pr(Y = data.frame(species = 'Adelie'), learnt = learnt, parallel = 1)
#' probs$values
#'
#' ## show the revisability of this probability; equivalently show
#' ## the probability distribution for the relative frequency of
#' ## 'Adelie' penguins in the full population
#' hist(probs, legend = 'topright')
#'
#' @import graphics
#'
#' @concept display
#' @export
hist.probability <- function(
    x,
    subset = NULL,
    breaks = NULL,
    legend = 'top',
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    col = palette(),
    alpha.f = 1,
    fill.alpha.f = 0.125,
    showmean = TRUE,
    ##     c( ## Tol's colour-blind-safe scheme, or palette()
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    xlab = NULL,
    ylab = NULL,
    xlim = NULL,
    ylim = c(0, NA),
    main = NULL,
    grid = TRUE,
    axes = FALSE,
    add = FALSE,
    ...
){
    ## Replace object x keeping only values given in 'subset'
    if(!is.null(subset)){
        x <- .prsubset(x, subset = subset)
    }

    ## Check that samples are available in the probability object
    if(is.null(x[['samples']])) {
        stop('The "probability" object does not contain any revisability samples')
        }
    pvar <- x[['samples']]
    Ylen <- nrow(x[['values']])
    Xlen <- ncol(x[['values']])

    if(is.null(breaks)){n <- ceiling(sqrt(dim(pvar)[3])/2)} else {n <- NULL}

    ## Precompute histograms, to determine maximum y-value
    midslist <- densitylist <- list()
    i <- 0L
    for(xx in seq_len(Xlen)){ for(yy in seq_len(Ylen)){
        i <- i + 1L
        ff <- pvar[yy, xx, ]
        rg <- range(ff)
        if(diff(rg)==0){rg <- c(0, 1)}
        if(!is.null(n)){ breaks <- seq(rg[1], rg[2], length.out = n + 1) }
        hd <- graphics::hist(x = ff, breaks = breaks, plot = FALSE)
        midslist[[i]] <- hd$mids
        densitylist[[i]] <- hd$density
    } }

    if(is.null(xlab)){
        xlab <- 'long-run relative frequency'
    }
    if(is.null(ylab)){ylab <- 'probability density'}
    if(isFALSE(fill.alpha.f) || !is.numeric(fill.alpha.f)){fill.alpha.f <- 0}

    if(missing(xlim)){xlim <- range(unlist(midslist))}
    if(is.na(ylim)[2]){ylim[2] <- max(unlist(densitylist))}

    i <- 0L
    for(xx in seq_len(Xlen)){ for(yy in seq_len(Ylen)){
        i <- i + 1L
        midx <- midslist[[i]]
        y <- densitylist[[i]]
        thiscol <- col[(i - 1) %% length(col) + 1]
        thislty <- lty[(i - 1) %% length(lty) + 1]
        if(alpha.f > 0){
            ## Plot the shaded areas under the histograms
            ## by means of plotquantiles()
            plotquantiles(x = midx,
                y = cbind(rep.int(x = 0, times = length(y)), y),
                col = thiscol,
                alpha.f = fill.alpha.f,
                xlab = xlab, ylab = ylab,
                xlim = xlim, ylim = ylim,
                main = main,
                grid = grid,
                axes = axes,
                lty = 0,
                add = (add || i > 1),
                ...)
        }

        flexiplot(x = midslist[[i]], y = densitylist[[i]],
            xlab = xlab, ylab = ylab,
            xlim = xlim, ylim = ylim,
            main = main,
            col = thiscol,
            alpha.f = alpha.f,
            lty = thislty,
            lwd = lwd,
            grid = grid,
            axes = axes,
            xjitter = FALSE,
            yjitter = FALSE,
            add = (add || alpha.f >0 || i > 1),
            ...
        )
        if(isTRUE(showmean)){
            graphics::abline(v = x[['values']][yy, xx],
                col = adjustcolor(thiscol, alpha.f * 0.75),
                lty = thislty,
                lwd = lwd * 0.75)
        }
    } }

    ## Plot legends
    if(is.character(legend) &&
           (legend %in%
                 c("bottomright", "bottom", "bottomleft", "left", "topleft",
                     "top", "topright", "right", "center"))){
        tails <- list()
        if(!is.null(x$Y)){
            tails[names(x$Y)] <- '='
            tails[names(x$tails)] <- x$tails
            legs <- paste0(apply(x$Y, 1, function(xxx){
                nxxx <- names(xxx)
                paste0(paste0(nxxx, ' ', tails[nxxx], ' ', xxx),
                    collapse = ', ')
        }))
        ## legs <- paste0(apply(x$Y, 1, function(xxx){
        ##         paste0(paste0(names(xxx), ' = ', xxx), collapse = ', ')
        ## }))
        } else {
        legs <- paste0(apply(as.data.frame(x$pY), 1, function(xxx){
                paste0(paste0(xxx, '-qtl'), collapse = ', ')
        }))
        }
        if(!is.null(x$X)){
            tails[names(x$X)] <- '='
            tails[names(x$tails)] <- x$tails
            legs <- c(outer( legs,
                paste0(' | ',
                    apply(x$X, 1, function(xxx){
                        nxxx <- names(xxx)
                        paste0(paste0(nxxx, ' ', tails[nxxx], ' ', xxx),
                            collapse = ', ')
                    })
                ),
                paste0))
        }

        graphics::legend(x = legend,
            legend = legs,
            bty = 'n',
            col = col,
            lty = lty,
            lwd = lwd,
            ...)
    }
    ## Return output of initial hist()
    invisible(hd)
}


#' Print an object of class "probability"
#'
#' @description
#' This [base::print()] method is a utility to display selected elements of a "probability" object obtained with [Pr()]; typically its posterior probabilies (element `$values`) and their revisabilities (element `$quantiles`). If the `Y` or `X` variates are joint variates, this method also allow to display only selected values of them. Singular probabilities, such as the probability of a censored value for a continuous variate, are indicated with an asterisk `*`.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param elements character or integer vector, or `NULL` (default): elements of the "probability" object to display. The syntax is the same as with [` [ `][base::Extract]. If `NULL`, the elements `$values` and `$quantiles` are displayed together in a special way.
#' @param subset Named list or named vector: which variate values to display. For the variates corresponding to the names in this list, only the vector of values corresponding to that variate is displayed.
#' @param digits positive integer or `NULL` or `TRUE` (default): minimal number of significant digits, see [base::print.default()]. If value is `TRUE`, then the significant digits for elements `$values` and `$quantiles` are determined from their respective `$values.MCaccuracy` and `$quantiles.MCaccuracy` elements of the "probability" object (see [Pr()]), according to the rules of the *Guide to the expression of Uncertainty in Measurement*, keeping as many digits as given in parameter `edigits`; whereas `$samples` elements uses `edigits` significant digits.
#' @param edigits positive integer, default 2: number of significant digits for elements `$values.MCaccuracy` and `$quantiles.MCaccuracy`, if `digits = TRUE`.
#' @param ... Other parameters to be passed to [base::print()].
#'
#' @return Its `x` argument, [invisibly][base::invisible()]; see [base::print()].
#' @references
#'
#' - Joint Committee for Guides in Metrology (2008): *Guide to the expression of uncertainty in measurement*, <doi:10.59161/JCGM100-2008E>, <https://www.iso.org/sites/JCGM/GUM-JCGM100.htm>.
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()'.
#' [hist.probability()] to plot the revisability of the probabilities as a distribution.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## Calculate the 3 x 2 probabilities for the 3 species
#' ## given bill-lengths of 43 mm and 44 mm
#'
#' Y <- data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo'))
#' X <- data.frame(bill_len = c(43, 44))
#'
#' probs <- Pr(Y = Y, X = X, learnt = learnt, parallel = 1)
#'
#' ## display the values and revisabilities of these probabilities
#' print(probs)
#'
#' ## diplay 'values' only, and only for the species value 'Gentoo'
#' print(probs, elements = 'values', subset = list(species = 'Gentoo'))
#'
#' @concept display
#' @export
print.probability <- function(
    x,
    elements = NULL,
    subset = NULL,
    digits = TRUE,
    edigits = 2,
    ...
){
    ## Replace object x keeping only values given in 'subset'
    if(!is.null(subset)){
        x <- .prsubset(x, subset = subset)
    }

    if(isTRUE(digits) && is.null(elements)){
        vdigits <- edigits - 1 + ceiling(log10(x[['values']])) -
            floor(log10(x[['values.MCaccuracy']]))
        adigits <- rep.int(x = edigits,
            times = length(x[['values.MCaccuracy']]))
        if('quantiles' %in% names(x)){
            qdigits <- edigits - 1 + ceiling(log10(x[['quantiles']])) -
                floor(log10(x[['quantiles.MCaccuracy']]))
        } else {qdigits <- NULL}
    } else if(is.null(elements)){
            vdigits <- adigits <- qdigits <- digits
    } else if(!is.null(elements)){
        digits <- edigits
    }

    if(is.null(elements)){
        totake <- c('values', 'values.MCaccuracy', 'quantiles')
        ## rearrange and combine values and quantiles in a special way
        temp <- aperm(a = array(data = .signifC(
            x = unname(unlist(x[totake])),
            digits = c(vdigits, adigits, qdigits) ),
            dim = c(dim(x[['values']]),
                2 + (if(is.null(x[['quantiles']])){0}else{dim(x[['quantiles']])[3]}) ),
            dimnames = c(dimnames(x[['values']]),
                setNames(object = list(c('value', '+/-',
                    if(!is.null(x[['quantiles']])){
                        paste0('Q', dimnames(x[['quantiles']])[[3]])
                    }
                )), nm = paste0('probability',
                    if(any(x[['densities']] > 0)){' density'}))
                )),
            perm = c(1,3,2))
        temp2 <- dimnames(temp)[[1]][x[['densities']] < max(x[['densities']])]
        dimnames(temp)[[1]][x[['densities']] < max(x[['densities']])] <-
            paste0(temp2, '*')

        if(is.null(x$X)){temp <- temp[,,]}

        print(x = noquote(temp), ...)

    } else {
        print(x = x[elements], digits = digits, ...)
    }
    invisible(x)
}


#' Plot the revisability of an object of class "mi" as a histogram
#'
#' @description
#' The mutual information calculated with the [mutualinfo()] function, and outputted as a "mi" object, has an associated "revisability" that comes from the finite size of the data sample. A much larger sample might reveal a different value of mutual information.
#'
#' The `hist()` method for a "mi" object is a utility to visualize this kind of revisability, in the form of a distribution: it shows how the mutual information could change, if we collected a much larger (infinite) data sample, and how likely would such change be.
#'
#' @param x Object of class "mi", obtained with [mutualinfo()].
#' @param breaks `NULL` or as in function [graphics::hist()]. If `NULL` (default), an optimal number of breaks for each probability distribution is computed.
#' @param fill.alpha.f Numeric, default 0.125: opacity of the histogram filling. `0` means no filling.
#' @param showvalue Logical, default `TRUE`: show the mutual information obtained from the current data sample?
#' @param lty,lwd,col,alpha.f,xlab,ylab,xlim,ylim,main,grid,axes,add see analogous arguments in [graphics::matplot()]
#' @param ... Other parameters to be passed to [flexiplot()].
#'
#' @return [Invisibly][base::invisible()], an object of class ["histogram"][graphics::hist()].
#'
#' @seealso
#' [mutualinfo()] to calculate mutual information and its revisability.
#'
#' [print.mi()] ] to plot mutual information and quantiles calculated by `mutualinfo()`
#'
#' [flexiplot()] (on which `hist.mi()` is based) for more general plots.
#'
#' @examples
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## calculate the mutual information and its revisability
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
#'   learnt = learnt, nv = 2, parallel = 1)
#'
#' ## show the possible revisability of the mutual information,
#' ## if a much larger data sample were collected
#' hist(MI)
#'
#' @import graphics
#'
#' @concept display
#' @export
hist.mi <- function(
    x,
    breaks = NULL,
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    col = palette(),
    alpha.f = 1,
    fill.alpha.f = 0.125,
    showvalue = TRUE,
    ##     c( ## Tol's colour-blind-safe scheme, or palette()
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    xlab = NULL,
    ylab = NULL,
    xlim = NULL,
    ylim = c(0, NA),
    main = NULL,
    grid = TRUE,
    axes = FALSE,
    add = FALSE,
    ...
){

    ## Check that samples are available in the HI object
    if(is.null(x[['samples']])) {
        stop('The MI object does not contain any revisability samples')
        }
    ff <- x[['samples']]

    if(is.null(breaks)){n <- ceiling(sqrt(length(ff))/2)} else {n <- NULL}

    ## Precompute histogram
    rg <- range(ff)
    if(diff(rg)==0){rg <- c(0, 1)}
    if(!is.null(n)){ breaks <- seq(rg[1], rg[2], length.out = n + 1) }
    hd <- graphics::hist(x = ff, breaks = breaks, plot = FALSE)
    midslist <- hd$mids
    densitylist <- hd$density

    if(is.null(xlab)){
        xlab <- paste0('long-run mutual information / ', x$unit)
    }

    if(is.null(ylab)){ylab <- 'probability density'}
    if(isFALSE(fill.alpha.f) || !is.numeric(fill.alpha.f)){fill.alpha.f <- 0}
    if(missing(xlim)){xlim <- range(midslist)}
    if(missing(main)){
        main <- paste0('long-run MI  ',
            paste0(x$Y1names, collapse = ', '),
            '  &  ',
            paste0(x$Y2names, collapse = ', ')
        )
    }

    if(alpha.f > 0){
            ## Plot the shaded areas under the histograms
            ## by means of plotquantiles()
        plotquantiles(x = midslist,
            y = cbind(rep.int(x = 0, times = length(densitylist)), densitylist),
            col = col,
            alpha.f = fill.alpha.f,
            xlab = xlab, ylab = ylab,
            xlim = xlim, ylim = ylim,
            main = main,
            grid = grid,
            axes = axes,
            lty = 0,
            add = add,
            ...)
    }

    flexiplot(x = midslist, y = densitylist,
        xlab = xlab, ylab = ylab,
        xlim = xlim, ylim = ylim,
        main = main,
        col = col,
        alpha.f = alpha.f,
        lty = lty,
        lwd = lwd,
        grid = grid,
        axes = axes,
        xjitter = FALSE,
        yjitter = FALSE,
        add = (add || alpha.f >0),
        ...
    )
    if(isTRUE(showvalue)){
        graphics::abline(v = x[['value']],
            col = adjustcolor(col, alpha.f * 0.75),
            lty = lty,
            lwd = lwd * 0.75)
    }

    invisible(hd)
}


#' Print an object of class "mi" (mutual information)
#'
#' @description
#' This [base::print()] method is a utility to display value and revisability of an "mi" object obtained with [mutualinfo()].
#'
#' @param x Object of class "mi", obtained with [mutualinfo()].
#' @param digits positive integer or `NULL` or `TRUE` (default): minimal number of significant digits, see [base::print.default()]. If value is `TRUE`, then the significant digits for element `$value` is determined from is respective `$MCaccuracy`  (see [mutualinfo()]), according to the rules of the *Guide to the expression of Uncertainty in Measurement*, keeping as many digits as given in parameter `edigits`; whereas `$quantiles` elements uses `edigits` significant digits.
#' @param edigits positive integer, default 2: number of significant digits for element `$value` and `$quantiles`, if `digits = TRUE`.
#' @param unit Either `NULL`, or one of 'Sh' for *shannon* (default), 'Hart' for *hartley*, 'nat' for *natural unit*, or a positive real indicating the base of the logarithms to be used; see analogous argument in [mutualinfo()]. If `NULL` (default), the same unit as in the object `x` is used. Unit conversion is internally performed if this unit is different from that of the object `x`.
#' @param ... Other parameters to be passed to [base::print()].
#'
#' @return Its `x` argument, [invisibly][base::invisible()]; see [base::print()].
#'
#' @seealso
#' [mutualinfo()] to calculate mutual information.
#'
#' [hist.mi()] to plot the revisability of the mutual information.
#'
#' @examples
#' \donttest{
#' ### WARNING: the following example, if run, might even take a minute or more.
#'
#' ## Load the example `learnt` object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' learnt <- learntExample
#'
#' ## Calculate the mutual information between variates 'species' and 'bill_len'
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len',
#'   learnt = learnt, parallel = 1)
#'
#' ## display the value and revisability of the mutual information
#' print(MI)
#'
#' ## convert to hartleys (base-10 logarithms):
#' print(MI, unit = 'Hart')
#' }
#'
#' @concept display
#' @export
print.mi <- function(
    x,
    digits = TRUE,
    edigits = 2,
    unit = NULL,
    ...
){

    xunit <- x[['unit']]
    if(is.null(unit) || unit == xunit){
        unit <- xunit
        lbase <- 1
    } else {
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

        ## Convert symbol in x-object to log
        if (xunit == 'Sh') {
            xlbase <- log(2)
        } else if (xunit == 'Hart') {
            xlbase <- log(10)
        } else if (xunit == 'nat') {
            xlbase <- 1
        } else {
            xlbase <- log(xunit)
        }

        lbase <- lbase / xlbase
    }

    xvalue <- x[['value']] / lbase
    xquants <- x[['quantiles']] / lbase
    xacc <- x[['MCaccuracy']] / lbase

    if(isTRUE(digits)){
        vdigits <- edigits - 1 + ceiling(log10(xvalue)) -
            floor(log10(xacc))
        adigits <- edigits
        qdigits <- rep.int(x = edigits, times = length(xquants))
    } else {
        vdigits <- adigits <- qdigits <- digits
    }

    temp <- .signifC(x = c(xvalue, xquants),
        digits = c(vdigits, qdigits))
    names(temp) <- c(paste0('value/', unit), paste0('Q', names(xquants)))
    print(x = noquote(temp), ...)
}



#' Subset variates of an object of class "probability"
#'
#' An object of class "probability", obtained with the [Pr()] function, holds the probabilities for all possible combinations of values of a set of joint variates `Y` conditional on a set of joint variates `X`, together with the revisabilities of these probabilities and some other information. In some cases one may wish to exclude some of the values of the `Y` or `X` variates. For instance `Y` in the probability-class object could include the variate "age" with values from 18 to 100, and one may want to retain the values from 60 to 80.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param subset Named list or named vector: variates to subset, given as list names, and corresponding values to subset.
#'
#' @return An object of class "probability", identical to the original object `x` except for a reduced range of values in some if its variates.
#'
## #' @seealso
## #' [Pr()], which generates probability objects.
## #'
## #' [plot.probability()] to plot probabilities and quantiles calculated by `Pr()'.
## #'
## #' [hist.probability()] to plot histograms of the probability distributions calculated by `Pr()`.
## #'
## #' @examples
## #' ## Load the example `learnt` object calculated from the "penguins" dataset;
## #' ## variates: 'species' and 'bill_len'
## #' learnt <- learntExample
## #'
## #' ## Calculate the probability object for the three values of variate 'species',
## #' ## given values 43 and 44 of variate 'bill_len';
## #' ## this object contains probabilities, quantiles, and other information
## #' probs <- Pr(
## #'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
## #'   X = data.frame(bill_len = c(43, 44)),
## #'   learnt = learnt, parallel = 1
## #' )
## #'
## #' probs$values
## #'
## #' ## Subset by retaining the values 'Adelie' and 'Gentoo' for species,
## #' ## and 44 for bill length
## #' newprobs <- .prsubset(
## #'   probs,
## #'   subset = list(species = c('Adelie', 'Gentoo'), bill_len = 43)
## #' )
## #'
## #' newprobs$values
## #'
## #' ## Plot these conditional probabilities and their revisabilities
## #' plot(newprobs)
## #'
## #' hist(newprobs)
## #'
#' @keywords internal
.prsubset <- function(
    x,
    subset
){
    Ynames <- names(x$Y)
    Xnames <- names(x$X)
    subset <- as.list(subset)
    vrtnames <- names(subset)

    if(!all(vrtnames %in% c(Ynames, Xnames))){
        stop("probability object does not contain some of the given variates")
    }

    ## subset Y
    for(vrt in vrtnames[vrtnames %in% Ynames]){
        selvals <- x$Y[[vrt]] %in% subset[[vrt]]
        x$values <- x$values[selvals, , drop = FALSE]
        if(!is.null(x$values.MCaccuracy)){
            x$values.MCaccuracy <- x$values.MCaccuracy[selvals, , drop = FALSE]
        }
        if(!is.null(x$quantiles)){
            x$quantiles <- x$quantiles[selvals, , , drop = FALSE]
        }
        if(!is.null(x$quantiles.MCaccuracy)){
            x$quantiles.MCaccuracy <- x$quantiles.MCaccuracy[selvals, , , drop = FALSE]
        }
        if(!is.null(x$samples)){
            x$samples <- x$samples[selvals, , , drop = FALSE]
        }
        x$Y <- x$Y[selvals, , drop = FALSE]
    }

    ## subset X
    for(vrt in vrtnames[vrtnames %in% Xnames]){
        selvals <- x$X[[vrt]] %in% subset[[vrt]]
        x$values <- x$values[, selvals, drop = FALSE]
        if(!is.null(x$values.MCaccuracy)){
            x$values.MCaccuracy <- x$values.MCaccuracy[, selvals, drop = FALSE]
        }
        if(!is.null(x$quantiles)){
            x$quantiles <- x$quantiles[, selvals, , drop = FALSE]
        }
        if(!is.null(x$quantiles.MCaccuracy)){
            x$quantiles.MCaccuracy <- x$quantiles.MCaccuracy[, selvals, , drop = FALSE]
        }
        if(!is.null(x$samples)){
            x$samples <- x$samples[, selvals, , drop = FALSE]
        }
        x$X <- x$X[selvals, , drop = FALSE]
    }

    x
}



#' Format numbers respecting significant digits
#'
#' This is a combination of the [base::signif()] and [base::formatC()] functions, which appropriately rounds non-decimal digits, like `signif()` does, and appends trailing zeros as necessary, lik `formatC()` does.
#'
#' @param x numerical vector, matrix, or array
#' @param digits vector of positive integers: number of *significant* digits to be displayed
#'
#' @return A *character* vector, matrix, or array of the elements of `x`, appropriately rounded and truncated.
#' @keywords internal
.signifC <- function(x, digits = 2){
    mapply(FUN = function(xx, dd){
        dd <- min(dd, getOption('digits'))
        formatC(x = signif(x = xx, digits = dd),
            digits = dd, format = 'fg', flag = '#')
    }, x, digits)
}
