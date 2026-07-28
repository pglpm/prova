library('prova')

message(packageVersion('prova'))

parallel <- 8

test_equivalent <- function(x, y, tolerance = sqrt(.Machine$double.eps)){
    all.equal(x, y, tolerance = tolerance, scale = 1, check.attributes = FALSE)
}


tc <- function(nm = '', x){results <<- c(results, setNames(list(tryCatch(x, error = identity)), nm))}


results <- list()
starttime <- format(Sys.time(), '%y%m%dT%H%M%S')
message('Starting tests ', starttime)
savefile <- paste0('testres_', starttime, '.rds')


nm <- 'Quick learn'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
dataset <- data.frame(V = rnorm(n = 3))
metadata <- data.frame(name = 'V', type = 'continuous')
tc(nm, {
    K <- learn(
    data = dataset, metadata = metadata,
    ## the following parameters are unrealistic
    ## only used to reduce computation time for this example
    nsamples = 10, nchains = 1,
    startupMCiterations = 10, maxMCiterations = 10,
    minESS = 0, initES = 0, verbose = FALSE
    )
    is.list(K)
    }
)
saveRDS(results, savefile)
all(sapply(results, isTRUE))
rm(K)



nm <- 'Full base learn'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
outputdir <- 'testbase_test'
tc(nm, {
    Kdir <- learn(
    data = 'data_basetest.csv',
    metadata = 'metadata_basetest.csv',
    # nsamples = 200,
    # nchains = parallel,
    ## minMCiterations = 3600 * 3,
    prior = FALSE,
    outputdir = outputdir,
    valueisK = FALSE,
    appendinfo = TRUE,
    cleanup = TRUE,
    parallel = parallel,
    # maxrelMCSE = +Inf,
    # minESS = 100,
    verbose = FALSE
    ## ncheckpoints = 12,
    ##
    ## ## parameters for short test run:
    ## subsampledata = 10,
    ## maxhours = 0,
    ## nsamplesperchain = 60,
    ## nchains = parallel + 1,
    ##
    )
    is.character(Kdir)
    }
)
saveRDS(results, savefile)
all(sapply(results, isTRUE))



nm <- 'Simple Pr'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
K <- Kdir
suite <- list(
    Rvrt = seq(-3, 3, length.out = 9),
    RPvrt = seq(0, 3, length.out = 9),
    RFvrt = seq(0, 1, length.out = 9),
    Cvrt = seq(0, 1, length.out = 9),
    Dvrt = seq(-3, 3, length.out = 9),
    DPvrt = seq(0, 3, length.out = 9),
    Bvrt = c('no', 'yes'),
    Nvrt = paste0('N', letters[1:4]),
    Ovrt = paste0('', LETTERS[1:5])
)
for(iv in seq_along(suite)){
    for(atail in c(0, 'left', 'right')){
        atest <- suite[iv]
        vrt <- names(atest)
        tail <- setNames(list(atail), vrt)
        prob <- targetprob <- NULL
        ##
        prob <- Pr(Y = as.data.frame(atest), X = NULL,
            tails = tail,
            K = K, parallel = 1)
        ##
        vals <- atest[[1]]
        targetprob <- lapply(vals, function(x){
                prova:::.testPr(Y = setNames(list(x), vrt), X = NULL,
                    tails = tail, K = K)
        })
        targetprob = list(values = cbind(sapply(targetprob, `[[`, 1)),
            samples = t(sapply(targetprob, `[[`, 2)))
        tc(paste0(nm, '-', iv, '-', atail, '-values'),
            test_equivalent(prob$values, targetprob$values,
                tolerance = 10 * .Machine$double.eps
            ))
        tc(paste0(nm, '-', iv, '-', atail, '-samples'),
            test_equivalent(c(prob$samples), c(targetprob$samples),
                tolerance = 10 * .Machine$double.eps
            ))
saveRDS(results, savefile)
    }
}
all(sapply(results, isTRUE))




