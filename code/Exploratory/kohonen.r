library(data.table)
library(mclust)

labels = c('Synap', 'Synap', 'VGlut1', 'VGlut1', 'VGlut2', 'VGlut3', 'PSD', 'Glur2', 'NDAR1', 'NR2B', 'GAD', 'VGAT', 'PV',
'Gephyr', 'GABAR1', 'GABABR', 'CR1', '5HT1A', 'NOS', 'TH', 'VACht', 'Synapo', 'Tubuli', 'DAPI')

#Change to relevant location of file
setwd('C:/Users/iakuznet/Desktop/the-fat-boys/data')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")
