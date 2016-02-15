#Attempts different ways of Kmeans clustering the data

kmeansClustering <- function(data){
	require(ggplot2)
	require(gtable)
	require(LICORS)
	require(tsne)
	require(RColorBrewer)

	#PCA all data down to 2 dimensions
	fit <- prcomp(x = data,center = TRUE,scale = TRUE)
	data_embed <- fit$x[,1:2];

	#Plot the embedding using ggplot2
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

	p2 <- ggplot(clust_graph,aes(PC1,PC2,color = V3)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('PCA Embedding of Random 10000 Rows with 2 KMeans Clusters')

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

	p3 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('Embedding of Excitatory and Inhibitory Synapse Markers Only')

	#Conduct Kmeans
	cluster <- kmeanspp(subsample1, k = 2)
	clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

	p4 <- ggplot(clust_graph,aes(PC1,PC2,color = V3)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('Embedding with 2 KMeans Clusters (Excitatory and Inhibitory Only)')

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

	p5 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Integrated Brightness vs GABAR1 Integrated Brightness')

	#Conduct Kmeans
	cluster <- kmeanspp(subsample2, k = 2)
	clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))

	p6 <- ggplot(clust_graph,aes(PC1,PC2,color = cluster$cluster)) + geom_point(alpha = 0.75)  + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Integrated Brightness vs GABAR1 Integrated Brightness with 2 Clusters')

	print(p1)
	print(p2)
	print(p3)
	print(p4)
	print(p5)
	print(p6)
}
	##Try t-SNE
	#Subsample 1000 rows
	set.seed(42);rand_rows = sample(1:dim(data)[1],1000)
	subsample3 <- data[rand_rows,]

	ecb = function(x,y){ plot(x,t='n'); text(x) }
	tsne_data <- tsne(subsample3, perplexity=50,epoch = 10)

	tsne_embed <- tsne_data
	colnames(tsne_embed) <- c('E1','E2')

	df <- as.data.frame(cbind(tsne_embed, subsample3))

	jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

	#Color it based on the values in different columns
	for (i in c(1:dim(data)[2])) {
		p7 <- ggplot(df, aes(E1, E2)) + geom_point(aes_string(colour = paste('V',i,sep = "")),alpha = 0.75) + scale_colour_gradientn(colours =  jet.colors(100), name =  paste('Column ',i,sep = "")) + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank())
		#ggsave(paste('tSNE_colored_on_column_',i,'_perplexity50.png',sep=""),p7)
	}

	##Try t-SNE with different perplexity (in this case 20)

	ecb = function(x,y){ plot(x,t='n'); text(x) }
	tsne_data <- tsne(subsample3, epoch_callback = ecb, perplexity=20,epoch = 10)

	tsne_embed <- tsne_data
	colnames(tsne_embed) <- c('E1','E2')

	df <- as.data.frame(cbind(tsne_embed, subsample3))

	jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

	#Color it based on the values in different columns
	for (i in c(1:dim(data)[2])) {
		p8 <- ggplot(df, aes(E1, E2)) + geom_point(aes_string(colour = paste('V',i,sep = "")),alpha = 0.75) + scale_colour_gradientn(colours =  jet.colors(100), name =  paste('Column ',i,sep = "")) + theme_none + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank())
		#ggsave(paste('tSNE_colored_on_column_',i,'_perplexity20.png',sep=""),p8)
	}
}


