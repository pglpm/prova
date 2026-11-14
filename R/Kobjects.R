# Internal environment to hold a K-object, for user convenience
.prova_envK <- new.env(parent = emptyenv())


#' @name "K" objects and arguments
#' @rdname Kobjects
#'
#' @title Set or unset default values for 'K =' arguments, and retrieve "prova_K" objects.
#'
#' @description
#' Functions for declaring or undeclaring a "K" (more precisely "prova_K") object to be used implicitly in any subsequent `K = ` arguments, and for showing its contents.
#'
#' @param K One of these alternatives:
#' - A "K" (more precisely "prova_K") object.
#' - A character string of the path to an [RDS][base::readRDS] file (typically created by `learn()`) containing a valid "K" object.
#' - A character string of the path to a directory (also typically created by `learn()`) containing such an [RDS][base::readRDS] file of a "K" object.
#' - For function `useK()`, argument `NULL` or `NA` or `FALSE` **removes** any default `K = ` argument.
#' - Function `useK()` with empty argument will return the name of the "K" object currently used as default.
#' - For function `getK()` it can also be `NULL` or omitted, if a default `K = ` argument has been defined with `useK()`.
#'
#' @param .name Either `NULL` (default) or a character. Used for internal purposes.
#'
#' @details
#' The `K = ` argument in most functions of the **Prova** package, such as `Pr()`, accepts either a "K" (more precisely "prova_K") object, or a path to a directory containing a 'K.rds' file with such object, or a path to such a file itself. In a typical session or script, the "K" object was calculated beforehand, and is the same in all functions, unless the user is comparing probabilities calculated from different sampling data or different amounts of sampling data.
#'
#' The function `useK()` allows the user to specify a "K" object to be implictily used in all `K = ` arguments of subsequent function calls. Then such arguments can simply be omitted, saving a lot of `K = ...`-typing (attention must still be paid to argument order; see details of individual functions).
#'
#' This function also checks if the given `K` is a valid "K" object, or path to one, and throws an error otherwise. Note that any previously declared object is replaced.
#'
#' (This function also saves, mostly for internal purpose in plotting functions, the name of the variable that pointed to the "K" object.)
#'
#' If called with empty argument, '`useK()`', it returns the name of the "K" object currently set as default, or `NULL` if no default is set.
#'
#' If called as `useK(NULL)` or `useK(NA)`, `useK(FALSE)`, then it declares that no default "K" objects should be used in `K = ` arguments any longer. Note that any subsequent calls to functions that omit `K = ` arguments will obviously throw an error.
#'
#' The function `getK()` returns the actual "K" object, if its argument is a path to such an object. If the argument is the object itself it just returns it. With an empty argument, it returns the "K" object declared by `useK()`, throwing an error if no such object was declared. This function can be useful if you want to quickly check some information stored in the "K" object, such as the metadata or the number of Monte Carlo samples (see examples).
#'
#' (This function can also return, via the `name` argument, the original name of the variable that pointed to the "K" object. This is mostly used for internal use of plotting functions.)
#'
#' @return
#'
#' Function `useK(...)`, called with an argument (also `NULL`), invisibly returns the name of the variable that points to the "K" object. If called with no arguments, '`useK()`', it returns the name of the "K" object currently set as default, or `NULL` if none is set.
#'
#' Function `getK()` returns the actual "K" object corresponding to its input. If called with a non-`NULL` `name` argument, it returns a list of a "K" object and its name.
#'
#' @seealso
#'
#' [learn()], which creates and stores "K" objects.
#'
#' [Pr()], [vrtgrid()], and similar functions which use "K" objects.
#'
#' @examples
#' ## 'Prova' includes the example object 'Kexample'
#' ## related to a dataset with variates 'species' and 'bill_len'.
#'
#' ## Set the object 'Kexample' to be used as default 'K=' argument;
#' ## it could be just the path (character string) to such an object
#' useK(Kexample)
#'
#' ## Show the metadata included in this default knowledge object
#' getK()$info$metadata
#'
#' ## Create a data frame with all possible values of 'species';
#' ## then calculate the probabilities of the different species
#' ## full calls would be   vrtgrid(vrt = 'species', K = Kexample)
#' ## and   Pr(Y = Y, X = NA, K = Kexample)
#'
#' Y <- vrtgrid('species')
#'
#' probs <- Pr(Y)
#'
#' ## Stop 'Kexample' to be used as default;
#' ## note that calling "Pr(Y)" would give an error thereafter.
#' useK()
#'
#' ## Show how many Monte Carlo samples 'Kexample' contains;
#' ## note we must pass it explicitly as argument now
#' getK(Kexample)$info$nMCsamples
#'
#' @concept K
NULL


