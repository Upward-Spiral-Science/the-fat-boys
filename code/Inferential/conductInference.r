#Driver funciton for marginal_inference. Feeds individual columns from input data to marginal_inference to conduct hypothesis tests.

conductInference <- function(data,maxK = 3, nboot = 10, power = TRUE, columns_to_analyze = 4 * c(0:23) + 1){
	require(ggplot2)
	require(reshape)
	
	plots <- list()
	tests_to_run <- c()
	for (i in 1:maxK - 1){
		tests_to_run[i] <- paste("k =",i,"versus k =",i + 1)
	}
	
	for (i in columns_to_analyze){
		capture.output(test_result <- marginal_inference(data[,i],maxK = maxK, nboot = nboot, power = power),file = "NUL")
		pvals <- rep(-1,maxK-1)
		test <- test_result[[1]]
		power_curve <- test_result[[2]]
		p1 <- list()
		colnames(power_curve)[2:length(colnames(power_curve))] <- paste("c",c(2:length(power_curve)),sep="")
		for (j in c(1:(maxK - 1))){
			df <- power_curve[,c(1,2 * j, 2 * j + 1)]
			df <- melt(df,"Samples")
			p1[[j]] <- ggplot(df,aes_string(x = "Samples", y = "value", color = "variable")) + geom_point() + xlab("Samples") + ylab("Power") + ggtitle(paste("Power for test of k =",j,"versus k =",j + 1)) + scale_colour_manual("Distribution",values = c("blue","red"),labels=c("Alt", "Null"))
			print(p1[[j]])
			pvals[j] <- test[[j]]$pval		
		}	
		pval_df <- as.data.frame(cbind(tests_to_run,pvals))
		p2 <- ggplot(pval_df,aes(x = tests_to_run, y = pvals)) + geom_point() + xlab("Test") + ylab("P-value") + ggtitle("Inference Testing Results")
		print(p2)
		plots <- list(plots, p1,p2)
		
	}
	
	return(plots)
}

