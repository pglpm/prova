#' Retrieve a "Knowledge" object
#'
#' @details
#' Retrieves a "Knowledge" object if given as a path to directory or file.
#'
#' @param K either a "Knowledge" object, or a character string with the path to an rds file with such an object or a directory containing one.
#'
#' @return The actual "Knowledge" object or `NULL` if none was found.
#'
#' @import utils
#'
#' @keywords internal
.retrieveK <- function(K){
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
        ## test if K has class 'K'
        if(inherits(K, 'K')){
            K
        } else {
            NULL
        }
    } else if(inherits(K, 'K') ||
           (is.list(K) && !is.null(K[['W']]) && !is.null(K[['auxmetadata']]))){
        ## K is K-object
        K
    } else {
        NULL
    }
}
