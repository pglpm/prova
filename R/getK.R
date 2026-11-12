#' Retrieve a "prova_K" (knowledge) object
#'
#' @description
#' The `K = ` argument in most functions of the **Prova** package accepts either a "prova_K" (knowledge) object, or a path to a directory containing a 'K.rds' file with such object, or a path to such a file itself.
#'
#' The function `getK()` retrieves the actual "prova_K" object if given a path as in the latter two cases, and simply returns its argument if this is an actual "prova_K" object. In any case it also checks for the validity of the object, returning `NULL` if the object or path are not valid.
#'
#' This function can be useful if you want to quickly check some information stored in the "prova_K" object, such as the metadata or the number of Monte Carlo samples (see examples).
#'
#' @param K either a "prova_K" (knowledge) object, or a character string with the path to an RDS file with such an object or a directory containing one. The default is the value of the option `'prova.K'` in [options()][base::options()], in case the user has stored a "prova_K" object or its path in this option.
#'
#' @return The actual "prova_K" (knowledge) object or `NULL` if none was found.
#'
#' @examples
#' ## Here w set 'K' to be the object 'Kexample',
#' ## but it could be just the path (character string) to such an object
#' K <- Kexample
#'
#' ## Retrieve the metadata that were used in 'K'
#' getK(K)$info$metadata
#'
#' ## Retrieve the number of Monte Carlo samples in 'K'
#' getK(K)$info$nMCsamples
#'
#' @import utils
#'
#' @concept learn
#' @export
getK <- function(
    K = getOption('prova.K')
){
    if(is.character(K)){
        if(file.exists(paste0(sub('.rds$', '', K), '.rds'))){
            ## K is path to K-file
            K <- readRDS(paste0(sub('.rds$', '', K), '.rds'))
        } else if(file_test('-d', K) && file.exists(file.path(K, 'K.rds'))) {
            ## K is path do directory of K-file
            K <- readRDS(file.path(K, 'K.rds'))
        } else {
            K <- NULL
        }
        ## test if K has class 'prova_K' (knowledge)
        if(inherits(K, 'prova_K')){
            K
        } else {
            NULL
        }
    } else if(inherits(K, 'prova_K') ||
           (is.list(K) && !is.null(K[['W']]) && !is.null(K[['auxmetadata']]))){
        ## K is K-object
        K
    } else {
        NULL
    }
}
