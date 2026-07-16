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
## ** Bprob is the probability of the 2nd value, 'n' **
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
##
testMI <- function(Y1names, Y2names, X = NULL, nn, learnt){
    W <- learnt$W[,1]
    Bprob2 <- unname(rbind(1 - learnt$Bprob[,,1], learnt$Bprob[,,1]))
    Nprob <- learnt$Nprob[,,1]
    Rmean <- learnt$Rmean[,,1]
    Rsd <- learnt$Rsd[,,1]
    ##
    if(!is.null(X)){
        if(names(X) == 'B'){
            Xprob <- Bprob2[which(c('y', 'n') == X[[1]]),]
        } else if(names(X) == 'N'){
            Xprob <- Nprob[which(letters == X[[1]]),]
        } else if(names(X) == 'R'){
            Xprob <- dnorm(x = X[[1]], mean = Rmean, sd = Rsd)
        } else {stop('testmi() used with wrong variate')}
    } else {
        Xprob <- 1
    }
    W <- W * Xprob
    W <- W / sum(W)
    ##
    nclu <- length(W)
    seqclu <- sample.int(n = nclu, size = nn, prob = W, replace = TRUE)
    ## ** Bprob is the probability of the 2nd value, 'n' **
    dpoints <- rbind(
        sapply(seqclu, function(i){c(
            B = sample.int(n = 2, size = 1, prob = Bprob2[,i]),
            N = sample.int(n = nrow(Nprob), size = 1, prob = Nprob[,i])
        )}),
        R = rnorm(n = nn, mean = Rmean[seqclu], sd = Rsd[seqclu])
    )
##
    lprobsBNR <- list(
        ## rows: clusters, cols: points
        B = t(log(Bprob2))[, dpoints['B',]],
        N = t(log(Nprob))[, dpoints['N',]],
        R = dnorm(
            x = matrix(data = dpoints['R',], nrow = nclu, ncol = nn, byrow = TRUE),
            mean = Rmean, sd = Rsd, log = TRUE)
    )
    lprob1 <- do.call(`+`, lprobsBNR[Y1names])
    lprob2 <- do.call(`+`, lprobsBNR[Y2names])
    W <- log(W)
    ##
    mis <- -log(colSums(exp(W + lprob1))) -
        log(colSums(exp(W + lprob2))) +
        log(colSums(exp(W + lprob1 + lprob2)))
    ##
    list(value = mean(mis, na.rm = TRUE) / log(2),
        MCaccuracy = sd(mis, na.rm = TRUE)/(sqrt(length(mis)) * log(2)))
}
saveRDS(testMI, '~/repos/prova/development/tests/mitest_testMI.rds')


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
system.time(testmi <- mutualinfo(Y1names = 'B', Y2names = 'N', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W)))
system.time(testmi2 <- debug_mutualinfo(Y1names = 'B', Y2names = 'N', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W)))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 0.704214 0.00111485
## [2,] 0.703409 0.00110000
## [3,] 0.707436 0.00111551

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
testmi <- mutualinfo(Y1names = 'B', Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = 'B', Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 0.704416 0.00111600
## [2,] 0.705243 0.00110000
## [3,] 0.704648 0.00111654

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
testmi <- mutualinfo(Y1names = 'N', Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = 'N', Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi[c(1,3)]),
    unlist(testmi2[c(1,3)])
)
## [1,] 1.99980 0.0000429070
## [2,] 1.99976 0.0000550000
## [3,] 1.99982 0.0000521042

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
testmi <- mutualinfo(Y1names = c('N', 'B'), Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = c('N', 'B'), Y2names = 'R', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 1.99980 0.0000427974
## [2,] 1.99978 0.0000640000
## [3,] 1.99984 0.0000395938

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
testmi <- mutualinfo(Y1names = c('B', 'R'), Y2names = 'N', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = c('B', 'R'), Y2names = 'N', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 1.99969 0.0000827804
## [2,] 1.99992 0.0000210000
## [3,] 1.99986 0.0000344047

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
testmi <- mutualinfo(Y1names = c('N', 'R'), Y2names = 'B', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = c('N', 'R'), Y2names = 'B', X = NULL, learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 0.704503 0.00111794
## [2,] 0.702978 0.00110000
## [3,] 0.703494 0.00111638


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
testmi <- mutualinfo(Y1names = 'N', Y2names = 'B', X = data.frame(R = -8), tails = list(R = +1), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = 'N', Y2names = 'B', X = data.frame(R = -8), tails = list(R = +1), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 0.317497 0.00145109
## [2,] 0.318583 0.00150000
## [3,] 0.318087 0.00145401

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
testmi <- mutualinfo(Y1names = 'R', Y2names = 'B', X = data.frame(N = 'b'), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
testmi2 <- debug_mutualinfo(Y1names = 'R', Y2names = 'B', X = data.frame(N = 'b'), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] -2.97852e-17  3.98349e-19
## [2,]  0.00000e+00 -4.17943e-17
## [3,]  0.00000e+00  3.29814e-19

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
testmi <- mutualinfo(Y1names = 'R', Y2names = 'N', X = data.frame(B = 'y'), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
## testmi2 <- debug_mutualinfo(Y1names = 'R', Y2names = 'N', X = data.frame(B = 'y'), learnt = learnt, ns = NULL, nv = nn/ncol(learnt$W))
rbind(
    c(value = mean(mi2)/log(2), accuracy = sd(mi2/log(2))/sqrt(length(mi2))),
    ## unlist(testmi2[c(1,3)]),
    unlist(testmi[c(1,3)])
)
## [1,] 0.918152 0.00101560
## [2,] 0.915869 0.00100000
## [3,] 0.918777 0.00101504



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
