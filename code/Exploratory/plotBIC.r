#Plots the BIC after using PCA to reduce the dimensionality of the data down to the requested number of dimensions.

plotBIC <- function(data, dimensions = 20){
	require(mclust)

	fit <- prcomp(x = data,center = TRUE,scale = TRUE)
	data_embed <- fit$x[,1:dimensions];
	result <- mclustBIC(data_embed)
	
	plot(result)
}