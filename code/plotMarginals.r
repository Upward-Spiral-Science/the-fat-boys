library(data.table)
library(ggplot2)

#Change to relevant location of file
setwd('C:/Users/iakuznet/Desktop/the-fat-boys/data')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")

#Convert to dataframe
data <- as.data.frame(data)



for (i in c(1:144)) {
	df <- as.data.frame(cbind(c(1:dim(data)[1]), data[,i]))
	p <- ggplot(df,aes(V2)) + geom_density() + ylab('Density') + xlab('Value') + ggtitle(paste('Column',i))
	ggsave(paste('Density_Marginal_Column_',i,'.png'),p)
}

for (i in c(1:144)) {
	df <- as.data.frame(cbind(c(1:dim(data)[1]), data[,i]))
	p <- ggplot(df,aes(V2)) + geom_histogram() + ylab('Density') + xlab('Value') + ggtitle(paste('Column',i))
	ggsave(paste('Hist_Marginal_Column_',i,'.png'),p)
}