devtools::load_all()

learnt <- readRDS('~/repos/prova/development/tests/__testbase_full-V9_D3_S3600_260708T121249/learnt.rds')

testvars <- list(
    list(Rvrt = seq(-3, 3, length.out = 9)),
    list(RPvrt = seq(0, 3, length.out = 9)[-1]),
    list(RFvrt = seq(0, 1, length.out = 9)[-c(1,9)]),
    list(Cvrt = seq(0, 1, length.out = 9)),
    list(Dvrt = seq(-3, 3, length.out = 9)),
    list(DPvrt = seq(0, 3, length.out = 9)[-1]),
    list(Bvrt = c('no', 'yes')),
    list(Nvrt = paste0('N', letters[1:4])),
    list(Ovrt = paste0('', LETTERS[1:5]))
)

for(atest in testvars){
    for(atail in c(0, 'left', 'right')){
        print(paste0(names(atest), ' - ', atail))
        tail <- setNames(list(atail), names(atest))
        ##
        prob <- Pr(Y = as.data.frame(atest), X = NULL,
            tails = tail,
            learnt = learnt, parallel = 1)
        ##
        vals <- atest[[1]]
        tempprob <- lapply(vals, function(x){
                testPr(Y = setNames(list(x), names(atest)), X = NULL,
                    tails = tail, learnt = learnt)
        })
        tprob = list(values = cbind(sapply(tempprob, `[[`, 1)),
            samples = t(sapply(tempprob, `[[`, 2)))
        ##
        rg1 <- range(1 - tprob$values / c(prob$values))
        rg1b <- range(tprob$values - c(prob$values))
        if(any(abs(rg1) > 1e-15 & abs(rg2) > 1e-15)){
            print('values:'); print(rg1)
        }
        rg2 <- range(1 - tprob$samples / c(prob$samples))
        rg2b <- range(tprob$samples - c(prob$samples))
        if(any(abs(rg2) > 1e-15 & abs(rg2b) > 1e-15)){
            print('samples:'); print(rg2)
        }
    }
}



