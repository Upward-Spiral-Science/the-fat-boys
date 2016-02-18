#Attempt using t-SNE to reveal clusters

tsneClustering <- function(data){
	require(tsne)
	require(ggplot2)
	require(gtable)
	
	#Subsample 1000 rows
	set.seed(42);rand_rows = sample(1:dim(data)[1],1000)
	subsample3 <- data[rand_rows,]

	ecb = function(x,y){ plot(x,t='n'); text(x) }
	tsne_data <- tsne(subsample3, perplexity=50,epoch = 100)

	tsne_embed <- tsne_data
	colnames(tsne_embed) <- c('E1','E2')

	df <- as.data.frame(cbind(subsample3,tsne_embed))
	colnames(df)[1:dim(subsample3)[2]] <- paste('V',c(1:dim(subsample3)[2]),sep = "")

	jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
	
	#Color it based on the values in different columns
	for (i in c(1:dim(data)[2])) {
		p1 <- ggplot(df, aes(E1, E2)) + geom_point(aes_string(colour = paste('V',i,sep = "")),alpha = 0.75) + scale_colour_gradientn(colours =  jet.colors(100), name =  paste('Column ',i,sep = "")) + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle(paste('t-SNE Colored On Column',i,'with Perplexity 50'))
		print(p1)
		#ggsave(paste('tSNE_colored_on_column_',i,'_perplexity50.png',sep=""),p7)
	}

	##Try t-SNE with different perplexity (in this case 20)

	ecb = function(x,y){ plot(x,t='n'); text(x) }
	tsne_data <- tsne(subsample3, epoch_callback = ecb, perplexity=20,epoch = 10)

	tsne_embed <- tsne_data
	colnames(tsne_embed) <- c('E1','E2')

	df <- as.data.frame(cbind(subsample3,tsne_embed))
	colnames(df)[1:dim(subsample3)[2]] <- paste('V',c(1:dim(subsample3)[2]),sep = "")
	

	jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

	#Color it based on the values in different columns
	for (i in c(1:dim(data)[2])) {
		p2 <- ggplot(df, aes(E1, E2)) + geom_point(aes_string(colour = paste('V',i,sep = "")),alpha = 0.75) + scale_colour_gradientn(colours =  jet.colors(100), name =  paste('Column ',i,sep = "")) + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle(paste('t-SNE Colored On Column',i,'with Perplexity 20'))
		print(p2)
		#ggsave(paste('tSNE_colored_on_column_',i,'_perplexity20.png',sep=""),p8)
	}
}


