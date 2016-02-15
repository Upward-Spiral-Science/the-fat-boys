#Attempts different ways of Kmeans clustering the data

kmeansClustering <- function(data){
	require(ggplot2)
	require(gtable)
	require(LICORS)
	require(RColorBrewer)

	#PCA all data down to 2 dimensions
	fit <- prcomp(x = data,center = TRUE,scale = TRUE)
	data_embed <- fit$x[,1:2];

	#Plot the embedding using ggplot2
	embed_graph <- as.data.frame(data_embed);

	p1 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows')

	#Conduct Kmeans
	cluster <- kmeanspp(data, k = 2)
	clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))
	colnames(clust_graph)[3] <- 'Clusters'
	
	p2 <- ggplot(clust_graph,aes(PC1,PC2,color = Clusters)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 KMeans Clusters')

	#Try to cluster excitatory and inhibitory
	#Excitatory is 'VGlut1', 'VGlut1', 'VGlut2', 'VGlut3', 'Glur2'
	#Inhibitory is 'Gephyr', 'GABAR1', 'GABABR'
	excitatory = c(3,4,5,6,8)
	inhibitory = c(14,15,16)
	excite_index = excitatory * 4 + 1
	inhibit_index = inhibitory * 4 + 1

	all_index = c(excite_index,inhibit_index)

	subsample1 <- data[,all_index]

	#PCA down to 2 dimensions
	fit <- prcomp(x = subsample1,center = TRUE,scale = TRUE)
	data_embed <- fit$x[,1:2];

	#Plot using ggplot2
	embed_graph <- as.data.frame(data_embed);

	p3 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('Embedding of Excitatory and Inhibitory Synapse Markers Only')

	#Conduct Kmeans
	cluster <- kmeanspp(subsample1, k = 2)
	clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))
	colnames(clust_graph)[3] <- "Clusters"

	p4 <- ggplot(clust_graph,aes(PC1,PC2,color = Clusters)) + geom_point(alpha = 0.75)  +  theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('Embedding with 2 KMeans Clusters (Excitatory and Inhibitory Only)')

	#This seems to not produce obvious clusters. How strange. Let us try something different.
	#For excitatory include 'VGlut1'
	#For inhibitory include 'GABAR1'
	excitatory = c(3)
	inhibitory = c(14)
	excite_index = excitatory * 4 + 1
	inhibit_index = inhibitory * 4 + 1

	all_index = c(excite_index,inhibit_index)

	subsample2 <- data[,all_index]

	data_embed <- subsample2
	colnames(data_embed) <- c("PC1","PC2")

	#Plot using ggplot2
	embed_graph <- as.data.frame(data_embed);

	p5 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Integrated Brightness vs GABAR1 Integrated Brightness')

	#Conduct Kmeans
	cluster <- kmeanspp(subsample2, k = 2)
	clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))
	
	colnames(clust_graph)[3] <- 'Clusters'
	

	p6 <- ggplot(clust_graph,aes(PC1,PC2,color = Clusters)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Int Bright vs GABAR1 Int Bright with 2 Clusters')

	print(p1)
	print(p2)
	print(p3)
	print(p4)
	print(p5)
	print(p6)
}
