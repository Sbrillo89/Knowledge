
# Correzione del file csv per caricarlo correttamente su AzureML

FileName <- 'Dataset.csv'
getwd()
dir <- getwd()

path <- paste0(dir,'/',FileName)
x <- read.csv(path, sep=";")
write.csv(x, file=FileName, row.names = FALSE)

