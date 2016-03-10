library(mclust)

#1 at a time
vals = c(0:23)
vals = vals * 4 + 1

error_mat <- matrix(0,24,24)

for(i in c(1:24)){
	print(i)
	for(j in c(1:24)){
		if(i == j){error_mat[i,j] = 0}
		else{
			df <- c(data[,vals[i]],data[,vals[j]])
			class <- c(rep(0,length(data[,vals[i]])),rep(1,length(data[,j])))
			results_mclust <- MclustDA(df,class, modelType =  'EDDA', modelNames = 'E')
			error <- cv.MclustDA(results_mclust, nfold = 4, verbose = FALSE)
			error_mat[i,j] <- error$error
		}
	}
}

error_mat_df <- as.data.frame(error_mat)

colnames(error_mat_df) <- paste('C',vals)
row.names(error_mat_df) <- paste('R',vals)

temp <- melt(error_mat_df)

base_size <- 14
p1 <- ggplot(temp, aes(X2, X1, fill = value)) + geom_tile(alpha = 0.5, colour = "white") + scale_fill_gradient2(low = "steelblue", high = "red", mid = "violet", midpoint = 0, name = "Covariance") + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + ggtitle("Covariance Matrix") + theme(axis.ticks = element_blank(), plot.title = element_text(vjust=2), axis.text.x = element_text(angle=90, vjust = 0.6), text = element_text(size=4),axis.text.y = element_text(size = 4), legend.text=element_text(size=14), legend.title = element_text(size = 14)) + guides(fill = guide_colorbar(barwidth = 2, barheight = 10, title.position = "top", title.vjust = 10)) 

#Nothing good

#2 at a time
#24c2 = 24 * 23 / 2 = 276

vals2 <- combn(vals,2)
error_mat2 <- matrix(0,276,276)
data2 <- data[1:1000,]

for(i in c(1:276)){
	print(i)
	for(j in c(1:276)){
		if(i == j){error_mat2[i,j] = 1}
		else{
			df <- rbind(data2[,vals2[,i]],data2[,vals2[,j]])
			class <- c(rep(0,length(data2[,vals2[i]])),rep(1,length(data2[,vals2[j]])))
			results_mclust <- MclustDA(df,class, modelType =  'EDDA', modelNames = 'EEE')
			error <- cv.MclustDA(results_mclust, nfold = 4, verbose = FALSE)
			error_mat2[i,j] <- error$error
		}
	}
}

#33759 [87,123] 47007 [87, 171] 73227 [87, 266] are < 0.3
#87 is [17 21] or markers[5 6]
#123 is [21 93] or markers [6 24]
#171 is [33 93] or markers [9 24]
#266 is [73 93] or markers [19 24]

#Try something else
first_set = c(17)
second_set = c(93)

all_index = c(first_set,second_set)

subsample2 <- data[,all_index]



#PCA all data down to 2 dimensions
#fit <- prcomp(x = subsample2,center = TRUE,scale = TRUE)
data_embed <- subsample2#fit$x[,1:2];

#to_remove <- unique(c(which(data_embed[,1] > quantile(data_embed[,1], c(.90))),which(data_embed[,2] > quantile(data_embed[,2], c(.90))),which(data_embed[,1] < quantile(data_embed[,1], c(.10))),which(data_embed[,2] < quantile(data_embed[,2], c(.10)))))
#data_embed <- data_embed[-to_remove,]
data_embed <- log(data_embed)

colnames(data_embed) <- c("PC1","PC2")

#Plot using ggplot2
embed_graph <- as.data.frame(data_embed);

p1 <- ggplot(embed_graph,aes(PC1,PC2)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Integrated Brightness vs GABAR1 Integrated Brightness')

#Conduct Kmeans
cluster <- kmeanspp(subsample2, k = 2)
clust_graph <- as.data.frame(cbind(data_embed,cluster$cluster))
	
colnames(clust_graph)[3] <- 'Clusters'
	

p2 <- ggplot(clust_graph,aes(PC1,PC2,color = Clusters)) + geom_point(alpha = 0.75)  + theme(legend.text=element_text(size=14), legend.title = element_text(size = 20),panel.background = element_blank(), plot.background = element_blank()) + ggtitle('VGlut1 Int Bright vs GABAR1 Int Bright with 2 Clusters')

#Conduct Tsne
#Subsample 1000 rows
set.seed(42);rand_rows = sample(1:dim(data)[1],1000)
subsample3 <- data[rand_rows,]

ecb = function(x,y){ plot(x,t='n'); text(x) }
tsne_data <- tsne(subsample3, perplexity=50,epoch = 100)

tsne_embed <- tsne_data
colnames(tsne_embed) <- c('E1','E2')

df <- as.data.frame(cbind(subsample3,tsne_embed))

p3 <- ggplot(df, aes(E1, E2)) + geom_point(color = 'blue',alpha = 0.75) + theme(panel.background = element_blank(), plot.background = element_blank(),panel.grid.major = element_blank(),panel.grid.minor = element_blank(),text = element_text(size = 16)) + ggtitle(paste('t-SNE of Normalized Data')) + xlab('Dimension 1')+ ylab('Dimension 2')

#Log normalize
data_new <- log(data)
temp <- rowSums(data_new)
index <- which(temp == -Inf)
data_new <- data_new[-index,]

data_new <- normalizeData(data_new)

set.seed(42);rand_rows = sample(1:dim(data_new)[1],1000)
subsample3 <- data_new[rand_rows,]

ecb = function(x,y){ plot(x,t='n'); text(x) }
tsne_data <- tsne(subsample3, perplexity=50,epoch = 100)

tsne_embed <- tsne_data
colnames(tsne_embed) <- c('E1','E2')

df_new <- as.data.frame(cbind(subsample3,tsne_embed))

p4 <- ggplot(df_new, aes(E1, E2)) + geom_point(color = 'blue',alpha = 0.75) + theme(panel.background = element_blank(), plot.background = element_blank(),panel.grid.major = element_blank(),panel.grid.minor = element_blank(),text = element_text(size = 16)) + ggtitle(paste('t-SNE of Log-Normalized Data')) + xlab('Dimension 1')+ ylab('Dimension 2')