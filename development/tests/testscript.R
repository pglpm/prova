library('tinytest')
library('prova')

results <- list()
tc <- function(x, nm = ''){results <<- c(results, setNames(list(tryCatch(x, error = identity)), nm))}

starttime <- format(Sys.time(), '%y%m%dT%H%M%S')
message('Starting tests at', starttime)



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
saveRDS(results, paste0('tests_',  starttime, '.rds'))



message('Full base learn', format(Sys.time(), '%y%m%dT%H%M%S'))
outputdir <- '__testbase_full'
parallel <- 8
tc(expect_silent(
    learntdir <- learn(
    data = 'data_basetest.csv',
    metadata = 'metadata_basetest.csv',
    # nsamples = 200,
    # nchains = parallel,
    ## minMCiterations = 3600 * 3,
    prior = FALSE,
    outputdir = outputdir,
    appendinfo = TRUE,
    cleanup = TRUE,
    parallel = parallel,
    # maxrelMCSE = +Inf,
    # minESS = 100,
    verbose = TRUE,
    ## ncheckpoints = 12,
    ##
    ## ## parameters for short test run:
    ## subsampledata = 10,
    ## maxhours = 0,
    ## nsamplesperchain = 60,
    ## nchains = parallel + 1,
    ##
    hyperparams = list(
        ## ncomponents = 64,
        ## minalpha = -4,
        ## maxalpha = 4,
        ## byalpha = 1,
        ## Rshapelo = 0.5,
        ## Rshapehi = 0.5,
        ## Rvarm1 = 8^2,
        ## Cshapelo = 0.5,
        ## Cshapehi = 0.5,
        ## Cvarm1 = 8^2,
        ## Dshapelo = 0.5,
        ## Dshapehi = 0.5,
        ## Dvarm1 = 8^2,
        ## Bshapelo = 1,
        ## Bshapehi = 1,
        ## Dthreshold = 1,
        ## tscalefactor = 1,
        ## initmethod = 'allinone',
        ## avoidzeroW = TRUE
        ## precluster, prior
    )
)
))
saveRDS(results, paste0('tests_',  starttime, '.rds'))



message('Done at', format(Sys.time(), '%y%m%dT%H%M%S'))
