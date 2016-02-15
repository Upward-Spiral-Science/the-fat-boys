#This function plots the correlation matrix for various selections of columns from the dataset

crossCorrelation <- function(data){
	require(ggplot2)
	require(gtable)
	require(reshape)
	require(naturalsort)

	#Cross correlation for the repeats of the integrated brightness of Synap and VGlut1
	result <- cor(data[,c(1,5,9,13)])
	temp <- result
	temp <- melt(temp)


	levels(temp[,1]) <- naturalsort(levels(temp[,1]))
	levels(temp[,2]) <- naturalsort(levels(temp[,2]))
	temp = temp[naturalorder(temp[,1]),]

	for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
		loop_temp <- temp[i:(i + 3),]
		temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
	}

	base_size <- 10
		
	p1 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap for Repeats of Integrated Brightness of Synap and VGlut1") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), axis.text.y = element_text(), text = element_text(size=20), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

	#Cross correlation for all columns
	result <- cor(data[,])
	temp <- result
	temp <- melt(temp)


	levels(temp[,1]) <- naturalsort(levels(temp[,1]))
	levels(temp[,2]) <- naturalsort(levels(temp[,2]))
	temp = temp[naturalorder(temp[,1]),]

	for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
		loop_temp <- temp[i:(i + 3),]
		temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
	}

		
		
	p2 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap for All Columns") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=7),axis.text.y = element_text(size = 7), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

	#Cross correlation for integrated brightness columns only
	keep <- 4 * c(0:23) + 1
	result_integrated_brightness <- result[keep,keep]

	temp <- result_integrated_brightness
	temp <- melt(temp)


	levels(temp[,1]) <- naturalsort(levels(temp[,1]))
	levels(temp[,2]) <- naturalsort(levels(temp[,2]))
	temp = temp[naturalorder(temp[,1]),]

	for (i in 4 * (0:(dim(result)[2] - 1)) + 1){
		loop_temp <- temp[i:(i + 3),]
		temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
	}
		
	p3 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, limit = c(-1,1), name = "Pearson\ncorrelation\n") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Correlation Heatmap for Integrated Brightness Columns Only") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=16),axis.text.y = element_text(size = 16), legend.text=element_text(size=20), legend.title = element_text(size = 20)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 
	
	print(p1)
    print(p2)
    print(p3)
}