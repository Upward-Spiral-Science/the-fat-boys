#Normalizes the sums of all the columns to 1

normalizeData <- function(data){
	data_normalized <- t(t(data)/colSums(data))
	return(data_normalized)
}