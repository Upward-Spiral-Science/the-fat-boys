#Scales each column of the input data frame by converting to Z scores and optionally log scaling the data

scaleData <- function(data,center = TRUE,scale = TRUE, log = TRUE){
	data_scaled <- scale(data, center = center,scale = scale)
	data_scaled <- log(data_scaled + 1) / log(10)
	return(data_scaled)
}