#This function plots the marginals of the input dataset, either as a histogram or as a density plot. 

plotMarginals <- function(data, save = FALSE, type = c("hist","density")){
	require(data.table)
	require(ggplot2)
	
	#Construct densities or histograms of marginals, depending on which one was requested
	if (type == "density") {
		for (i in c(1:dim(data)[2])) {
			df <- as.data.frame(cbind(c(1:dim(data)[1]), data[,i]))
			p <- ggplot(df,aes(V2)) + geom_density() + ylab('Density') + xlab('Value') + ggtitle(paste('Column',i))
			if (save == TRUE){
				ggsave(paste('Density_Marginal_Column_',i,'.png'),p)
			} else{
				print(p)
			}
		}
	} else if (type == "hist"){
		for (i in c(1:dim(data)[2])) {
			df <- as.data.frame(cbind(c(1:dim(data)[1]), data[,i]))
			p <- ggplot(df,aes(V2)) + geom_histogram() + ylab('Density') + xlab('Value') + ggtitle(paste('Column',i))
			if (save == TRUE){
				ggsave(ggsave(paste('Hist_Marginal_Column_',i,'.png'),p))
			} else{
				print(p)
			}
		}
	}
}