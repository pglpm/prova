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
    Nvalues = c(2, 3, NA),
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
Bprob <- matrix(c(1, 0.5, 0.5, 0), nrow = 1, ncol = 4, byrow = FALSE)
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


