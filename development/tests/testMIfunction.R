testMI <- function(Y1names, Y2names, X = NULL, nn, K){
    W <- K$W[,1]
    Bprob2 <- unname(rbind(1 - K$Bprob[,,1], K$Bprob[,,1]))
    Nprob <- K$Nprob[,,1]
    Rmean <- K$Rmean[,,1]
    Rsd <- K$Rsd[,,1]
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
        value.acc = sd(mis, na.rm = TRUE)/(sqrt(length(mis)) * log(2)))
}
