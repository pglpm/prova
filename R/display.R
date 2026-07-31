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
#'   - `'hx'` plots shaded histograms. Argument `x` must be a list of `breaks`, and `y` a list of `counts` or `densities`, for example produced by by [graphics::hist()].
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
#' @param alpha.f Numeric vector or list, default `1`: opacity of the line or contour colours, `0` being completely invisible and `1` completely opaque.
#' @param xjitter,yjitter Vector or list of logicals or `NA` (default): add [base::jitter()] to `x`- or `y`-values? Useful when plotting discrete variates. If `NA`, jitter is added if both `x` and `y` are of character (or factor) class.
#' @param fill Logical or `NA` (default). For histogram plots (`type = 'hx'` or `'hy'`), value `TRUE` means fill the histogram, and do not plot its contour; `FAlSE` means plot only its contour without filling; `NA` means plot contour and fill. For quantile plots (`type = 'qx'` or `'qy'`), value `TRUE` do not plot the bands' contours; `FAlSE` means plot only the contours without filling; `NA` plots a contour only when the quantile band has zero area (and would be invisible otherwise).
#' @param alpha.f.fill Numeric vector or list, default `0.25`: opacity of the filling colours, `0` being completely invisible and `1` completely opaque.
#' @param grid Logical, default `TRUE`: plot a light grid?
#' @param lwd.grid Numeric, default 1: width of grid lines.
#' @param col.grid Color of grid lines, default `'#00000022'`. Can be specified in any of the usual ways, see for instance [grDevices::col2rgb()].
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
#' ## Scatter plot of 'island' vs 'species' variates of the 'penguins' dataset;
#' ## note how jitter is automatically added:
#' pplot(x = penguins[, 'species'], y = penguins[, 'island'])
#'
#'
#' ## Scatter plot of 'bill_len' vs 'species':
#' pplot(x = penguins[, 'species'], y = penguins[, 'bill_len'])
#'
#' ## Scatter plot of 'bill_len' vs 'body_mass';
#' ## in this case the scatter-plot `type = 'p'` must be specified:
#' pplot(x = penguins[, 'body_mass'], y = penguins[, 'bill_len'], type = 'p')
#'
#' ## Plot y-values having different numbers of x-values
#' pplot(x = list(1:5, 6:7), y = list(5:1, 6:7))
#'
#' ## Specify only the minimum plotting range
#' xgrid <- seq(from = -2, to = 2, length.out = 65)
#' pplot(x = xgrid, y = dnorm(xgrid), ylim = c(0, NA))
#'
#' ## Draw a shaded histogram
#' histo <- hist(rnorm(1000), breaks = 'FD', plot = FALSE)
#' pplot(x = histo$breaks, y = histo$density, type = 'hx')
#'
#' @import grDevices
#' @import graphics
#'
#' @concept display
#' @export
pplot <- function(
    x = NULL, y = NULL,
    type = NA,
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    lend = par('lend'),
    pch = c(1, 2, 0, 5, 6, 3), #, 4,
    col = palette(),
    ## c( ## Tol's colour-blind-safe scheme
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    xlab = NA, ylab = NA,
    xlim = NULL, ylim = NULL,
    add = FALSE,
    xdomain = NULL, ydomain = NULL,
    alpha.f = 1,
    xjitter = NA,
    yjitter = NA,
    fill = NA,
    alpha.f.fill = 0.25,
    grid = TRUE,
    lwd.grid = NULL,
    col.grid = '#00000022',
    axes = FALSE,
    cex.main = 1,
    ...
){
    if(!is.list(x)){x <- list(x)}
    if(!is.list(y)){y <- list(y)}

    ## Elements: unlist, unfactor, other fixes
    for(aplot in seq_along(x)){
        if(is.list(x[[aplot]])){x[[aplot]] <- unlist(x[[aplot]],
            recursive = TRUE, use.names = TRUE)}
        if(is.factor(x[[aplot]])){x[[aplot]] <- as.character(x[[aplot]])}
        if(anyDuplicated(x[[aplot]]) && is.character(x[[aplot]])){
            if(is.na(xjitter[[aplot]])){ xjitter[[aplot]] <- TRUE }
            if(is.na(type[[aplot]])){ type[[aplot]] <- 'p' }
        }
    }
    for(aplot in seq_along(y)){
        if(is.list(y[[aplot]])){y[[aplot]] <- unlist(y[[aplot]],
            recursive = TRUE, use.names = TRUE)}
        if(is.factor(y[[aplot]])){y[[aplot]] <- as.character(y[[aplot]])}
        if(anyDuplicated(y[[aplot]]) && is.character(y[[aplot]])){
            if(is.na(yjitter[[aplot]])){ yjitter[[aplot]] <- TRUE }
            if(is.na(type[[aplot]])){ type[[aplot]] <- 'p' }
        }
    }

    if(!is.null(xdomain)){ xdomain <- unlist(xdomain) }
    if(!is.null(ydomain)){ ydomain <- unlist(ydomain) }

    ## Find NULL elements for special handling later
    xnull <- vapply(X = x, FUN = is.null, FUN.VALUE = FALSE, USE.NAMES = FALSE)
    ynull <- vapply(X = y, FUN = is.null, FUN.VALUE = FALSE, USE.NAMES = FALSE)

    ## Check consistency of x, y args; find ranges
    if(all(xnull)){
        xcha <- FALSE
        rgx <- c(Inf, -Inf)
    } else if(all(vapply(X = x[!xnull], FUN = is.numeric,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all x are numeric, find common min max
        xcha <- FALSE
        rgx <- unlist(x, recursive = FALSE, use.names = FALSE)
        rgx <- range(rgx[is.finite(rgx)])
    } else if(all(vapply(X = x[!xnull], FUN = is.character,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all x are character, find domain
        xcha <- TRUE
        if(is.null(xdomain)){
            xdomain <- unlist(x, recursive = FALSE, use.names = FALSE)
            xdomain <- unique(xdomain[!is.na(xdomain)])
        }
        rgx <- c(1, length(xdomain))
    } else {
        stop("Elements in 'x' must be all numeric or all character.")
    }

    if(all(ynull)){
        ycha <- FALSE
        rgy <- c(Inf, -Inf)
    } else if(all(vapply(X = y[!ynull], FUN = is.numeric,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all y are numeric, find common min max
        ycha <- FALSE
        rgy <- unlist(y, recursive = FALSE, use.names = FALSE)
        rgy <- range(rgy[is.finite(rgy)])
    } else if(all(vapply(X = y[!ynull], FUN = is.character,
        FUN.VALUE = FALSE, USE.NAMES = FALSE))){
        ## all y are character, find domain
        ycha <- TRUE
        if(is.null(ydomain)){
            ydomain <- unlist(y, recursive = FALSE, use.names = FALSE)
            ydomain <- unique(ydomain[!is.na(ydomain)])
        }
        rgy <- c(1, length(ydomain))
    } else {
        stop("Elements in 'y' must be all numeric or all character.")
    }

    ## Handle NULLs
    if(any(xnull)){
        temp <- lapply(
            X = y[ rep(x = seq_along(y), length.out = length(x))[xnull] ],
            FUN = function(xx){seq_len(NROW(xx))}
        )
        x[xnull] <- temp
        rgx[1] <- min(rgx[1], unlist(temp), na.rm = TRUE)
        rgx[2] <- max(rgx[2], unlist(temp), na.rm = TRUE)
        rm(temp)
    }
    if(any(ynull)){
        temp <- lapply(
            X = x[ rep(x = seq_along(x), length.out = length(y))[ynull] ],
            FUN = function(xx){seq_len(NROW(xx))}
        )
        y[ynull] <- temp
        rgy[1] <- min(rgy[1], unlist(temp), na.rm = TRUE)
        rgy[2] <- max(rgy[2], unlist(temp), na.rm = TRUE)
        rm(temp)
    }

    ## Other NAs
    type[is.na(type)] <- 'l'
    xjitter[is.na(xjitter)] <- FALSE
    yjitter[is.na(yjitter)] <- FALSE

    ## Plot ranges
    if(!isTRUE(is.finite(xlim[1]))){
        if(any(xjitter)){ rgx[1] <- rgx[1] - 1/3 }
        if(any(type == 'hy')){ rgx[1] <- min(rgx[1], 0) }
        xlim[1] <- min(rgx)
    }
    if(!isTRUE(is.finite(xlim[2]))){
        if(any(xjitter)){ rgx[2] <- rgx[2] + 1/3 }
        xlim[2] <- max(rgx)
    }

    if(!isTRUE(is.finite(ylim[1]))){
        if(any(yjitter)){ rgy[1] <- rgy[1] - 1/3 }
        if(any(type == 'hx')){ rgy[1] <- min(rgy[1], 0) }
        ylim[1] <- min(rgy)
    }
    if(!isTRUE(is.finite(ylim[2]))){
        if(any(yjitter)){ rgy[2] <- rgy[2] + 1/3 }
        ylim[2] <- max(rgy)
    }

    ## Parameters for q-type plots

    ## Function for preparing indices for q-type plots
    qindices <- function(groups, col1 = 1, col2 = 1){
        indices <- cumsum(groups$lengths)
        n <- length(indices)
        col1 <- indices[n] * (col1 - 1)
        col2 <- indices[n] * (col2 - 1)
        unlist(mapply(
            FUN = function(v, i1, i2){
                if(v){c(col1 + (i1:i2), col2 + (i2:i1))}else{NA}
            },
            groups$values,
            c(1, 1 + indices[-n]),
            indices,
            USE.NAMES = FALSE, SIMPLIFY = FALSE
        ))
    }

    ## First plot window
    graphics::matplot(x = NA, y = NA, type = 'n',
        xlab = xlab, ylab = ylab, xlim = xlim, ylim = ylim,
        cex.main = cex.main, add = add, axes = FALSE,
        ## xaxs = 'i', yaxs = 'i',
        ...)

### Plot the lists
    for(aplot in seq_len(max(length(x), length(y), na.rm = FALSE))){
        ## ## drop unneeded dimensions?
        ## thisx <- drop(x[[aplot]])
        ## thisy <- drop(y[[aplot]])
        thisx <- x[[(aplot - 1) %% length(x) + 1]]
        thisy <- y[[(aplot - 1) %% length(y) + 1]]

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

        thiscol <- col[[(aplot - 1) %% length(col) + 1]]
        thisalpha.f <- alpha.f[[(aplot - 1) %% length(alpha.f) + 1]]

        thisfill <- fill[[(aplot - 1) %% length(fill) + 1]]
        thisalpha.f.fill <-
            alpha.f.fill[[(aplot - 1) %% length(alpha.f.fill) + 1]]

        ## Check if jitter needed
        thisxjitter <- xjitter[[(aplot - 1) %% length(xjitter) + 1]]
        if((is.na(thisxjitter) && anyDuplicated(thisx)) || isTRUE(thisxjitter)){
            thisx <- jitter(thisx, factor = 5/3)
        }
        thisyjitter <- yjitter[[(aplot - 1) %% length(yjitter) + 1]]
        if((is.na(thisyjitter) && anyDuplicated(thisy)) || isTRUE(thisyjitter)){
            thisy <- jitter(thisy, factor = 5/3)
        }

        ## Plot
        ## checks for type = 'q'
        thistype <- type[[(aplot - 1) %% length(type) + 1]]

        if(thistype %in% c('hx', 'hy')){
            if(thistype == 'hx'){
                thisx <- rep(x = thisx, each = 4)
                thisx <- thisx[-c(1, length(thisx))]
                thisy <- c(0, rep(x = thisy, each = 4), 0)
            } else if(thistype == 'hy'){
                thisy <- rep(x = thisy, each = 4)
                thisy <- thisy[-c(1, length(thisy))]
                thisx <- c(0, rep(x = thisx, each = 4), 0)
            }

            if(is.na(thisfill) || thisfill){
                graphics::polygon(
                    x = thisx, y = thisy,
                    border = NA,
                    col = adjustcolor(thiscol, alpha.f = thisalpha.f.fill),
                    lwd = lwd[[(aplot - 1) %% length(lwd) + 1]],
                    density = NULL, xpd = TRUE, lty = 1)
            }
            if(is.na(thisfill) || !thisfill){ thistype <- 'l' }
        }

        if(!(thistype %in% c('qx', 'qy', 'hx', 'hy'))){

            ## Plot
            graphics::matplot(x = thisx, y = thisy,
                type = thistype,
                lty = lty[[(aplot - 1) %% length(lty) + 1]],
                lwd = lwd[[(aplot - 1) %% length(lwd) + 1]],
                lend = lend[[(aplot - 1) %% length(lend) + 1]],
                pch = pch[[(aplot - 1) %% length(pch) + 1]],
                col = adjustcolor(thiscol, alpha.f = thisalpha.f),
                add = TRUE, ...)

        }
        if(thistype %in% c('qx', 'qy')){

            if(thistype == 'qx'){
                if(is.null(dim(thisy))){ dim(thisy) <- c(1, length(thisy)) }
                nquant <- ncol(thisy)
                groups <- rle(!is.na(c(thisx)))

                ## quantiles of zero x-extension need a border
                if(is.na(thisfill)){
                    border <- rep.int(x = NA, times = length(thisx))
                    border[(groups$length[groups$values] == 1)] <-
                        adjustcolor(thiscol, alpha.f = thisalpha.f.fill)
                }

                for(ii in seq_len(ceiling(nquant / 2))){
                    graphics::polygon(
                        x = thisx[qindices(groups = groups,
                            col1 = 1, col2 = 1)],
                        y = thisy[qindices(groups = groups,
                            col1 = ii, col2 = nquant + 1 - ii)],
                        ## x = c(thisx[,(ii - 1) %% temp + 1],
                        ##     rev(thisx[,(ii - 1) %% temp + 1])),
                        ## y = c(thisy[, ii], rev(thisy[, nquant + 1 - ii])),
                        border = border,
                        col = adjustcolor(thiscol, alpha.f = thisalpha.f.fill),
                        lwd = lwd[[(aplot - 1) %% length(lwd) + 1]],
                        density = NULL, xpd = TRUE, lty = 1)
                }
            } else {
                if(is.null(dim(thisx))){ dim(thisx) <- c(1, length(thisx)) }
                nquant <- ncol(thisx)
                groups <- rle(!is.na(c(thisy)))

                ## quantiles of zero y-extension need a border
                if(is.na(thisfill)){
                    border <- rep.int(x = NA, times = length(thisy))
                    border[(groups$length[groups$values] == 1)] <-
                        adjustcolor(thiscol, alpha.f = thisalpha.f.fill)
                }

                for(ii in seq_len(ceiling(nquant / 2))){
                    graphics::polygon(
                        y = thisy[qindices(groups = groups,
                            col1 = 1, col2 = 1)],
                        x = thisx[qindices(groups = groups,
                            col1 = ii, col2 = nquant + 1 - ii)],
                        ## x = c(thisx[,(ii - 1) %% temp + 1],
                        ##     rev(thisx[,(ii - 1) %% temp + 1])),
                        ## y = c(thisy[, ii], rev(thisy[, nquant + 1 - ii])),
                        border = border,
                        col = adjustcolor(thiscol, alpha.f = thisalpha.f.fill),
                        lwd = lwd[[(aplot - 1) %% length(lwd) + 1]],
                        density = NULL, xpd = TRUE, lty = 1)
                }
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
#' @param type `NULL` (default) or character vector or indicating the type of plot for the main probability distribution; see [base::plot()]. The default `NULL` value uses type `'l'` (lines) for continuous variates, and `'b'` (points and lines) for discrete variates.
#' @param lty Analogous to argument `lty` (line style) in [graphics::matplot()], used for the main probability distributions.
#' @param lwd Analogous to argument `lwd` (line width) in [graphics::matplot()], used for the main probability distributions.
#' @param alpha.f Numeric, default `1`: opacity of the colours of lines or markers, `0` being completely invisible and `1` completely opaque.
#' @param nsamples.spread Integer, default 360: number of samples of long-run frequencies to display.
#' @param type.spread `NULL` (default) or character vector or indicating the type of plot for the long-run-frequency samples; see. The default `NULL` value uses type `'l'` (lines) for continuous variates, and `'b'` (points and lines) for discrete variates.
#' @param lty.spread Same as parameter `lty` (line style), but for the line type of the long-run-frequency samples.
#' @param lwd.spread Same as parameter `lwd` (line width), but for the line type of the long-run-frequency samples.
#' @param alpha.f.spread Numeric or `NULL` (default): opacity of the quantile bands or of the long-run-frequency samples, similar to `alpha.f`. `NULL` means `0.25` if `spread = 'quantiles'`; and an appropriate value if `spread = 'samples'`,dependent on the number of samples (more samples, less opacity).
#' @param pch,col,xlab,ylab,main,xlim,ylim,grid,axes,add,lwd.grid,col.grid see analogous arguments in [graphics::plot.default()] and [graphics::matplot()].
#' @param ... Other parameters to be passed to [pplot()].
#'
#' @return `NULL`, [invisibly][base::invisible()]; produces a plot, see [graphics::matplot()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [hist.probability()] to plot the revisability of the probabilities as a distribution.
#'
#' [pplot()] (on which `plot.probability()` is based) for more general plots.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## create a grid of values for variate "bill length",
#' ## based on the information in the dataset and metadata:
#' valuesBill <- vrtgrid(vrt = 'bill_len', K = K)
#'
#' ## calculate the probabilities and quantiles
#' probs <- Pr(Y = valuesBill, K = K)
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
    legend = 'topright',
    type = NULL,
    lty = c(1, 2, 4, 3, 6, 5),
    pch = c(1, 2, 0, 5, 6, 3), #, 4,
    lwd = 2,
    col = palette(),
    ##     c( ## Tol's colour-blind-safe scheme, or palette()
    ##     '#4477AA',
    ##     '#EE6677',
    ##     '#228833',
    ##     '#CCBB44',
    ##     '#66CCEE',
    ##     '#AA3377' #, '#BBBBBB'
    ## ),
    xlab = NULL, ylab = NULL,
    xlim = NULL, ylim = c(0, NA),
    add = FALSE,
    alpha.f = 1,
    grid = TRUE,
    lwd.grid = NULL,
    col.grid = '#00000022',
    axes = FALSE,
    ylab2 = NULL,
    main = NULL,
    type.spread = NULL,
    lty.spread = c(1, 2, 4, 3, 6, 5),
    lwd.spread = NULL,
    alpha.f.spread = NULL,
    nsamples.spread = 360,
    ...
){
    ## Replace object x keeping only values given in 'subset'
    if(!is.null(subset)){
        x <- .prsubset(x, subset = subset)
    }

    ## If there's only one probability it doesn't make sense to plot anything:
    ## print() the result instead
    if(length(x[['value']]) == 1){
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
            warning("Requested 'spread' not available in this 'probability' object.")
            spread <- 'none'
        }
    }
    ## spread flags
    qspread <- ('quantiles' %in% spread)
    sspread <- ('samples' %in% spread)

    Ylen <- nrow(x[['value']])
    Xlen <- ncol(x[['value']])

    ## Handle the case of missing Y and X items in 'x'
    if(is.null(x$Y)){
        x$Y <- data.frame(Y = paste0('Y', seq_len(Ylen)))
        if(Xlen > 1){
            x$X <- data.frame(X = paste0('X', seq_len(Xlen)))
        }
    }

    ## Check for singular-probability values
    isdensity <- any(x$density > 0)

    ## If 'PvsY' is NULL, then guess that the longest between Y and X
    ## is meant to be abscissa
    if(is.null(PvsY)){ PvsY <- (Ylen >= Xlen) }

    if(isTRUE(PvsY)){
        ## Y is x-axis, one plot for each X
        vals <- x$Y
        lgnd <- x$X
        tempxlab <- 'Y'
        nplots <- Xlen
        pdeltas <- (x$density < max(x$density))
        poks <- !pdeltas
        pvsyi <- 2
    } else {
        ## X is x-axis, one plot for each Y
        vals <- x$X
        lgnd <- x$Y
        tempxlab <- 'X'
        nplots <- Ylen
        ## It's unusual to plot probabilities of a continous variate against X
        pdeltas <- FALSE
        pvsyi <- 1
    }
    npdeltas <- any(!pdeltas)
    ypdeltas <- any(pdeltas)
    ## Special indices to use for q-plots
    qnpds <- !pdeltas
    qnpds[!qnpds] <- NA
    qypds <- pdeltas
    qypds[!qypds] <- NA

    ## If the abscissa has more than one variate,
    ## then it's tricky to understand which of these we must plot against.
    ## Heuristic: if there's one variate with as many unique elements as vals,
    ## then use that one. Otherwise use a generic 'Y...'
    if(ncol(vals) == 1){
        tempxlab <- colnames(vals)
        vals <- unlist(vals)
    } else {
        uniquevrts <- apply(vals, 2, function(xx){length(unique(xx))})
        toselect <- which(uniquevrts == nrow(vals))[1]
        if(is.na(toselect)){
            vals <- seq_len(nrow(vals))
        } else {
            tempxlab <- colnames(vals)[toselect]
            vals <- vals[, toselect]
        }
    }

    ## Different denominations if there are singular-probability points
    if(ypdeltas){
        if(is.null(ylab2)){
            ylab2 <- paste0('probability',
                if(max(x$density[-which.max(x$density)]) == 0){' density'},
                ' at singular points')
        }
        oldpar <- par(mar = par('mar') + c(0, 0, 0, 1.5))
        on.exit(par(oldpar))
    }

    ## Rename the revisability object so as to avoid if-else below
    if(qspread){
        mainpercentiles <- c(5.5, 94.5) # By default we choose an 89% band
        ## if we are plotting more than one curve, keep only the 89% band
        temp <- dimnames(x[['quantiles']])[[3]]
        qnames <- as.numeric(sub('%', '', temp))
        if(Xlen > 1 && Ylen > 1){
            ispread <- sapply(mainpercentiles,
                function(xx){which.min(abs(qnames - xx))})
        } else {
            ispread <- TRUE
        }
        qnames <- qnames[ispread]
        if(is.null(alpha.f.spread)){alpha.f.spread <- 0.25}

    } else if(sspread){
        temp <- dim(x[['samples']])[3]
        nsamples.spread <- min(nsamples.spread, temp)
        ispread <- round(seq.int(from = 1, to = temp,
            length.out = nsamples.spread))
        if(is.null(alpha.f.spread)){alpha.f.spread <- 1/ceiling(sqrt(temp))}
        ## if(is.null(alpha.f.spread)){alpha.f.spread <- 1/10}
    }

    ## y-range
    if(npdeltas){
        pmax <- max(x[['value']][!pdeltas, ], na.rm = TRUE)
    } else {
        pmax <- max(x[['value']][pdeltas, ], na.rm = TRUE)
    }
    if(qspread){
        if(npdeltas){
            pmax <- max(pmax, x[[spread]][!pdeltas, , ], na.rm = TRUE)
        } else {
            pmax <- max(pmax, x[[spread]][pdeltas, , ], na.rm = TRUE)
        }
    } else if(sspread){
        ## Some samples can have very high peaks; choose those within 94.5%
        pmax <- max(pmax, apply(
            X = if(npdeltas){
                x[[spread]][!pdeltas, , , drop = FALSE]
            } else {
                x[[spread]][pdeltas, , , drop = FALSE]
            },
            MARGIN = c(1, 2), FUN = quantile,
            probs = 0.945, na.rm = TRUE, names = FALSE, type = 6
        ))
    }

    if(!is.finite(ylim[2])){ ylim[2] <- pmax }
    if(!is.finite(ylim[1])){ ylim[1] <- 0 }

    ## compute max probability of singular points, if any,
    ## and find conversion scale
    if(ypdeltas){
        maxpdelta <- max(x[['value']][pdeltas, ],
            x[['quantiles']][pdeltas, , ],
            if(sspread){apply(
                X = x[[spread]][pdeltas, , , drop = FALSE],
                MARGIN = c(1, 2), FUN = quantile,
                probs = 0.945, na.rm = TRUE, names = FALSE, type = 6
            )},
            na.rm = TRUE)
        temp <-  0.04 * (ylim[2] - ylim[1])
        pticks <- axisTicks(usr = ylim + c(-temp, temp), log = FALSE)
        pdivs <- length(pticks) - 1
        ploc <- min(pticks)
        pscale <- signif(x = maxpdelta / pdivs, digits = 1)
        pscale <- (max(pticks) - ploc) / (pscale * pdivs)
        ## ceiling(pscale * 10^(-floor(log10(pscale)) + 1)) *
        ##     10^(floor(log10(pscale)) - 1) * pdivs
    }

    ## Prepare axes labels and title
    if(is.null(xlab)){xlab <- tempxlab}
    if(is.null(main)){
        tails <- list()
        tails[c(names(x$Y), names(x$X))] <- ''
        tails[names(x$tails)] <- x$tails
        main <- paste0('P(',
            paste0(names(x$Y), tails[names(x$Y)], collapse = ', '),
            ' | ',
            if(!is.null(x$X)){ paste0(
                paste0(names(x$X), tails[names(x$X)], collapse = ', '),
            ', ')},
            x$K, ')')
        if(qspread){
            main <- paste0(main, '\nquantiles: ',
                paste0(round(qnames, 1), '%', collapse = ', '))
        } else if(sspread){
            main <- paste0(main, '\n', nsamples.spread, ' samples')
        }
    }
    if(is.null(ylab)){
        ylab <- paste0('probability', if(isdensity){' density'})
    }

    ## Function to create repetitions of args
    largs <- function(qn, qy, sn, sy, vn, vy){c(
        rbind(
            rep(qn, length.out = qspread * npdeltas * nplots),
            rep(qy, length.out = qspread * ypdeltas * nplots)
        ),
        rbind(
            rep(sn, length.out = sspread * npdeltas * nplots),
            rep(sy, length.out = sspread * ypdeltas * nplots)
        ),
        rbind(
            rep(vn, length.out = npdeltas * nplots),
            rep(vy, length.out = ypdeltas * nplots)
        )
    )}

    ## Special graphical-parameter values
    if(is.null(type)){type <- if(is.character(vals)){'b'} else {'l'}}
    if(is.null(type.spread)){type.spread <- if(is.character(vals)){'b'} else {'l'}}
    if(is.null(lwd.spread)){ lwd.spread <- if(qspread){15}else{1} }
    ## 'pch' needs to be list to mix characters and numbers
    pchlist <- as.list(largs(pch, NA, pch, -1, pch, pch))
    pchlist[pchlist == -1] <- '-'

    ## Plot
    pplot(
        x = c(
            if(npdeltas){ list(vals[qnpds]) },
            if(ypdeltas){ list(vals[qypds]) }
        ),
        y = c(
            if(qspread || sspread){rbind(
                if(npdeltas){
                    apply(X = x[[spread]][qnpds, , ispread, drop = FALSE],
                        MARGIN = pvsyi, FUN = identity, simplify = FALSE)
                },
                if(ypdeltas){
                    apply(X = pscale * x[[spread]][qypds, , ispread, drop = FALSE] + ploc,
                        MARGIN = pvsyi, FUN = identity, simplify = FALSE)
                }
            )},
            rbind(
                if(npdeltas){
                    apply(X = x[['value']][qnpds, , drop = FALSE],
                        MARGIN = pvsyi, FUN = identity, simplify = FALSE)
                },
                if(ypdeltas){
                    apply(X =  pscale * x[['value']][qypds, , drop = FALSE] + ploc,
                        MARGIN = pvsyi, FUN = identity, simplify = FALSE)
                }
            )
        ),
        type = largs('qx', 'qx', type.spread, 'p', type, 'p'),
        lty = largs(lty.spread, lty.spread, lty.spread, lty.spread, lty, lty),
        lwd = largs(1, lwd.spread, lwd.spread, lwd.spread, lwd, lwd),
        pch = pchlist,
        col = largs(col, col, col, col, col, col),
        alpha.f = largs(alpha.f.spread, alpha.f.spread,
            alpha.f.spread, alpha.f.spread, alpha.f, alpha.f),
        fill = NA,
        xlab = xlab,
        ylab = ylab,
        xlim = xlim,
        ylim = ylim,
        main = main,
        grid = grid,
        lwd.grid = lwd.grid,
        col.grid = col.grid,
        axes = axes,
        add = add,
        ...
    )

    ## add axis for singular probability values
    pticks <- axTicks(side = 4)
    if(ypdeltas){
        graphics::axis(side = 4, at = pticks, labels = (pticks - ploc) / pscale,
            tick = !grid, col = 'black', lwd = 1, lty = 1)
        mtext(ylab2, side = 4, line = 2.25)
    }

    ## Plot legends
    if(!is.null(lgnd)){
        ##  && is.character(legend) &&
        ## (legend %in%
        ##      c("bottomright", "bottom", "bottomleft", "left", "topleft",
        ##          "top", "topright", "right", "center"))
        tails <- list()
        tails[names(lgnd)] <- '='
        tails[names(x$tails)] <- x$tails
        graphics::legend(x = legend,
            legend = apply(lgnd, 1, function(xx){
                nxx <- names(xx)
                paste0(paste0(nxx, ' ', tails[nxx], ' ', xx),
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
#' The `hist()` method for a "probability" object is a utility to visualize this kind of revisability, in the form of a distribution. This distribution is represented by a histogram formed from samples of revised proobabilities (or long-run frequencies). The bin size is chosen according to the Monte Carlo accuracy.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param subset Named list or named vector: which variate values to display. For the variates corresponding to the names in this list, only the vector of values corresponding to that variate is displayed.
#' @param breaks as in function [graphics::hist()], or `NULL` (default). Value `NULL` determines bin width from the Monte Carlo accuracy (roughly speaking, each bin spans two standard deviations).
#' @param alpha.f.fill Numeric, default `0.125`: opacity of the histogram filling, `0` being completely invisible and `1` completely opaque.
#' @param legend One of the values `"bottomright"`, `"bottom"`, `"bottomleft"`, `"left"`, `"topleft"`, `"top"`, `"topright"`, `"right"`, `"center"` (see [graphics::legend()]): plot a legend at that position. A value `FALSE` or any other does not plot any legend. Default `"top"`.
#' @param showmean Logical, default `TRUE`: show the means of the probability distributions? The means correspond to the probabilities about the next observed unit.
#' @param lty,lwd,col,alpha.f,xlab,ylab,xlim,ylim,main,grid,axes,add see analogous arguments in [graphics::matplot()]
#' @param ... Other parameters to be passed to [pplot()].
#'
#' @return [Invisibly][base::invisible()], an object of class ["histogram"][graphics::hist()].
#'
#' @seealso
#' [Pr()] to calculate posterior probabilities and quantiles.
#'
#' [plot.probability()] to plot the posterior probabilities.
#'
#' [pplot()] (on which `hist.probability()` is based) for more general plots.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## calculate the probability, and its revisability,
#' ## for the value 'Adelie' of the "species" variate
#' probs <- Pr(Y = data.frame(species = 'Adelie'), K = K)
#' probs$value
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
    legend = 'topright',
    lty = c(1, 2, 4, 3, 6, 5),
    lwd = 2,
    col = palette(),
    alpha.f = 1,
    alpha.f.fill = 0.125,
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
    Ylen <- nrow(x[['value']])
    Xlen <- ncol(x[['value']])

    ## Precompute histograms, to determine maximum y-value
    xlist <- densitylist <- list()
    i <- 0L
    for(xx in seq_len(Xlen)){ for(yy in seq_len(Ylen)){
        i <- i + 1L
        ff <- x[['samples']][yy, xx, ]
        if(is.null(breaks)){
            rg <- range(ff, na.rm = TRUE)
            if(rg[2] == rg[1]){rg <- c(0, 1)}
            if(!is.null(x[['quantiles.acc']])){
                wd <- 4 * max(x[['quantiles.acc']][yy, xx, ])
            } else if(!is.null(x[['samples']])){
                wd <- 4 * max(sapply(X = c(0.055, 0.945),
                    FUN = function(aquant){
                        temp <- .funMCEQ(x = x[['samples']][yy, xx,],
                            prob = aquant,
                            Qpair = pnorm(c(-1, 1)))
                        (temp[2, ] - temp[1, ]) / 2},
                    USE.NAMES = FALSE, simplify = TRUE))
            } else {
                wd <- (rg[2] - rg[1]) / ceiling(sqrt(length(ff))/2)
            }
            n <- (rg[2] - rg[1]) / wd
                ## n <- (rg[2] - rg[1]) / (2 * qnorm(0.945) * exp(mean(log(
                ##     x[['quantiles.acc']][yy, xx,]
                ## ), na.rm = TRUE)))
            ## n <- nclass.FD(ff)
            ## n <- ceiling(sqrt(length(ff))/2)
            ibreaks <- seq(rg[1], rg[2], length.out = n + 1)
        } else {
            ibreaks <- breaks
        }
        hd <- graphics::hist(x = ff, breaks = ibreaks, plot = FALSE)
        xlist[[i]] <- hd$breaks
        densitylist[[i]] <- hd$density
    } }
    nplots <- length(xlist)

    if(is.null(xlab)){
        xlab <- 'long-run relative frequency'
    }
    if(is.null(ylab)){ylab <- 'probability density'}
    if(isFALSE(alpha.f.fill) || !is.numeric(alpha.f.fill)){alpha.f.fill <- 0}

    if(missing(xlim)){xlim <- range(unlist(xlist))}
    if(is.na(ylim)[2]){ylim[2] <- max(unlist(densitylist))}

    pplot(x = xlist,
        y = densitylist,
        type = 'hx',
        lty = lty,
        lwd = lwd,
        col = col,
        xlab = xlab, ylab = ylab,
        xlim = xlim, ylim = ylim,
        add = add,
        alpha.f = alpha.f,
        xjitter = FALSE, yjitter = FALSE,
        fill = NA,
        alpha.f.fill = alpha.f.fill,
        grid = grid,
        axes = axes,
        main = main,
        ...
    )

    if(isTRUE(showmean)){
        i <- 0L
        for(xx in seq_len(Xlen)){ for(yy in seq_len(Ylen)){
            i <- i + 1L
            graphics::abline(v = x[['value']][yy, xx],
                col = adjustcolor(col[(i - 1) %% length(col) + 1],
                    alpha.f * 0.75),
                lty = lty[(i - 1) %% length(lty) + 1],
                lwd = lwd * 0.75)
        }}
    }

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


#' Plot the revisability of an object of class "mi" as a histogram
#'
#' @description
#' The mutual information calculated with the [mutualinfo()] function, and outputted as a "mi" object, has an associated "revisability" that comes from the finite size of the data sample. A much larger sample might reveal a different value of mutual information.
#'
#' The `hist()` method for a "mi" object is a utility to visualize this kind of revisability, in the form of a distribution: it shows how the mutual information could change, if we collected a much larger (infinite) data sample, and how likely such change would be. The distribution is represented by a histogram formed from samples of revised mutual information. The bin size is chosen according to the Monte Carlo accuracy.
#'
#' @param x Object of class "mi", obtained with [mutualinfo()].
#' @param breaks as in function [graphics::hist()], or `NULL` (default). Value `NULL` determines the bin width from the Monte Carlo accuracy (roughly speaking, each bin spans two standard deviations).
#' @param alpha.f.fill Numeric, default 0.125: opacity of the histogram filling. `0` means no filling.
#' @param showvalue Logical, default `TRUE`: show the mutual information obtained from the current data sample?
#' @param lty,lwd,col,alpha.f,xlab,ylab,xlim,ylim,main,grid,axes,add see analogous arguments in [graphics::matplot()]
#' @param ... Other parameters to be passed to [pplot()].
#'
#' @return [Invisibly][base::invisible()], an object of class ["histogram"][graphics::hist()].
#'
#' @seealso
#' [mutualinfo()] to calculate mutual information and its revisability.
#'
#' [print.mi()] ] to plot mutual information and quantiles calculated by `mutualinfo()`
#'
#' [pplot()] (on which `hist.mi()` is based) for more general plots.
#'
#' @examples
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## calculate the mutual information and its revisability
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len', K = K, nv = 2)
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
    alpha.f.fill = 0.125,
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

    ## Precompute histogram
    ff <- x[['samples']]
    if(is.null(breaks)){
        rg <- range(ff, na.rm = TRUE)
        if(rg[2] == rg[1]){rg <- c(0, 1)}
        if(!is.null(x[['quantiles.acc']])){
            wd <- 4 * max(x[['quantiles.acc']])
        } else if(!is.null(x[['samples']])){
            wd <- 4 * max(sapply(X = c(0.055, 0.945),
                FUN = function(aquant){
                    temp <- .funMCEQ(x = x[['samples']],
                        prob = aquant,
                        Qpair = pnorm(c(-1, 1)))
                    (temp[2, ] - temp[1, ]) / 2},
                USE.NAMES = FALSE, simplify = TRUE))
        } else {
            wd <- (rg[2] - rg[1]) / ceiling(sqrt(length(ff))/2)
        }
        n <- (rg[2] - rg[1]) / wd
        ibreaks <- seq(rg[1], rg[2], length.out = n + 1)
    } else {
        ibreaks <- breaks
    }
    hd <- graphics::hist(x = ff, breaks = ibreaks, plot = FALSE)
    xlist <- hd$breaks
    densitylist <- hd$density

    if(is.null(xlab)){
        xlab <- paste0('long-run mutual information / ', x$unit)
    }

    if(is.null(ylab)){ylab <- 'probability density'}
    if(isFALSE(alpha.f.fill) || !is.numeric(alpha.f.fill)){alpha.f.fill <- 0}
    if(missing(xlim)){xlim <- range(xlist)}
    if(is.null(main)){
        tails <- list()
        tails[names(x$X)] <- ''
        tails[names(x$tails)] <- x$tails
        main <- paste0('long-run MI(',
            paste0(x$Y1names, collapse = ', '),
            ' : ',
            paste0(x$Y2names, collapse = ', '),
            ' | ',
            if(!is.null(x$X)){ paste0(
                paste0(names(x$X), tails[names(x$X)], collapse = ', '),
            ', ')},
            x$K, ')')
    }

    nplots <- 1

    pplot(x = xlist,
        y = densitylist,
        type = 'hx',
        lty = rep(lty, length.out = nplots),
        lwd = rep(lwd, length.out = nplots),
        col = rep(col, length.out = nplots),
        xlab = xlab, ylab = ylab,
        xlim = xlim, ylim = ylim,
        add = add,
        alpha.f = alpha.f,
        xjitter = FALSE, yjitter = FALSE,
        fill = NA,
        alpha.f.fill = alpha.f.fill,
        grid = grid,
        axes = axes,
        main = main,
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



#' Print an object of class "probability"
#'
#' @description
#' This [base::print()] method is a utility to display selected elements of a "probability" object obtained with [Pr()]; typically its posterior probabilies (element `'value'`) and their revisabilities (element `'quantiles'`). If the `Y` or `X` variates are joint variates, this method also allow to display only selected values of them. Singular probabilities, such as the probability of a censored value for a continuous variate, are indicated with an asterisk `*`.
#'
#' @param x Object of class "probability", obtained with [Pr()].
#' @param elements character or integer vector, or `NULL` (default): elements of the "probability" object to display. The syntax is the same as with [` [ `][base::Extract]. If `NULL`, the elements `'value'` and `'quantiles'` are displayed together in a special way.
#' @param subset Named list or named vector: which variate values to display. For the variates corresponding to the names in this list, only the vector of values corresponding to that variate is displayed.
#' @param digits positive integer or `NULL` or `TRUE` (default): minimal number of significant digits, see [base::print.default()]. If value is `TRUE`, then the significant digits for elements `'value'` and `'quantiles'` are determined from their respective `'value.acc'` and `'quantiles.acc'` elements of the "probability" object (see [Pr()]), according to the rules of the *Guide to the expression of Uncertainty in Measurement*, keeping as many digits as given in parameter `edigits`; whereas `'samples'` elements uses `edigits` significant digits.
#' @param edigits positive integer, default 2: number of significant digits for elements `'value.acc'` and `'quantiles.acc'`, if `digits = TRUE`.
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
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## Calculate the 3 x 2 probabilities for the 3 species
#' ## given bill-lengths of 43 mm and 44 mm
#'
#' Y <- data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo'))
#' X <- data.frame(bill_len = c(43, 44))
#'
#' probs <- Pr(Y = Y, X = X, K = K)
#'
#' ## display the values and revisabilities of these probabilities
#' print(probs)
#'
#' ## diplay 'value' only, and only for the species value 'Gentoo'
#' print(probs, elements = 'value', subset = list(species = 'Gentoo'))
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

    vmca <- x[['value.acc']]
    if(is.null(vmca)){# output is from qPr()
        hasvmca <- FALSE
        vmca <- 1e-15
    } else {
        hasvmca <- TRUE
    }
    qmca <- x[['quantiles.acc']]
    if(is.null(qmca)){# output is from qPr()
        qmca <- 1e-15
    }

    density <- x[['density']]
    if(is.null(density)){# output is from qPr()
        density <- 0
        oname <- 'quantile'
    } else {
        oname <- 'probability'
    }
    if(isTRUE(digits) && is.null(elements)){
        vdigits <- edigits - 1 + ceiling(log10(x[['value']])) -
            floor(log10(vmca))
        adigits <- rep.int(x = edigits, times = length(vmca))
        if('quantiles' %in% names(x)){
            qdigits <- edigits - 1 + ceiling(log10(x[['quantiles']])) -
                floor(log10(qmca))
        } else {qdigits <- NULL}
    } else if(is.null(elements)){
            vdigits <- adigits <- qdigits <- digits
    } else if(!is.null(elements)){
        digits <- edigits
    }

    if(is.null(elements)){
        totake <- c('value', if(hasvmca){'value.acc'}, 'quantiles')
        ## rearrange and combine values and quantiles in a special way
        temp <- aperm(a = array(data = .signifC(
            x = unname(unlist(x[totake])),
            digits = c(vdigits, if(hasvmca){adigits}, qdigits) ),
            dim = c(dim(x[['value']]), 1 + hasvmca +
            (if(is.null(x[['quantiles']])){0}else{dim(x[['quantiles']])[3]})),
            dimnames = c(dimnames(x[['value']]),
                setNames(object = list(c('value', if(hasvmca){'+/-'},
                    if(!is.null(x[['quantiles']])){
                        paste0('Q', dimnames(x[['quantiles']])[[3]])
                    }
                )), nm = paste0(oname, if(any(density > 0)){' density'}))
                )),
            perm = c(1,3,2))
        temp2 <- dimnames(temp)[[1]][density < max(density)]
        dimnames(temp)[[1]][density < max(density)] <-
            paste0(temp2, '*')

        if(is.null(x$X)){temp <- temp[,,]}

        print(x = noquote(temp), ...)

    } else {
        print(x = x[elements], digits = digits, ...)
    }
    invisible(x)
}



#' Print an object of class "mi" (mutual information)
#'
#' @description
#' This [base::print()] method is a utility to display value and revisability of an "mi" object obtained with [mutualinfo()].
#'
#' @param x Object of class "mi", obtained with [mutualinfo()].
#' @param digits positive integer or `NULL` or `TRUE` (default): minimal number of significant digits, see [base::print.default()]. If value is `TRUE`, then the significant digits for element `'value'` are determined from is respective `'value.acc'`  (see [mutualinfo()]), according to the rules of the *Guide to the expression of Uncertainty in Measurement*, keeping as many digits as given in parameter `edigits`; whereas `'quantiles'` elements uses `edigits` significant digits.
#' @param edigits positive integer, default 2: number of significant digits for element `'value'` and `'quantiles'`, if `digits = TRUE`.
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
#' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
#' ## variates: 'species' and 'bill_len'
#' K <- Kexample
#'
#' ## Calculate the mutual information between variates 'species' and 'bill_len'
#' MI <- mutualinfo(Y1names = 'species', Y2names = 'bill_len', K = K)
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
    elements = NULL,
    unit = NULL,
    digits = TRUE,
    edigits = 2,
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

    vmca <- x[['value.acc']]
    if(is.null(vmca)){# output is from qPr()
        hasvmca <- FALSE
        vmca <- 1e-15
    } else {
        hasvmca <- TRUE
    }
    qmca <- x[['quantiles.acc']]
    if(is.null(qmca)){# output is from qPr()
        qmca <- 1e-15
    }

    oname <- paste0('MI  ',
        paste0(x[['Y1names']], collapse=','), ' : ',
        paste0(x[['Y2names']], collapse = ','))

    if(isTRUE(digits) && is.null(elements)){
        vdigits <- edigits - 1 + ceiling(log10(x[['value']])) -
            floor(log10(vmca))
        adigits <- rep.int(x = edigits, times = length(vmca))
        if('quantiles' %in% names(x)){
            qdigits <- edigits - 1 + ceiling(log10(x[['quantiles']])) -
                floor(log10(qmca))
        } else {qdigits <- NULL}
    } else if(is.null(elements)){
            vdigits <- adigits <- qdigits <- digits
    } else if(!is.null(elements)){
        digits <- edigits
    }

    if(is.null(elements)){
        totake <- c('value', if(hasvmca){'value.acc'}, 'quantiles')
        ## rearrange and combine values and quantiles in a special way
        temp <- array(data = .signifC(
            x = unname(unlist(x[totake])),
            digits = c(vdigits, if(hasvmca){adigits}, qdigits) ),
            dim = c(dim(x[['value']]), 1 + hasvmca +
            (if(is.null(x[['quantiles']])){0}else{dim(x[['quantiles']])[2]})),
            dimnames = c(dimnames(x[['value']]),
                setNames(object = list(c(paste0('value/', unit), if(hasvmca){'+/-'},
                    if(!is.null(x[['quantiles']])){
                        paste0('Q', dimnames(x[['quantiles']])[[2]])
                    }
                )), nm = oname)
            ))

        if(is.null(x$X)){temp <- temp[,]}

        print(x = noquote(temp), ...)

    } else {
        print(x = x[elements], digits = digits, ...)
    }
    invisible(x)
}


## .old.print.mi <- function(
##     x,
##     digits = TRUE,
##     edigits = 2,
##     unit = NULL,
##     ...
## ){
## 
##     xunit <- x[['unit']]
##     if(is.null(unit) || unit == xunit){
##         unit <- xunit
##         lbase <- 1
##     } else {
##         ## Consistency checks
##         if (unit == 'Sh') {
##             lbase <- log(2)
##         } else if (unit == 'Hart') {
##             lbase <- log(10)
##         } else if (unit == 'nat') {
##             lbase <- 1
##         } else if (is.numeric(unit) && unit > 0) {
##             lbase <- log(unit)
##         } else {
##             stop("unit must be 'Sh', 'Hart', 'nat', or a positive real")
##         }
## 
##         ## Convert symbol in x-object to log
##         if (xunit == 'Sh') {
##             xlbase <- log(2)
##         } else if (xunit == 'Hart') {
##             xlbase <- log(10)
##         } else if (xunit == 'nat') {
##             xlbase <- 1
##         } else {
##             xlbase <- log(xunit)
##         }
## 
##         lbase <- lbase / xlbase
##     }
## 
##     xvalue <- x[['value']] / lbase
##     xquants <- x[['quantiles']] / lbase
##     xacc <- x[['value.acc']] / lbase
##     qacc <- x[['quantiles.acc']] / lbase
## 
##     if(isTRUE(digits)){
##         vdigits <- edigits - 1 + ceiling(log10(xvalue)) -
##             floor(log10(xacc))
##         adigits <- edigits
##         qdigits <- edigits - 1 + ceiling(log10(xquants)) -
##             floor(log10(qacc))
##     } else {
##         vdigits <- adigits <- qdigits <- digits
##     }
## 
##     temp <- .signifC(x = c(xvalue, xquants),
##         digits = c(vdigits, qdigits))
##     names(temp) <- c(paste0('value/', unit), paste0('Q', names(xquants)))
##     print(x = noquote(temp), ...)
## }



#' Print summary of a "Knowledge" object
#'
#' @description
#' This [base::print()] method is a utility to display a summary of a "Knowledge" object outputted by [learn()], internally using [utils::str()]. It also display a summary if [learn()]'s value is only the path to the directory of the rds file containing the "Knowledge" object itself (see argument `valueisK =` in [learn()]), by internally retrieving the object. If you want to have a summary of a "K" object in a given directory or rds file, you can explicitly call `print.K(<file path>)`.
#'
#' @param x Object of class "K", output of [learn()].
#' @param ... Other parameters to be passed to [utils::str()].
#'
#' @return Its `x` argument, [invisibly][base::invisible()]; see [base::print()].
#'
#' @seealso
#' [learn()], which generates a "Knowledge" object.
#'
#' [Kexample] an example "K" object included with **Prova**.
#'
#' @examples
#' ## Display a summary of the example "Knowledge" object calculated from the "penguins" dataset
#' print(Kexample)
#'
#' @import utils
#'
#' @concept display
#' @export
print.K <- function(x, ...){
    Kname <- deparse(substitute(x))
    if (is.character(x)) {
        ## Check if 'x' is a folder containing K.rds
        if (file_test('-d', x) &&
                file.exists(file.path(x, 'K.rds'))) {
            x <- readRDS(file.path(x, 'K.rds'))
        } else {
            ## Assume 'x' the full path of K.rds
            ## possibly without the file extension '.rds'
            x <- paste0(sub('.rds$', '', x), '.rds')
            if (file.exists(x)) {
                x <- readRDS(x)
            } else {
                x <- 'Not a "K" object'
            }
        }
    } else if(!is.list(x) || is.null(x[['auxmetadata']])){
        x <- 'Not a "K" object'
    }
    str(object = x, ...)
    invisible(x)
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
## #' ## Load the example `K`nowledge object calculated from the "penguins" dataset;
## #' ## variates: 'species' and 'bill_len'
## #' K <- Kexample
## #'
## #' ## Calculate the probability object for the three values of variate 'species',
## #' ## given values 43 and 44 of variate 'bill_len';
## #' ## this object contains probabilities, quantiles, and other information
## #' probs <- Pr(
## #'   Y = data.frame(species = c('Adelie', 'Chinstrap', 'Gentoo')),
## #'   X = data.frame(bill_len = c(43, 44)),
## #'   K = K
## #' )
## #'
## #' probs$value
## #'
## #' ## Subset by retaining the values 'Adelie' and 'Gentoo' for species,
## #' ## and 44 for bill length
## #' newprobs <- .prsubset(
## #'   probs,
## #'   subset = list(species = c('Adelie', 'Gentoo'), bill_len = 43)
## #' )
## #'
## #' newprobs$value
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
        x$value <- x$value[selvals, , drop = FALSE]
        if(!is.null(x$value.acc)){
            x$value.acc <- x$value.acc[selvals, , drop = FALSE]
        }
        if(!is.null(x$quantiles)){
            x$quantiles <- x$quantiles[selvals, , , drop = FALSE]
        }
        if(!is.null(x$quantiles.acc)){
            x$quantiles.acc <- x$quantiles.acc[selvals, , , drop = FALSE]
        }
        if(!is.null(x$samples)){
            x$samples <- x$samples[selvals, , , drop = FALSE]
        }
        x$Y <- x$Y[selvals, , drop = FALSE]
    }

    ## subset X
    for(vrt in vrtnames[vrtnames %in% Xnames]){
        selvals <- x$X[[vrt]] %in% subset[[vrt]]
        x$value <- x$value[, selvals, drop = FALSE]
        if(!is.null(x$value.acc)){
            x$value.acc <- x$value.acc[, selvals, drop = FALSE]
        }
        if(!is.null(x$quantiles)){
            x$quantiles <- x$quantiles[, selvals, , drop = FALSE]
        }
        if(!is.null(x$quantiles.acc)){
            x$quantiles.acc <- x$quantiles.acc[, selvals, , drop = FALSE]
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
