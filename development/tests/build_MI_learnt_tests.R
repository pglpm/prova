## Build a "learnt" object with three variates:
## B, values 'y', 'n'
## N, values 'a', 'b', 'c', 'd', 'e'
## R, real
auxmetadata <- data.frame(
    name = c('B', 'N', 'R'),
    type = c('nominal', 'nominal', 'continuous'),
    mcmctype = c('B', 'N', 'R'),
    id = c(1, 1, 1),
    transform = c('identity', 'identity', 'identity'),
    Nvalues = c(2, 5, NA),
    indexpos = c(NA, 0, NA),
    halfstep = c(NA, NA, NA),
    domainmin = c(NA, NA, -Inf),
    domainmax = c(NA, NA, +Inf),
    minincluded = c(NA, NA, FALSE),
    maxincluded = c(NA, NA, FALSE),
    tdomainmin = c(0, 1, -Inf),
    tdomainmax = c(1, 5, +Inf),
    domainminplushs = c(NA, NA, NA),
    domainmaxminushs = c(NA, NA, NA),
    tdomainminplushs = c(NA, NA, NA),
    tdomainmaxminushs = c(NA, NA, NA),
    tlocation = c(0, 0, 0),
    tscale = c(1, 1, 1),
    plotmin = c(NA, NA, -16),
    plotmax = c(NA, NA, +16),
    V1 = c('y', 'a', NA),
    V2 = c('n', 'b', NA),
    V3 = c(NA, 'c', NA),
    V4 = c(NA, 'd', NA),
    V5 = c(NA, 'e', NA)
)
##
## Four clusters:
## Cluster 1: only N=a; B=y, R mean=-12 sd=1
## Cluster 2: only N=b; B=y,n, R mean=-4 sd=1
## Cluster 3: only N=c,d; B=n, R mean=+4 sd=1
## Cluster 4: only N=e; B=n, R mean=+12 sd=1
W <- rep(0.25, 4) ; dim(W) <- c(length(W))
Nprob <- matrix(c(
    c(1, 0, 0, 0, 0),
    c(0, 1, 0, 0, 0),
    c(0, 0, 0.5, 0.5, 0),
    c(0, 0, 0, 0, 1)
), nrow = 5, ncol = 4, byrow = FALSE)
## Bprob is the probability of the 2nd value, V2
Bprob <- matrix(c(0, 0.5, 1, 1), nrow = 1, ncol = 4, byrow = FALSE)
Rmean <- matrix(c(-12, -4, 4, 12), nrow = 1, ncol = 4, byrow = FALSE)
Rsd <- matrix(1, nrow = 1, ncol = 4, byrow = FALSE)
learnt <- list(Bprob = Bprob, Nprob = Nprob, Rmean = Rmean, Rsd = Rsd, W = W)
##
## 4 chains
nsamples <- 3
learnt <- lapply(learnt, function(xx){
    . <- dim(xx)
    xx <- rep(xx, nsamples)
    dim(xx) <- c(., nsamples)
    xx})
learnt$MCindex <- seq_len(nsamples) ; dim(learnt$MCindex) <- nsamples
learnt$auxmetadata <- auxmetadata
saveRDS(learnt, '~/repos/prova/development/tests/MIlearnt.rds')


#### Tests
nn <- 60 * 3600 # values in comments
## nn <- 30

## MI: B, N
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    ## Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,]
        )) -
            log(sum(
                W * Bprob2[Bv,]
            )) -
            log(sum(
                W * Nprob[Nv,]
            ))
})
##
system.time(testmi <- mutualinfo(Y1names = 'B', Y2names = 'N', X = NULL, learnt = learnt, n = nn))
system.time(testmi2 <- mutualinfo2(Y1names = 'B', Y2names = 'N', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W)))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 0.702276 0.00111638
## [2,] 0.704552 0.0011    
## [3,] 0.704264 0.00111654

