#This function plots the 2D kernel estimates of pairwise joint distributions of the data

jointDist <- function(data, save = FALSE){
	require(data.table)
	require(ggplot2)
	
	#Construct densities of 2D joints distributions
	for(i in c(1:dim(data)[2])){
		for(j in c(1:dim(data)[2])){
			if(i == j){next}
			else{
				df <- kde2d(data[,i], data[,j])
				df <- as.data.frame(df)
				p <- ggplot(df,aes(x = x, y = y, color = z)) + geom_point() + ylab('Y') + xlab('X') + ggtitle(paste('Joint',i,'_',j))
				if (save == TRUE){
					ggsave(paste('Density_Joint_Column_',i,'_',j,'.png'),p)
				} else{
				print(p)
				}
			}
		}
	}
}