library(data.table)
library(ggplot2)

#Change to relevant location of file
setwd('C:/Users/iakuznet/Desktop/the-fat-boys/data')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")

#Convert to dataframe
data <- as.data.frame(data)



for (i in c(1:144)) {
	df <- as.data.frame(x = data[,i],y = data[,i])
	p <- ggplot(df,aes(x)) + geom_density()
}