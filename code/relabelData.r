library(data.table)
library(mclust)

labels = c('Synap', 'Synap', 'VGlut1', 'VGlut1', 'VGlut2', 'VGlut3', 'PSD', 'Glur2', 'NDAR1', 'NR2B', 'GAD', 'VGAT', 'PV',
'Gephyr', 'GABAR1', 'GABABR', 'CR1', '5HT1A', 'NOS', 'TH', 'VACht', 'Synapo', 'Tubuli', 'DAPI')

#Change to relevant location of file
setwd('C:/Users/iakuznet/Desktop/the-fat-boys/data')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")

#Convert to dataframe
data <- as.data.frame(data)

#Subsample some 10000 rows for further analysis
set.seed(42);rand_rows = sample(1:dim(data)[1],10000)
subsample <- data[rand_rows,]

fit <- prcomp(x = subsample,center = TRUE,scale = TRUE)
data_embed <- fit$x[,1:2];

result <- mclustBIC(data_embed)

data_embed <- fit$x[,1:5];

result <- mclustBIC(data_embed)

data_embed <- fit$x[,1:50];

result <- mclustBIC(data_embed)
