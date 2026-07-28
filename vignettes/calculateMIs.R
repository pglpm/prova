library('prova')

K <- 'Kall.rds'

parallel <- parallel::makeCluster(18)

temp <- mutualinfo(
    Y1names = 'island', Y2names = 'species',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIislandspecies.rds')
cat('\ndone\n')

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'species',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIbodymassspecies.rds')
cat('\ndone\n')

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIbodymassbilllen.rds')
cat('\ndone\n')

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Adelie'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIadelie.rds')
cat('\ndone\n')

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Chinstrap'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIchinstrap.rds')
cat('\ndone\n')

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Gentoo'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIgentoo.rds')

parallel::stopCluster(parallel)
cat('\ndone\n')


