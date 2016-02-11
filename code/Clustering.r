library(data.table)
library(ggplot2)
library(gtable)
library(LICORS)
library(tsne)

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


p1 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')

#Conduct Kmeans
cluster <- kmeanspp(subsample2, k = 2)
clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

p2 <- ggplot(clust_graph,aes(PC1,PC2,color = V3)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 Clusters')

#Try to cluster excitatory and inhibitory
#Excitatory is 'VGlut1', 'VGlut1', 'VGlut2', 'VGlut3', 'Glur2'
#Inhibitory is 'Gephyr', 'GABAR1', 'GABABR'
excitatory = c(3,4,5,6,8)
inhibitory = c(14,15,16)
excite_index = excitatory * 6 + 1
inhibit_index = inhibitory * 6 + 1

all_index = c(excite_index,inhibit_index)

subsample3 <- subsample1[,all_index]

#PCA down to 2 dimensions
fit <- prcomp(x = subsample3,center = TRUE,scale = TRUE)
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


p3 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')

#Conduct Kmeans
cluster <- kmeanspp(subsample3, k = 2)
clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

p4 <- ggplot(clust_graph,aes(PC1,PC2,color = V3)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 Clusters')

#This seems to not produce obvious clusters. How strange. Let us try something different.
#For excitatory include 'VGlut1'
#For inhibitory include 'GABAR1'
excitatory = c(3)
inhibitory = c(14)
excite_index = excitatory * 6 + 1
inhibit_index = inhibitory * 6 + 1

all_index = c(excite_index,inhibit_index)

subsample4 <- subsample1[,all_index]

data_embed <- subsample4
colnames(data_embed) <- c("PC1","PC2")

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


p5 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')

#Conduct Kmeans
cluster <- kmeanspp(subsample4, k = 2)
clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

p6 <- ggplot(clust_graph,aes(PC1,PC2,color = cluster$cluster)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 Clusters')

#Honestly, still not too promising. From marginals, the columns that show the most promise ar ethose that are 6n for integer n. Try those:
#Try to cluster excitatory and inhibitory
#Excitatory is 'VGlut1', 'VGlut1', 'VGlut2', 'VGlut3', 'Glur2'
#Inhibitory is 'Gephyr', 'GABAR1', 'GABABR'
excitatory = c(3,4,5,6,8)
inhibitory = c(14,15,16)
excite_index = excitatory * 6 + 6
inhibit_index = inhibitory * 6 + 6

all_index = c(excite_index,inhibit_index)

subsample5 <- subsample1[,all_index]

#PCA down to 2 dimensions
fit <- prcomp(x = subsample5,center = TRUE,scale = TRUE)
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


p7 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')

#Conduct Kmeans
cluster <- kmeanspp(subsample5, k = 2)
clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

p8 <- ggplot(clust_graph,aes(PC1,PC2,color = V3)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 Clusters')

#Run kmeans on entire dataset
cluster_whole <- kmeanspp(data, k = 8)

##Try t-SNE
#Subsample 1000 rows
set.seed(42);rand_rows = sample(1:dim(data)[1],1000)
subsample2 <- data[rand_rows,]

ecb <- function(x,y){ plot(x,t='n');  text(x,labels=rownames(subsample2) }
tsne_data <- tsne(subsample2, epoch_callback = ecb, perplexity=50,epoch = 10)

