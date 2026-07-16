library('tinytest')
library('prova')

results <- list()
tc <- function(x, nm = ''){results <<- c(results, setNames(list(tryCatch(x, error = identity)), nm))}

message('Starting tests at', format(Sys.time(), '%y%m%dT%H%M%S'))



message('Quick learn', format(Sys.time(), '%y%m%dT%H%M%S'))
dataset <- data.frame(V = rnorm(n = 3))
metadata <- data.frame(name = 'V', type = 'continuous')
tc(expect_silent(
    learnt <- learn(
    data = dataset, metadata = metadata,
    ## the following parameters are unrealistic
    ## only used to reduce computation time for this example
    nsamples = 10, nchains = 1,
    startupMCiterations = 10, maxMCiterations = 10,
    minESS = 0, initES = 0, verbose = FALSE
    )
))
saveRDS(results, paste0('tests_',  format(Sys.time(), '%y%m%dT%H%M%S'), '.rds'))



message('Full base learn', format(Sys.time(), '%y%m%dT%H%M%S'))
dataset <- data.frame(V = rnorm(n = 3))
metadata <- data.frame(name = 'V', type = 'continuous')
tc(expect_silent(
    learnt <- learn(
    data = dataset, metadata = metadata,
    ## the following parameters are unrealistic
    ## only used to reduce computation time for this example
    nsamples = 10, nchains = 1,
    startupMCiterations = 10, maxMCiterations = 10,
    minESS = 0, initES = 0, verbose = FALSE
    )
))
saveRDS(results, paste0('tests_',  format(Sys.time(), '%y%m%dT%H%M%S'), '.rds'))



message('Done at', format(Sys.time(), '%y%m%dT%H%M%S'))
