devtools::load_all()

Kexample <- learn(data = penguins, metadata = metadataExample, nsamples = 225, nchains = 1)

save(Kexample, file = '~/repos/prova/data/Kexample.rda')
