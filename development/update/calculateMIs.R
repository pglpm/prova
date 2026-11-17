library('prova')

K <- 'Kall.rds'

options(cl.cores = 12)

starttime <- format(Sys.time(), '%y%m%dT%H%M%S')
message('Starting calcs ', starttime)

temp <- mutualinfoF(
    Y1names = 'island', Y2names = 'species',
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'species',
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Adelie'), ## choose subpopulation
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Chinstrap'), ## choose subpopulation
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

temp <- mutualinfo(
    Y1names = 'body_mass', Y2names = 'bill_len',
    X = data.frame(species = 'Gentoo'), ## choose subpopulation
    K = K
)
tname <- paste0(temp$Y1names, '_', temp$Y2names, '_', temp$X[[1]])
saveRDS(temp, paste0('MI', tname, '.rds'))
message('done ', tname, ' ', format(Sys.time(), '%y%m%dT%H%M%S'))

message('Finished ', format(Sys.time(), '%y%m%dT%H%M%S'))
