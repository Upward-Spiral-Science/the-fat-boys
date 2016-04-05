Kevin Huang:
  1) Coming up with two other metrics to evaulaute the validity of each called synapse on the raw synapsin channel image
  2) Quantify and assign a p-value to each called synapse based on the metric above
  3) Finalize on a metric that effectively discrimately elimate the noise in the synapsins channel 
  4) Try out DBscan clustering on the new data
  5) Use ARI and MNI to evaluate the clustering results
  
Ivan Kuznetsov:
  1) Use ARI to evaluate marker clustering results presented in last weeks results
  2) Generate pseudo-labels for excitoary/inhbiitory ppre/post-synaptic via the methid presented in last weeks results 
  3) Implement RF clustering
  4) Try rank-based clustering methods for marker clustering
  5) Try rank-based clustering methods for synapse clustering

Edric Tam:
1. Per Jovo's suggestion, we should come up with quantitative methods to evaluate the clustering rather than just doing it visually. 
Hence, as suggested by Hal Duame III's paper in JMLR, we could use the ARI, the Precision/Recall/F-score, the  Cluster Edit Distance and Normalized Edit Score, as well
as the Variation of Information.
2. Per Jovo's suggestion, we should make sure that the 2 synap markers and the 2 VGlut1 markers are strongly correlated. We can make sure that 
this is the case by inspecting the correlation matrix, and doing a scatterplot of the data points. 
3. We should perform the same analysis as before on features 3 and 4 in addition to just the integrated and local brightness. 
4. We should perform the same analysis as before on additional markers in addition to just the excitatory and inhibitory ones. For example, 
we should take into account 5HT, NOS, CR1 etc. 
5. We should explore the computer vision part more with the MATLAB code that our team has written. In paerticular, we observed holes in the 
image that we suspect are cell bodies. To confirm that, we can "digitally counterstain" with DAPI. 
