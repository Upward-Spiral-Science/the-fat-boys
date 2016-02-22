#Driver funciton for marginal_inference. Feeds individual columns from input data to marginal_inference to conduct hypothesis tests.

conductInference <- function(data,maxK = 3, nboot = 10, power = TRUE, columns_to_analyze = 4 * c(0:23) + 1){
	
	plots <- list()
	tests_to_run <- c()
	for (i in 1:maxK - 1){
		tests_to_run[i] <- paste("k =",i,"versus k =",i + 1)
	}
	
	for (i in columns_to_analyze){
		test_result <- capture.output(marginal_inference(data[,i],maxK = maxK, nboot = nboot, power = power),file = "NUL")
		pvals <- rep(-1,maxK-1)
		test <- test_result[[1]]
		power_curve <- test_result[[2]]
		p1 <- list()
		for (j in c(1:(maxK - 1))){
			p1[[j]] <- ggplot(power_curve,aes(x = Samples)) + geom_point(aes_string(paste(i,"versus",i + 1,"H_a",sep=""))) + geom_point(aes_string(paste(i,"versus",i + 1,"H_0",sep=""))) + guides(fill=guide_legend(title="Distribution")) + xlab("Samples") + ylab("Power") + ggtitle(paste("Power for test of k =",j,"versus k =",j + 1))
			print(p[[j]])
			pvals[j] <- test[[j]]$pval
			
		}	
		pval_df <- cbind(factor(tests_to_run),pvals)
		p2 <- ggplot(pval_df,aes(x = tests_to_run, y = pval))
		
		plots <- list(plots, p1)
		
	}
	
	return(plots)
}

