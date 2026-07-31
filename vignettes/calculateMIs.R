library('prova')

K <- 'Kall.rds'

parallel <- parallel::makeCluster(18)

starttime <- format(Sys.time(), '%y%m%dT%H%M%S')
message('Starting calcs ', starttime)

temp <- mutualinfo(
    Y1names = 'island', Y2names = 'species',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIislandspecies.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'species',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIbodymassspecies.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    K = K, parallel = parallel
)
saveRDS(temp, 'MIbodymassbilllen.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Adelie'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIadelie.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Chinstrap'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIchinstrap.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Gentoo'), ## choose subpopulation
    K = K, parallel = parallel
)
saveRDS(temp, 'MIgentoo.rds')
message('done ', format(Sys.time(), '%y%m%dT%H%M%S'))

parallel::stopCluster(parallel)
message('Finished ', format(Sys.time(), '%y%m%dT%H%M%S'))
