#Subsamples 10000 rows from the original data set for easier analysis

subsampleRows <- function(data){
	#Subsample some 10000 rows for further analysis. Set seed for reproducibility.
	set.seed(42);rand_rows = sample(1:dim(data)[1],10000)
	subsample <- data[rand_rows,]
	return(subsample)
}