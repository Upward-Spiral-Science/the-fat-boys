library(data.table)
library(ggplot2)
library(gtable)

#Change to relevant location of file
setwd('C:/Users/iakuznet/Desktop/the-fat-boys/data')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")

#Convert to dataframe
data <- as.data.frame(data)

#Subsample some 10000 rows for further analysis
set.seed(42);rand_rows = sample(1:dim(data)[1],10000)
subsample1 <- data[rand_rows,]

good_ones= c(1:dim(subsample1)[2])

dim(good_ones) <- c(6,dim(subsample1)[2] / 6)

good_ones <- good_ones[1:4,]

dim(good_ones) <- c(4 * dim(good_ones)[2],1)

subsample2 <- subsample1[,good_ones]

#PCA down to 2 dimensions
fit <- prcomp(x = subsample1,center = TRUE,scale = TRUE)
data_embed <- fit$x[,1:2];

#Plot using ggplot2
embed_graph <- as.data.frame(data_embed);


theme_none <- theme(
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank(),
	panel.background = element_blank(),
	axis.title.x = element_text(colour=NA),
	axis.title.y = element_text(size=0),
	axis.text.x = element_blank(),
	axis.text.y = element_blank(),
	axis.line = element_blank(),
	axis.ticks.length = unit(0, "cm")
)


p1 <-ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')