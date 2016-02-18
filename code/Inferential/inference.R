library(data.table)
library(ggplot2)
library(gtable)
library(subspace)


#' Testing Routine for GMM 
#' 
#' @param Xdata Univariate data
#' @param maxK The upper bound on the number of components
#' @param nboot The number of bootstrap replicates to be used 
#' @return 
#' 
#' 

library(foreach)
gmm.test <- function(Xdata,maxK=3,nboot=10) {
  nsample = length(Xdata)
  
  foreach(nK=1:maxK,.errorhandling = 'remove') %do% {
    fit.null = go.fit(Xdata,k=nK)
    fit.alt  = go.fit(Xdata,k=nK+1)
    my.stat = -2 * (fit.alt$loglik - fit.null$loglik)
    boot.dist.null = foreach(itr=1:nboot,.combine='c',.errorhandling = 'remove') %do% {
      Xboot = go.sim(nsample = nsample, param = fit.null,k = nK)
      fit.null.boot = go.fit(Xboot,k=nK)
      fit.alt.boot = go.fit(Xboot,k=nK+1)
      -2 * (fit.alt.boot$loglik - fit.null.boot$loglik)
    }
    
    my.ecdf = ecdf(boot.dist.null)
    list(nK=nK, fitted=fit.null, stat=my.stat, pval= my.ecdf(my.stat))
  }
}

#' Power calculation routine for GMM 
#' 
#' @param nullparam 
#' @param altparam
#' @param alpha
#' @param maxmc
#' @return
#' 
gmm.power <- function(nsample,nullK, altK, nullparam, altparam, alpha=0.05, maxmc = 10) {
  boot.dist.null = foreach(itr=1:maxmc,.combine='c',.errorhandling = 'remove') %do% {
    Xboot = go.sim(nsample,nullparam,nullK)
    fit.null.boot = go.fit(Xboot,k = nullK)
    fit.alt.boot = go.fit(Xboot,k=altK)
    -2 * (fit.alt.boot$loglik - fit.null.boot$loglik)
  }
  
  boot.dist.alt = foreach(itr=1:maxmc,.combine='c',.errorhandling = 'remove') %do% {
    Xboot = go.sim(nsample,altparam, altK)
    fit.null.boot = go.fit(Xboot,k = nullK)
    fit.alt.boot = go.fit(Xboot,k=altK)
    -2 * (fit.alt.boot$loglik - fit.null.boot$loglik)
  }
  
  cval = quantile(boot.dist.null,alpha)
  ecdf(boot.dist.alt)(cval)
}

go.fit <- function(Xdata,k) {
  if(k> 1) {
    normalmixEM(Xdata,k=k)
  } else {
    list(mean=mean(Xdata),sd=sd(Xdata),loglik=sum(log(dnorm(Xdata,mean=mean(Xdata),sd=sd(Xdata)))))
  }
}

go.sim <- function(nsample,param,k) {
  if(k > 1) {
    rnormmix(nsample, lambda=param$lambda, mu=param$mu, sigma =param$sigma)
  } else {
    rnorm(nsample,mean=param$mean,sd=param$sd)
  }
}

#Change to relevant location of file
setwd('/Users/saltpisces/Downloads/')

#Load in file using data.tables fread()
data <- fread("synapsinR_7thA.tif.Pivots.txt.2011Features.txt")

#Convert to dataframe
data <- as.data.frame(data)


number = 1
newData <- data.frame(matrix(ncol = 96, nrow = 1119299));
for (i in 1:144) 
  {
  if (i %% 6 !=0 && i %% 6 !=5) 
    {
    newData[,number] <- data[,i];
    number = number + 1;
  }
}

set.seed(42);rand_rows = sample(1:dim(newData)[1],10000)
subsample1 <- newData[rand_rows,]

gluVsGaba <- subsample1[,13:64]


gmm.test(gluVsGaba,maxK = 3, nboot = 100)





  