nm <- 'Various Pr'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
K <- Kdir
atest <- 0L
set.seed(16)
while(atest < 50){
    atest <- atest + 1L
    prob <- targetprob <- NULL
    nsuite <- length(suite)
    nY <- sample(1:nsuite, 1)
    ninY <- sample(1:nsuite, nY, replace = FALSE)
    ninX <- (1:nsuite)[-ninY]
    inY <- suite[ninY]
    inY <- lapply(inY, function(x)sample(unlist(x), 1))
    inX <- suite[ninX]
    if(length(inX) > 0){
        inX <- lapply(inX, function(x)sample(unlist(x), 1))
    } else {
        inX <- NULL
    }
    intails <- setNames(sample(c(-1, 0, 1), nsuite - 2, replace = TRUE),
        c('Rvrt', 'RPvrt', 'RFvrt', 'Cvrt', 'Dvrt', 'DPvrt', 'Ovrt'))
    intails <- as.list(intails)
    if(c(inY, inX)[['RPvrt']] == 0 && intails[['RPvrt']] != 1){
        intails[['RPvrt']] <- 1
    }
    if(c(inY, inX)[['RFvrt']] == 0 && intails[['RFvrt']] != 1){
        intails[['RFvrt']] <- 1
    }
    if(c(inY, inX)[['RFvrt']] == 1 && intails[['RFvrt']] != -1){
        intails[['RFvrt']] <- -1
    }
    ##
    prob <- Pr(Y = as.data.frame(inY), X = as.data.frame(inX),
        tails = intails, K = K, parallel = 1)
    ##
    targetprob <- prova:::.testPr(Y = inY, X = inX, tails = intails,
        K = K)
    ##
    tc(paste0(nm, '-', atest, '-values'),
        test_equivalent(c(prob$values), c(targetprob$value),
            tolerance = 10 * .Machine$double.eps
        ))
    tc(paste0(nm, '-', atest, '-samples'),
        test_equivalent(c(prob$samples), c(targetprob$samples),
            tolerance = 10 * .Machine$double.eps
        ))
saveRDS(results, savefile)
}
all(sapply(results, isTRUE))



nm <- 'Simple MIs'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
K <- readRDS('tests_MIK.rds')
source('testMIfunction.R')
nn <- 60 * 3600
ns <- ncol(K$W)
nv <- nn / ns
##
suite <- list(
    list('B', 'N', NULL),
    list('B', 'R', NULL),
    list('N', 'R', NULL),
    list(c('N', 'B'), 'R', NULL),
    list(c('B', 'R'), 'N', NULL),
    list(c('N', 'R'), 'B', NULL),
    list('B', 'N', list(R = -8)),
    list('B', 'N', list(R = -4)),
    list('B', 'N', list(R = -2)),
    list('B', 'N', list(R = 0)),
    list('B', 'N', list(R = 2)),
    list('B', 'N', list(R = 4)),
    list('B', 'N', list(R = 8)),
    list('B', 'R', list(N = 'a')),
    list('B', 'R', list(N = 'b')),
    list('B', 'R', list(N = 'c')),
    list('B', 'R', list(N = 'd')),
    list('B', 'R', list(N = 'e')),
    list('N', 'R', list(B = 'y')),
    list('N', 'R', list(B = 'n'))
)
for(atest in suite){
    testand <- target <- NULL
    testand <- mutualinfo(
        Y1names = atest[[1]], Y2names = atest[[2]], X = atest[[3]],
        K = K, nv = nv, ns = ns, parallel = parallel
    )
    target <- testMI(
        Y1names = atest[[1]], Y2names = atest[[2]], X = atest[[3]],
        nn = nn, K = K
    )
    tc(paste0(nm, '-', paste0(atest, collapse = '-')), test_equivalent(
        testand$value, target$value,
        tolerance = max((testand$MCaccuracy + target$MCaccuracy) * 2,
            10 * .Machine$double.eps)
    ))
}
saveRDS(results, savefile)
final <- all(sapply(results, isTRUE))
final
if(!final){
    results[!sapply(results, isTRUE)]
}


nm <- 'Quick learn autocluster'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
dataset <- data.frame(V = rnorm(n = 3))
metadata <- data.frame(name = 'V', type = 'continuous')
tc(nm, {
    K <- learn(
    data = dataset, metadata = metadata,
    ## the following parameters are unrealistic
    ## only used to reduce computation time for this example
    nsamples = 30, nchains = 3,
    startupMCiterations = 10, maxMCiterations = 10,
    minESS = 0, initES = 0, verbose = FALSE, parallel = TRUE
    )
    is.list(K)
    }
)
saveRDS(results, savefile)
all(sapply(results, isTRUE))
rm(K)



nm <- 'Quick learn existing cluster'
message(nm, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))
cl <- parallel::makeCluster(6)
dataset <- data.frame(V = rnorm(n = 3))
metadata <- data.frame(name = 'V', type = 'continuous')
tc(nm, {
    K <- learn(
    data = dataset, metadata = metadata,
    ## the following parameters are unrealistic
    ## only used to reduce computation time for this example
    nsamples = 30, nchains = 3,
    startupMCiterations = 10, maxMCiterations = 10,
    minESS = 0, initES = 0, verbose = FALSE, parallel = cl
    )
    is.list(K)
    }
)
saveRDS(results, savefile)
all(sapply(results, isTRUE))
parallel::stopCluster(cl)
rm(K)



message('All test passed: ', all(sapply(results, isTRUE)))

message('Done ', format(Sys.time(), '%y%m%dT%H%M%S'))
