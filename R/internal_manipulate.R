#' Eliminate samples from mcsamples object
#'
#' Used in 'learn()'.
#'
#' @keywords internal
.mcsubset <- function(K, subsamples) {
    lapply(K, function(xx) {
        do.call('[', c(
            list(xx),
            rep(x = TRUE, times = length(dim(xx)) - 1),
            list(subsamples),
            list(drop = FALSE))
        )
    })
}


#' Concatenate mcsample objects
#'
#' Used in 'learn()'.
#'
#' @keywords internal
.mcjoin <- function(x, y){
    if(is.null(x)){
        y
    } else {
        mapply(
            function(xx, yy) {
                temp <- c(xx, yy)
                dx <- dim(yy)[-length(dim(yy))]
                dim(temp) <- c(dx, length(temp) / prod(dx))
                temp
            },
            x, y,
            SIMPLIFY = FALSE
        )
    }
}


#' Bind 3D arrays by first dimension
#'
#' Used in 'util_checkpoints()' within 'learn()', and in various functions in 'util_lprobs.R' and 'merge.prova_pr'.
#'
#' NB: the following variant is slower:
#'
#' ```
#' function(x, y) {
#'     out <- c(aperm(x), aperm(y))
#'     dim(out) <- c(rev(dim(x)[-1]), dim(x)[1] + dim(y)[1])
#'     aperm(out)
#' }
#' ```
#'
#' @keywords internal
.a3bind <- function(x, y) {
    if(is.null(x)) {
        y
    } else {
        nrx <- dim(x)[1]
        nry <- dim(y)[1]
        out <- array(data = NA, dim = c(nrx + nry, dim(x)[-1]),
            dimnames = NULL)
        out[seq_len(nrx), ,] <- x
        out[nrx + seq_len(nry), ,] <- y
        out
    }
}

#' Bind 3D arrays by second dimension
#'
#' Used in 'merge.prova_pr'.
#'
#' @keywords internal
.a3bind2 <- function(x, y) {
    if(is.null(x)) {
        y
    } else {
        nrx <- dim(x)[2]
        nry <- dim(y)[2]
        out <- array(data = NA, dim = c(dim(x)[1], nrx + nry, dim(x)[3]),
            dimnames = NULL)
        out[, seq_len(nrx),] <- x
        out[, nrx + seq_len(nry),] <- y
        out
    }
}