#' @rdname Kobjects
#' @export
useK <- function(K = NULL){
    if(missing('K')){
        ## user wants to know the name of the K object last saved
        if(exists('.Kname', envir = .prova_envK, inherits = FALSE)){
            get('.Kname', envir = .prova_envK, inherits = FALSE)
        } else {
            NULL
        }
    } else if(is.null(K) || (is.logical(K) && !isTRUE(K))){
        ## user wants to remove K object
        if(exists('.K', envir = .prova_envK, inherits = FALSE)){
            Kname <- get('.Kname', envir = .prova_envK, inherits = FALSE)
            rm('.K', envir = .prova_envK)
            rm('.Kname', envir = .prova_envK)
        } else {
            Kname <- NULL
        }
        invisible(Kname)
    } else if(!inherits(try(getK(K), silent = TRUE), "try-error")){
        ## user wants to set K object as default
        Kname <- deparse(substitute(K))
        assign('.K', K, envir = .prova_envK)
        assign('.Kname', Kname, envir = .prova_envK)
        invisible(Kname)
    } else {
        stop("Argument 'K' must be a 'prova_K' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file., or 'NULL'/'NA'/'FALSE', or empty.")
    }
}



#' @rdname Kobjects
#'
#' @import utils
#'
#' @concept learn
#' @export
getK <- function(
    K = NULL,
    .name = NULL
){
    ## Save name of argument
    if(is.character(.name)){
        ## called from within a function
        Kname <- .name
    } else {
        Kname <- deparse(substitute(K))
    }
    ## Check if a default K object and load if true
    if(is.null(K)){
        if(!exists('.K', envir = .prova_envK, inherits = FALSE)){
            stop('No "K" object is set as default.\nIf you want to omit "K =" arguments,\nplease set the "K" object that should be used for the session\nby means of the function "useK()".', call. = FALSE)
        } else {
            K <- get('.K', envir = .prova_envK, inherits = FALSE)
            Kname <- get('.Kname', envir = .prova_envK, inherits = FALSE)
        }
    }

    ## Test validity of K reference
    ## We do this even if the K object was previously checked by useK(),
    ## in case directories or files have been deleted in the meantime

    ## Is K a reference?
    if(is.character(K)){
        if(file.exists(paste0(sub('.rds$', '', K), '.rds'))){
            ## K is path to K-file
            K <- readRDS(paste0(sub('.rds$', '', K), '.rds'))
        } else if(file_test('-d', K) && file.exists(file.path(K, 'K.rds'))) {
            ## K is path do directory of K-file
            K <- readRDS(file.path(K, 'K.rds'))
        } else {
            K <- NULL
            stop("Argument 'K' must be a 'prova_K' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
        }

        ## test if retrieved K has class 'prova_K', and output
        if(inherits(K, 'prova_K')){
            if(is.null(.name)){ K } else { list(K, Kname) }
        } else {
            NULL
            stop("Argument 'K' must be a 'prova_K' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
        }

    ## Is K the object itself? Test class, and output
    } else if(inherits(K, 'prova_K')){
        # # alternative below was for backward compatibility
        # || (is.list(K) && !is.null(K[['W']]) && !is.null(K[['auxmetadata']]))
        if(is.null(.name)){ K } else { list(K, Kname) }
    } else {
        NULL
        stop("Argument 'K' must be a 'prova_K' object, or a path to an RDS file with such object, or a path to a directory to a 'K.rds' file.")
    }
}


