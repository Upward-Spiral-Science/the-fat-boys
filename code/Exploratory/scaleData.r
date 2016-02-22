#Scales each column of the input data frame by converting to Z scores

scaleData <- function(data,center = TRUE,scale = TRUE){
	data_scaled <- scale(data, center = center,scale = scale)
	return(data_scaled)
}