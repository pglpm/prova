library('prova')

## From inferno_start vignette
set.seed(50) ## replace with your favourite seed number
datafile <- '~/repos/prova/vignettes/penguins_60.csv'
metadatafile <- '~/repos/prova/vignettes/meta_penguins.csv'
parallel <- 4

outputdir <- 'penguin_inference_60'
Kdir <- learn(
    data = datafile,
    metadata = metadatafile,
    ## nsamples = 3600,
    ## nchains = parallel,
    ## minMCiterations = 1000000,
    ## maxMCiterations = 1000800,
    ## prior = FALSE,
    outputdir = outputdir,
    ## appendtimestamp = TRUE,
    ## appendinfo = TRUE,
    ## output = 'directory',
    ## cleanup = FALSE,
    ## maxrelMCSE = +Inf, # 0.038,
    ## minESS = 400, # 0.038,
    ## ncheckpoints = 12,
    parallel = parallel,
    ## parameters for short test run:
    ## subsampledata = 10,
    ## maxhours = 0,
    ## nsamplesperchain = 60,
    ## nchains = parallel + 1,
    ##
    hyperparams = list(
        ## ncomponents = 64,
        ## minalpha = -4,
        ## maxalpha = 4,
        ## byalpha = 1,
        ## Rshapelo = 0.5,
        ## Rshapehi = 0.5,
        ## Rvarm1 = 3^2,
        ## Cshapelo = 0.5,
        ## Cshapehi = 0.5,
        ## Cvarm1 = 3^2,
        ## Dshapelo = 0.5,
        ## Dshapehi = 0.5,
        ## Dvarm1 = 3^2,
        ## Lshapelo = 0.5,
        ## Lshapehi = 0.5,
        ## Lvarm1 = 3^2,
        ## Bshapelo = 1,
        ## Bshapehi = 1,
        ## Dthreshold = 1,
        ## tscalefactor = 4,
        ## avoidzeroW = FALSE
        ## initmethod = 'allinone'
    )
)

## file.copy('~/repos/inferno/R/learn.R', Kdir)
