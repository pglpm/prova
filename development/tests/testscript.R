library('tinytest')
library('prova')

results <- list()
tc <- function(x, nm = ''){results <<- c(results, setNames(list(tryCatch(x, error = identity)), nm))}

starttime <- format(Sys.time(), '%y%m%dT%H%M%S')
message('Starting tests ', starttime)



message('Quick learn ', format(Sys.time(), '%y%m%dT%H%M%S'))
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
rm(learnt)



message('Full base learn ', format(Sys.time(), '%y%m%dT%H%M%S'))
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
    verbose = FALSE,
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
rm(learnt)



message('Simple MIs ', format(Sys.time(), '%y%m%dT%H%M%S'))
learnt <- readRDS('MIlearnt.rds')
W <- learnt$W[, 1]
points <- readRDS('mitest_points.rds')
probB <- readRDS('mitest_probB.rds')
probN <- readRDS('mitest_probN.rds')
probR <- readRDS('mitest_probR.rds')
testmi <- readRDS('mitest_testmi.rds')
nn <- nrow(points)
ns <- ncol(W)
##
suite <- list(
    list('B', 'N', NULL, NULL),
    list('B', 'R', NULL, NULL),
    list('N', 'R', NULL, NULL),
    list(c('N', 'B'), 'R', NULL, NULL),
    list(c('B', 'R'), 'N', NULL, NULL),
    list(c('N', 'R'), 'B', NULL, NULL),
    list('B', 'N', 'R', sample.int(n = nn, size = 1)),
    list('B', 'N', 'R', sample.int(n = nn, size = 1)),
    list('B', 'R', 'N', sample.int(n = nn, size = 1)),
    list('B', 'R', 'N', sample.int(n = nn, size = 1)),
    list('R', 'N', 'B', sample.int(n = nn, size = 1)),
    list('R', 'N', 'B', sample.int(n = nn, size = 1))
)
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
    verbose = FALSE,
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




message('Done ', format(Sys.time(), '%y%m%dT%H%M%S'))
