library(data.table)
library(ggplot2)
library(gtable)
library(LICORS)
library(reshape)
library(naturalsort)

labels = c('Synap_1', 'Synap_2', 'VGlut1_1', 'VGlut1_2', 'VGlut2', 'VGlut3', 'PSD', 'Glur2', 'NDAR1', 'NR2B', 'GAD', 'VGAT', 'PV',
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

#Cross correlation for the repeats of the integrated brightness of Synap and VGlut1
result <- cor(subsample1[,c(1,7,13,19)])
temp <- result
#temp[lower.tri(temp)] <- NA
temp <- melt(temp)


levels(temp[,1]) <- naturalsort(levels(temp[,1]))
levels(temp[,2]) <- naturalsort(levels(temp[,2]))
temp = temp[naturalorder(temp[,1]),]
#temp = temp[naturalorder(temp[,2]),]

for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
	loop_temp <- temp[i:(i + 3),]
	temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
}

#temp <- na.omit(temp)

	
base_size <- 10
	
p1 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), axis.text.y = element_text(), text = element_text(size=20), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

#Cross correlation for all columns
result <- cor(subsample1[,])
temp <- result
#temp[lower.tri(temp)] <- NA
temp <- melt(temp)


levels(temp[,1]) <- naturalsort(levels(temp[,1]))
levels(temp[,2]) <- naturalsort(levels(temp[,2]))
temp = temp[naturalorder(temp[,1]),]

for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
	loop_temp <- temp[i:(i + 3),]
	temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
}

	
	
p2 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=7),axis.text.y = element_text(size = 7), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

#Find outliers in integrated brightness
keep <- 6 * c(0:23) + 1
result_integrated_brightness <- result[keep,keep]
rownames(result_integrated_brightness) <- labels
colnames(result_integrated_brightness) <- labels

temp <- result_integrated_brightness
#temp[lower.tri(temp)] <- NA
temp <- melt(temp)


levels(temp[,1]) <- naturalsort(levels(temp[,1]))
levels(temp[,2]) <- naturalsort(levels(temp[,2]))
temp = temp[naturalorder(temp[,1]),]

for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
	loop_temp <- temp[i:(i + 3),]
	temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
}



	
	
p3 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=16),axis.text.y = element_text(size = 16), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 
