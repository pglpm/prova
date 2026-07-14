devtools::load_all()

learnt <- readRDS('~/repos/prova/development/tests/__testbase_full-latest/learnt.rds')

tvals <- list(
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

pnames <- c('values', 'quantiles', 'samples', 'values.MCaccuracy', 'quantiles.MCaccuracy', 'Y', 'X')
nsamples = 'all'
for(iv in seq_len(length(tvals))){
    for(atail in c(0, 'left', 'right')){
        atest <- tvals[iv]
        vrt <- names(atest)
        print(paste0(vrt, ' - ', atail))
        tail <- setNames(list(atail), vrt)
        ##
        prob <- oldPr(Y = as.data.frame(atest), X = NULL,
            tails = tail, nsamples = nsamples,
            learnt = learnt, parallel = 1)
        probn <- Pr(Y = as.data.frame(atest), X = NULL,
            tails = tail, nsamples = nsamples,
            learnt = learnt, parallel = 1)
            for(xx in pnames){
                if(!identical(unname(prob[[xx]]), unname(probn[[xx]]))){
                    print(xx)
                    stop()
                }
            }
    }
}


parallel <- parallel::makeCluster(4)
nsamples <- 'all'
pnames <- c('values', 'quantiles', 'samples', 'values.MCaccuracy', 'quantiles.MCaccuracy', 'Y', 'X')
set.seed(16)
problem <- FALSE
kc <- 0L
cat('\n')
while(!problem){
    kc <- kc + 1L
    tol <- 5e-5
    prob <- tprob <- NULL
    ntvals <- length(tvals)
    nY <- sample(1:ntvals, 1)
    ninY <- sample(1:ntvals, nY, replace = FALSE)
    ninX <- (1:ntvals)[-ninY]
    inY <- tvals[ninY]
    inY <- lapply(inY, function(x)sample(unlist(x), 1))
    inX <- tvals[ninX]
    if(length(inX) > 0){
        inX <- lapply(inX, function(x)sample(unlist(x), 1))
    } else {
        inX <- NULL
    }
    cat('\r', kc)
    intails <- setNames(sample(c(-1, 0, 1), ntvals - 2, replace = TRUE),
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
    prob <- oldPr(Y = as.data.frame(inY), X = as.data.frame(inX),
        tails = intails, nsamples = nsamples,
        learnt = learnt, parallel = parallel)
    ##
    probn <- Pr(Y = as.data.frame(inY), X = as.data.frame(inX),
        tails = intails, nsamples = nsamples,
        learnt = learnt, parallel = parallel)
    ##
    for(xx in pnames){
        if(!identical(unname(prob[[xx]]), unname(probn[[xx]]))){
            problem <- TRUE
            print(xx)
        }
    }
    if(problem){
        print(as.data.frame(inY)) ; print(as.data.frame(inX)) ;
        print(as.data.frame(intails))
    }
}
cat('\n')
parallel::stopCluster(parallel)


parallel <- 4
nsamples <- 'all'
pnames <- c('values', 'quantiles', 'samples', 'values.MCaccuracy', 'quantiles.MCaccuracy', 'Y', 'X')
set.seed(11)
problem <- FALSE
kc <- 0L
cat('\n')
while(!problem){
    kc <- kc + 1L
    tol <- 5e-5
    prob <- tprob <- NULL
    ntvals <- length(tvals)
    nY <- sample(1:ntvals, 1)
    ninY <- sample(1:ntvals, nY, replace = FALSE)
    ninX <- (1:ntvals)[-ninY]
    inY <- tvals[ninY]
    inY <- as.data.frame(
        lapply(inY, function(x)sample(unlist(x), 2, replace = TRUE))
        )
    inX <- tvals[ninX]
    if(length(inX) > 0){
        inX <- as.data.frame(
            lapply(inX, function(x)sample(unlist(x), 3, replace = TRUE))
        )
    } else {
        inX <- NULL
    }
    cat('\r', kc)
    intails <- setNames(sample(c(-1, 0, 1), ntvals - 2, replace = TRUE),
        c('Rvrt', 'RPvrt', 'RFvrt', 'Cvrt', 'Dvrt', 'DPvrt', 'Ovrt'))
    intails <- as.list(intails)
    if(any(c(inY[['RPvrt']], inX[['RPvrt']]) == 0) && intails[['RPvrt']] != 1){
        intails[['RPvrt']] <- 1
    }
    if(any(c(inY[['RFvrt']], inX[['RFvrt']]) == 0) && all(c(inY[['RFvrt']], inX[['RFvrt']]) != 1) && intails[['RFvrt']] != 1){
        intails[['RFvrt']] <- 1
    }
    if(any(c(inY[['RFvrt']], inX[['RFvrt']]) == 1) && all(c(inY[['RFvrt']], inX[['RFvrt']]) != 0) && intails[['RFvrt']] != -1){
        intails[['RFvrt']] <- -1
    }
    if(any(c(inY[['RFvrt']], inX[['RFvrt']]) == 1) && any(c(inY[['RFvrt']], inX[['RFvrt']]) == 0)){
        next
    }
    ##
    prob <- oldPr(Y = inY, X = inX,
        tails = intails, nsamples = nsamples,
        learnt = learnt, parallel = parallel)
    ##
    probn <- Pr(Y = inY, X = inX,
        tails = intails, nsamples = nsamples,
        learnt = learnt, parallel = parallel)
    ##
    for(xx in pnames){
        if(!identical(unname(prob[[xx]]), unname(probn[[xx]]))){
            problem <- TRUE
            print(xx)
        }
    }
    if(problem){
        print(as.data.frame(inY)) ; print(as.data.frame(inX)) ;
        print(as.data.frame(intails))
    }
}
cat('\n')
parallel::stopCluster(parallel)

devtools::load_all()
probn <- Pr(Y = data.frame(Nvrt = paste0('N', letters[1:4])),
    X = data.frame(Rvrt = 1), learnt = learnt,
    prior = c(0.5,0.5,0,0), parallel = 1)
sum(probn$values)
probn$values

devtools::load_all()
probn <- Pr(Y = data.frame(Nvrt = paste0('N', letters[c(1,2,1)])),
    X = data.frame(Rvrt = 1), learnt = learnt,
    prior = c(0.5,0.5,0), parallel = 1)
sum(probn$values)
probn$values
