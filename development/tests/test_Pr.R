devtools::load_all()

learnt <- readRDS('~/repos/prova/development/tests/__testbase_full-V9_D3_S3600_260708T121249/learnt.rds')

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

for(iv in seq_len(length(tvals))){
    for(atail in c(0, 'left', 'right')){
        atest <- tvals[iv]
        vrt <- names(atest)
        print(paste0(vrt, ' - ', atail))
        tail <- setNames(list(atail), vrt)
        ##
        prob <- Pr(Y = as.data.frame(atest), X = NULL,
            tails = tail,
            learnt = learnt, parallel = 1)
        ##
        vals <- atest[[1]]
        tempprob <- lapply(vals, function(x){
                testPr(Y = setNames(list(x), vrt), X = NULL,
                    tails = tail, learnt = learnt)
        })
        tprob = list(values = cbind(sapply(tempprob, `[[`, 1)),
            samples = t(sapply(tempprob, `[[`, 2)))
        ##
        rg1 <- range(abs(1 - tprob$values / c(prob$values)), na.rm = TRUE)
        rg1b <- range(abs(tprob$values - c(prob$values)), na.rm = TRUE)
        if(any(rg1 > 1e-15 & rg1b > 1e-15)){
            print('values:'); print(rg1)
        }
        rg2 <- range(abs(1 - tprob$samples / c(prob$samples)), na.rm = TRUE)
        rg2b <- range(abs(tprob$samples - c(prob$samples)), na.rm = TRUE)
        if(any(rg2 > 1e-15 & rg2b > 1e-15)){
            print('samples:'); print(rg2)
        }
        if(atail == 'left' && !(vrt %in% c('Bvrt', 'Nvrt')) &&
               (any(diff(prob$values) < 0) || any(diff(tprob$values) < 0))){
            print('order'); print(cbind(prob$values, tprob$values))
        }
        if(atail == 'right' && !(vrt %in% c('Bvrt', 'Nvrt')) &&
               (any(diff(prob$values) > 0) || any(diff(tprob$values) > 0))){
            print('order'); print(cbind(prob$values, tprob$values))
        }
        if(atail == 0 && vrt %in% c('Bvrt', 'Nvrt', 'Ovrt') &&
               (sum(prob$values) != 1 || sum(tprob$values) != 1)){
            print('sum'); print(colSums(cbind(prob$values, tprob$values)))
        }
        if(atail == 'left' && vrt %in% c('RFvrt', 'Cvrt') &&
                (prob$values[length(prob$values)] != 1 ||
                     tprob$values[length(prob$values)] != 1)){
            print('last'); print(cbind(prob$values, tprob$values))
        }
        if(atail == 'right' && vrt %in% c('RPvrt', 'DPvrt', 'Cvrt') &&
               (prob$values[1] != 1 || tprob$values[1] != 1)){
            print('first'); print(cbind(prob$values, tprob$values))
        }
    }
}


set.seed(16)
problem <- FALSE
while(!problem){
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
    print('next:')
    print(as.data.frame(inY)) ; print(as.data.frame(inX)) ; print(intails)
    intails <- setNames(sample(c(-1, 0, 1), ntvals - 2, replace = TRUE),
        c('Rvrt', 'RPvrt', 'RFvrt', 'Cvrt', 'Dvrt', 'DPvrt', 'Ovrt'))
    if(c(inY, inX)[['RPvrt']] == 0 && intails[['RPvrt']] == 0){
        intails[['RPvrt']] == 1
    }
    ##
    prob <- Pr(Y = as.data.frame(inY), X = as.data.frame(inX),
        tails = intails, learnt = learnt, parallel = 1)
    ##
    tprob <- testPr(Y = inY, X = inX, tails = tail, learnt = learnt)
    ##
    if(any(abs(1 - tprob$value / c(prob$values)) > 1e-15, na.rm = TRUE)){
        problem <- TRUE
        print('values:') ; print(cbind(prob$values, tprob$value))
    }
    if(any(abs(1 - tprob$samples / c(prob$samples)) > 1e-15, na.rm = TRUE)){
        problem <- TRUE
        print('samples:') ; print(which(
            abs(1 - tprob$samples / c(prob$samples)) ==
                max(abs(1 - tprob$samples / c(prob$samples))),
            arr.ind = TRUE))
    }
}
