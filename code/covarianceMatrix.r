#Displays the covariance matrix

covarianceMatrix <- function(data){
	require(reshape)
	require(ggplot2)
	require(naturalsort)
	
	temp <- cov(data,data)
	temp <- melt(temp)


	levels(temp[,1]) <- naturalsort(levels(temp[,1]))
	levels(temp[,2]) <- naturalsort(levels(temp[,2]))
	temp = temp[naturalorder(temp[,1]),]

	for (i in 4 * (0:(dim(data)[2] - 1)) + 1){
		loop_temp <- temp[i:(i + 3),]
		temp[i:(i + 3),] = loop_temp[naturalorder(temp[i:(i + 3),2]),]
	}
		
	base_size <- 14
	p1 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, name = "Covariance") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Covariance Matrix") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=10),axis.text.y = element_text(size = 4), legend.text=element_text(size=14), legend.title = element_text(size = 14)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

	print(p1)
}