#Constructs a scree plot of the input data

screePlot <- function(data){
	require(ggplot2)
	require(gtable)
	require(LICORS)

	#PCA down to 2 dimensions
	fit <- prcomp(x = data,center = TRUE,scale = TRUE)

	#Construct scree plot
	results <- data.frame(x = c(1:length(unlist(fit[1]))), y = cumsum(unlist(fit[1])^2) /  max(cumsum(unlist(fit[1])^2)));
	p1 <- ggplot(results,aes(x,y)) + geom_line() + geom_point() + xlab("Components") + ylab("Percent Variance") + ggtitle("Scree Plot")
	print(p1)
}