## MI: B, R
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    ## Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W * Bprob2[Bv,]
            )) -
            log(sum(
                W * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            ))
})
##
testmi <- mutualinfo(Y1names = 'B', Y2names = 'R', X = NULL, learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = 'B', Y2names = 'R', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 0.706489 0.00111602
## [2,] 0.704318 0.0011    
## [3,] 0.703669 0.00111843

## MI: N, R
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    ## Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Nprob[Nv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W * Nprob[Nv,]
            )) -
            log(sum(
                W * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            ))
})
##
testmi <- mutualinfo(Y1names = 'N', Y2names = 'R', X = NULL, learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = 'N', Y2names = 'R', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 1.99984 0.0000477898
## [2,] 1.99981 0.000052    
## [3,] 1.99967 0.0000812933

## MI: NB, R
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W * Bprob2[Bv,] * Nprob[Nv,]
            )) -
            log(sum(
                W * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            ))
})
##
testmi <- mutualinfo(Y1names = c('N', 'B'), Y2names = 'R', X = NULL, learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = c('N', 'B'), Y2names = 'R', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 1.99976 0.0000785799
## [2,] 1.99978 0.000061    
## [3,] 1.99979 0.0000550814

## MI: BR, N
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W * Nprob[Nv,]
            )) -
            log(sum(
                W * Bprob2[Bv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            ))
})
##
testmi <- mutualinfo(Y1names = c('B', 'R'), Y2names = 'N', X = NULL, learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = c('B', 'R'), Y2names = 'N', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 1.99986 0.0000507009
## [2,] 1.99985 0.000046    
## [3,] 1.99979 0.0000545991

## MI: NR, B
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W * Nprob[Nv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            )) -
            log(sum(
                W * Bprob2[Bv,]
            ))
})
##
testmi <- mutualinfo(Y1names = c('N', 'R'), Y2names = 'B', X = NULL, learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = c('N', 'R'), Y2names = 'B', X = NULL, learnt = learnt,
    ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 0.703589 0.0011162 
## [2,] 0.703597 0.0011    
## [3,] 0.704307 0.00111614

## MI: B, N | R
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
W2 <- W * c(pnorm(-8, mean = Rmean, sd = Rsd, lower.tail = FALSE))
W2 <- W2/sum(W2)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W2)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    ## Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W2 * Bprob2[Bv,] * Nprob[Nv,]
        )) -
            log(sum(
                W2 * Nprob[Nv,]
            )) -
            log(sum(
                W2 * Bprob2[Bv,]
            ))
})
##
testmi <- mutualinfo(Y1names = 'N', Y2names = 'B', X = data.frame(R = -8), tails = list(R = +1), learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = 'N', Y2names = 'B', X = data.frame(R = -8), tails = list(R = +1), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] 0.318    0.00145215
## [2,] 0.315013 0.0015    
## [3,] 0.314283 0.00144847

## MI: B, R | N
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
W2 <- W * Nprob[2,]
W2 <- W2/sum(W2)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W2)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    ## Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W2 * Bprob2[Bv,] * c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W2 * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            )) -
            log(sum(
                W2 * Bprob2[Bv,]
            ))
})
##
testmi <- mutualinfo(Y1names = 'R', Y2names = 'B', X = data.frame(N = 'b'), learnt = learnt, n = nn)
testmi2 <- mutualinfo2(Y1names = 'R', Y2names = 'B', X = data.frame(N = 'b'), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI,
    testmi2$MI[c('value', 'value.MCaccuracy')]
)
## [1,] -3.06142e-17 3.96031e-19 
## [2,] 0            -4.22363e-17
## [3,] -1.46824e-19 1.28617e-19 

## MI: N, R | B
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
W2 <- W * Bprob2[1,]
W2 <- W2/sum(W2)
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W2)
    ## Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W2 * Nprob[Nv,]* c(dnorm(Rv, mean = Rmean, sd = Rsd))
        )) -
            log(sum(
                W2 * c(dnorm(Rv, mean = Rmean, sd = Rsd))
            )) -
            log(sum(
                W2 * Nprob[Nv,]
            ))
})
##
testmi <- mutualinfo(Y1names = 'R', Y2names = 'N', X = data.frame(B = 'y'), learnt = learnt, n = nn)
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    testmi$MI
)
## [1,] 0.918664 0.00101519
## [2,] 0.919260 0.00100000




##############################################
## monitored Monte Carlo
cat('\n')
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
nn <- 1e5
mi2 <- sapply(1:nn, function(xx){
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    ## Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,]
        )) -
            log(sum(
                W * Bprob2[Bv,]
            )) -
            log(sum(
                W * Nprob[Nv,]
            ))
})
mean(mi2)/log(2)
sd(mi2/log(2))/sqrt(length(mi2))











cat('\n')
seqcl <- 1:length(W)
Bprob2 <- rbind(1 - Bprob, Bprob)
seqB <- 1:nrow(Bprob2)
seqN <- 1:nrow(Nprob)
nn <- 0
mi <- 0
while(nn < 1e6 + 1){
    nn <- nn + 1
    i <- sample(seqcl, 1, prob = W)
    Bv <- sample(seqB, 1, prob = Bprob2[,i])
    Nv <- sample(seqN, 1, prob = Nprob[,i])
    ## Rv <- rnorm(1, mean = Rmean[i], sd = Rsd[i])
    mi <- mi + (
        log(sum(
            W * Bprob2[Bv,] * Nprob[Nv,]
        )) -
            log(sum(
                W * Bprob2[Bv,]
            )) -
            log(sum(
                W * Nprob[Nv,]
            ))
    )
    ## cat('\r', mi/nn, '  -  ', nn)
}
cat('\n')
mi/log(2)/nn
