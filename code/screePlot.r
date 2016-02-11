library(data.table)
library(ggplot2)
library(gtable)
library(LICORS)

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
subsample1 <- data[rand_rows,]

#good_ones= c(1:dim(subsample1)[2])

#dim(good_ones) <- c(6,dim(subsample1)[2] / 6)

#good_ones <- good_ones[1:4,]

#dim(good_ones) <- c(4 * dim(good_ones)[2],1)

#subsample2 <- subsample1[,good_ones]

#PCA down to 2 dimensions
fit <- prcomp(x = subsample1,center = TRUE,scale = TRUE)

#Construct scree
results <- data.frame(x = c(1:length(unlist(fit[1]))), y = cumsum(unlist(fit[1])^2) /  max(cumsum(unlist(fit[1])^2)));
p1 <- ggplot(results,aes(x,y)) + geom_line() + geom_point() + xlab("Components") + ylab("Percent Variance") + ggtitle("Scree Plot")

###Try with normalization
