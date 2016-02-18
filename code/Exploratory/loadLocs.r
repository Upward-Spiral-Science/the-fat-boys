#This code loads the synapse locations

loadLocs <- function(){
	require(data.table)
	
	#Change to relevant location of file
	filepath = 'C:/Users/iakuznet/Desktop/the-fat-boys/data'
	setwd(filepath)

	#Load in file using data.tables fread()
	data_locs <- fread("synapsinR_7thA.tif.Pivots.txt")

	#Convert to dataframe
	data_locs <- as.data.frame(data_locs)
	
	return(data_locs)
}
