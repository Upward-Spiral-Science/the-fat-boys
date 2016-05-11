### Synaptic Diversity
***The Fat Boys*** <br/>
May 5th, 2016

-------

**Table of Contents:**
- [Overview](./final_report.md#overview)
- [Scientific Questioning](./final_report.md#scientific-questioning)
  - [Descriptive Analysis](./final_report.md#descriptive-analysis)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis)
  - [Inferential Analysis](./final_report.md#inferential-analysis)
  - [Predictive Analysis](./final_report.md#predictive-analysis)
  - [Testing Assumptions](./final_report.md#testing-assumptions)
  - [Further Exploration and Clustering](./final_report.md#further-exploration-and-clustering)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis)
- [Methods](./final_report.md#methods)
  - [Descriptive Analysis](./final_report.md#descriptive-analysis-1)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis-1)
  - [Inferential Analysis](./final_report.md#inferential-analysis-1)
  - [Predictive Analysis](./final_report.md#predictive-analysis-1)
  - [Testing Assumptions](./final_report.md#testing-assumptions-1)
  - [Further Exploration and Clustering](./final_report.md#further-exploration-and-clustering-1)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis-1)

----------
 
### Overview
Synapses are the fundamental building blocks of neuronal communication. While there has been recent attempts to classify cell types based on genetics and imaging, there has been no attempt to classify synapses into sub-groups besides the classical distinction between excitatory and inhibitory synapses. It is well known that synaptic dysfunction can cause many different kinds of diseases such as fragile X and Rett Syndrome. The study and characterization of synapses is thus a clinically important problem that could potentially improve our understanding of diseases that affect millions of patients. In this study, we use well-validated markers and high resolution electron microscopy to tackle the question of synaptic diversity. With the unprecedented scale and resolution of our data, the study could characterize different classes of synapses and potentially yield further insights linking molecules and genes to synaptic structure and diseases.


### Scientific Questioning
Here we will discuss our analysis of this data, starting with exploratory and descriptive analysis, up to preliminary work on hypothesis testing and classification. The questions posed and their outcomes are described sequentially, with code and methods used to answer them described at the end of this report.

#### Descriptive Analysis
The natural first step when working with any data is to ask exploratory and descriptive questions about it. We have access to the KDM-SYN-100824B dataset, which is composed of 24 conjugate array tomography images of 41 brain slices from the mouse primary somatosensory cortex. Each conjugate array tomography image corresponds to a specific immunostain marker. Our collaborator has already pre-processed the images to generate two secondary sets, which we will call the “marker set” and the “pivot set.” We will primarily rely on these two sets throughout our analysis. The former set contains information about the intensity and distribution of the molecular markers within individual synapses seen in the KDM-SYN-100824B images. The latter set contains the x,y, and slice location of the relevant synapses within the former dataset. In order to determine the structure of our data, we first attempted to determine basic information: dataset size and number of invalid (i.e. Inf/Na/NaN) data points within the data. We found that the marker dataset has data for 1,119,299 subjects (synapses) and 144 features for each subject. Each 6 consecutive features, to our best guess, correspond to a single fluorescent marker, for a total of 144/6 = 24 markers. Upon further investigation, we found that only the first 4 of the 6 features for each marker were relevant for further analysis, so we discarded the last 2. Hence, our feature size was reduced to 4 * 24 = 96. The pivot dataset has data for the same 1,119,299 synapses and l 3 features. These 3 features, as stated above, correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images. There were no invalid data points within the secondary datasets. For the rest of our analysis, we will focus on the marker set. The markers are respectively 'Synap','Synap','VGlut1','VGlut1','VGlut2','Vglut3', 'psd','glur2','nmdar1','nr2b','gad','VGAT', 'PV','Gephyr','GABAR1','GABABR','CR1','5HT1A', 'NOS','TH','VACht','Synapo','tubuli','DAPI', and the four features are respectively f0 = integrated brightness f1 = local brightness f2 = distance to Center of Mass f3 = moment of inertia around synapsin maxima.

#### Exploratory Analysis

Unless otherwise stated, all analysis was done on f0, the integrated brightness feature.

We are now ready to begin exploring the dataset. For now, we focus only on the large CSV file we were given. We will worry about the raw images later. We first normalize our data by converting to z-scores. Then we check the Feature Marginals. See the figure below.

<img src="https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Marginals.png" alt="Marginals" style="width: 300px;"/>

This looks interesting. Apparently all the distributions are right-skewed and unimodal. THis is hardly what we would expect, given the fact that we know that there ae excitatory and inhibitory populations of neurons. Rather, w ewould expect at th every least bimodal distributions for the markers wich correspond to excitatory/inhibitory synapses. Even more interesting is the fact that the synapsin marginal has a high peak for low values and then has few sampels at high values.  THis is the opposite of what we would expect, as we know that synapses should have high synapsin fluorescence. This appears to be indicative of the fact that there a lot of outliers in our dataset which are not synapses. This is actually not too surprising, as the computer vision algorithm used to determine what bright patches in the raw images were synapses generates a huge number of false positives. Just for the sake of curiosity, let us look at what the data looks like via two-dimensional PCA embedding:

![PCA](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/PCA.png)

And lets also look at the scree plot:

![Scree](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Scree.png)

The PCA result does not reveal any obvious clusters, but this is hardly surprising given the huge number of outliers, which will negatively affect PCA. Also, as indicated by the scree plot, the PCA plot only retains 12% of th original data variance. Hence, the data does not appear to be well contained in a lower dimension subspace. None of these htigns are good news. What is clear, however, is that we need to find a way to deal with the outlier values. A good way of doing this is by taking the logarithm of the normalized data. Hence, outleirs will be "conmpressed" to be closer to the rest of the data. Below we show the marginals after Log scaling:

![MarginalswLog](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/MarginalsafterLog.png)

And now we should the log-normalzied data embedded into two-dimensions via tSNE.

![tSNE](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/tSNE_LogNormalized.png)

Unfortunately, this still does not suggest any obvious clusters. Maybe Bayesian Information Criterion (BIC) will be more optimistic in reagrds to presence of clusters. See the BIC figure below for various constraints on the covariance matrix.

![BIC](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/BIC.png)

Indeed, BIC suggests between 5-10 clusters within the data. This is promising. 

Now let's look at the Pearson correlation between the variables. See the figure below.

![Correlation](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Correlation.png)

As expected the two VGlut1 markers are strongly correlated. So are the two Synapsin markers. Note that, the VGlut1 marker and the Synapsin markers are also storngly correlated with each other. Interestingly, GABABR and PSD, both inhibitory markers, appear to have some correlaiton with the Synapsin and VGlut1 markers. 

Let's also look at the covariance matrix:

![Covariance](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Covariance.png)

The covariance matrix does not exhibit any obvious trends.

#### Inferential Analysis

We are now primed to further search our datasets for clusters. Optimally we would do this by using all the features and testing for the presence of clusters. Unfortunately, this is very difficult in the multivariate case. We simplify the process by only testing whether inidividual feature columns cluster into more than one cluster. Hopefully, this will give us some intuition going forward about how to look for clusters. More formally, we assumed that a feature column assumes a Gaussian mixture model with k components. We wanted to know what number of clusters/components is the most likely. Therefore, we iteratively performed statistical tests on k clusters vs k+1 clusters, where k ranges from 1 to 5. We first constructed power curves for our proposed test.

![ks12](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ks12.png)
![ks23](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ks23.png)
![ks34](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ks34.png)
![ks45](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ks45.png)
![ks56](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ks56.png)

Note that while the power curves look reasonable for k = 1 vs k = 2 and k = 2 vs k = 3, above that the power of our test is quite week. Hence, we will only consider testing for the rpesence of 1-3 clusters. The following plot shows our p-values for the VGlut1 channel.

![inference](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/inference.png)

As is shown, the test suggests that there is definately more than 1 cluster in the VGlut1 channel. It is unclear exactly how many clsuters there are because, a sshown above, for k > 3 our proposed test has weak power.

Clearly, inference testing supports k > 1. For the feature columns we examined, our inference testing results support the existence of clusters within the data.


#### Predictive Analysis

![simulated_data] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/simulated.png)

The classification accuracy on real data was based on the five tested classifiers around the low 80s. The classification accuracy on our null model of independent Gaussian-distributed features was slightly better than chance at around the low 50s. This means that the features of true data was likely not independent and highly correlated. The marginal plots of the features did look bell-curve like though, so the gaussian assumption was not out of nowhere.
Next, We need to test new assumptions and generate new distributions to sample from; we would most likely sample from Gaussians that are correlated. Also, we can calculate means and standard deviation from the real data, and then construct the parametric gaussian model based on those values to see if we can get a better null distribution.


Furthermore we want to see if each marker could be used to predict another marker. To do so for any arbitrary chosen marker, we employed all other markers as the features to build a classifier for the chosen feature. To create labels for the chosen marker, we assigned the expression instances into two groups through thresholding. Several types of classifiers were trained and tested using LOO cross-validation, and some results are shown in the figure below.

![accuracy of classifier] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/Accuracy_Classifier.png)

Given a chosen marker, rather than using all other markers as the features, we then only used a subset of the markers as the features. For instance, as a control group, we tried to predict an inhibitory neuron marker with other inhibitory neuron markers. Then we attempted to use a set of markers having known association with the chosen markers as the features. However, the initial result for this experiment was not good, as in most cases the classifiers could not predict the chosen marker better than chances. 

#### Testing Assumptions
We make the assumption that the data is independent and identically distributed (i.i.d.) 

To test for independence, we look at the correlation matrices for each feature across all the excitatory and inhibitory markers. If the data is indeed independent, then we should expect to see off diagonal terms in the correlation matrices to be close to 0. On the other hand, if the data is not independent, then we would expect to see significant deviations from 0 on the off-diagonal terms in the correlation matrices. We can see from the correlation matrices below that there are significant non-zero terms in the off-diagonal entries. Hence, we cannot conclude that the data is independent. 


![Integrated](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Integrated.png)
![Local](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Local.png)
![Center](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Center.png)
![Moment](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Moment.png)

To test for identical distribution, we assumed that the data is sampled from a Gaussian Mixture Model. We test for the optimal number of components under the GMM. We make a plot of Bayesian Information Criterior (BIC) vs number of components in the GMM. If the data is identically distributed, the optimal number of component should be very close to 1. However, what we observe is that our data has optimal number of components very close to around 2-3. Hence, we cannot conclude that the data is identically distributed. 

![Identical](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Identical.png)

#### Further Exploration and Clustering

In order to further explore the data werealized that we needed to deal with the outliers. We did this by thresholding the samples based on their value in the Synapsin_1 marginal. We threw out all the samples with a synapsin integrated brightness intensity below threshold. This is the Synapsin marginal before thresholding. 

![SynapsinMarginal](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/SynapsinMarginal.png)

This is the Synapsin marginal after thresholding.

![SynapsinMarginalPostrm](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/SynapsinMarginalPostrm.png)

Thsi process removed approximately 90% of our data. For the rest of the analysis, we use the synapsin thresholded data.

To further explore our data, we divided the synapses into two classes, inhibitory (group 1) and excitatory (group 2), by applying a threshold on their VGlut1 expression (above the mean implies excitatory and below the mean imples inhibitory). We log-normalized our data and 2D embedded it (thresholded on synapsin) via PCA. We then colored it based on whether it eas inhibitory or excitatory. See the result below:

![PCAPostrm](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Clustafterrm.png)


With the outliers removed, We can now see separation between the excitatory and inhibitory synapses.

Next, we also tried performing hierarchical clustering on the correlation matrix of integrated brightness. The results are shown in the dendrogram below. While we have to be cautious in interpreting the results, we observe that markers that can be broadly classified as inhibitory/excitatory seem to cluster/correlate well with each other. 

![Dendrogram](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Dendrogram.png)


#### Computer Vision and Colocalization Analysis

We next wanted ot look at the physical colocalization of different synapses by reanalyzing the raw image files. We first looked at the Pearson correlaiton between the various marker channels. THis is shown below for GABABR veruss the other channels. 

![ColocviaCorr](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ColocGABABviaCorr.png)

As seen from the above graphs, hotspots from GABABR correlated perfectly with itself (as a sanity check), followed by GABAR1 and VGlut1. It is unclear why it correlates so well with VGlut1, as GABABR is an inhibitory synapse marker while VGlut1 is an excitatory synapse marker.

The issue with the above procedure is that it only does pixel to pixel comparisons, and hence cannot account for point which do not overlap perfectly but are nonetheless close together. Hence, it is unclear whether the above is truly testing colocalization. Instead, an object based approach is better. The way this works is that we first locate the (x,y,z) coordinates of the synapses in each channel. Then we compute the median minimum distance for the synapses in channel 1 to the synapses in channel 2. The gives us a measure of colocalization. Finding synapses is difficult to even visually. Several methoids exist, foremost among them being the undecimated wavelet transform for point detection. Due to time constraints we did this via a simplified algorithm: we used non-maximal supression, thresholding via the image mean, to find hotspots in the images, which roughly correlates to synapse location. In order to find nearest-neighbors assumed that the thickness of each slice was 100 nm and the size of eahc pixel was 100 nm x 100 nm (therefore each voxel was 100 nm x 100 nm x 70 nm) and constructed a k-d tree. Below we have plotted the median minimal distance for GABABR versus the other markers. This plot confirmed the trend that GABABR correlated really well with the VGlut markers compared to other markers.  

![ColocviaMed](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/ColocGABABviaMedian.png)

We next performed the aabove analysis for all markers, not just GABABR. Please see the plot below:

![ColocviaAll](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/MatrixColocwDAPI.png)

Note that according to this graph, the other channels tend to be quite far from the DAPI channel whiel the DAPI channel is quite close to the other synapses. This makes intuitive sense, as DAPI is localized within cell nuclei which are sparse in the images while th eother markers are spread densely across the entire image plane. Below we highlight the othe rmaekrs by giving the same marker with DAPI removed:

![ColocDAPI](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/MatrixColoc.png)

Again we see that GABABR, which is conventionally considered an inhibitory marker, seems to colocalize strongly with the excitatory markers. Similarly, Gephyr seems to colocalize strongly will all of the markers, something which cannot easily be explained. Additionally, VGlut2 and Glur2 colocalize extremely strongly. All of these are interesting results which warrant future work which is beyond the scope of this class.

Next, we tried to evaluate for a given hotspot on the raw images of a marker, the distribution of the neighboring hotspots on the images of another marker. See the image below. We have conducted this analysis for all 24 markers, but we are examining the results for the GABAR hotspots over here. As a sanity check, all hotspots from the GABAR-1 images have at least one neighbor when compared to the same images (the count came from the hotspot itself).  However, for most hotspots on the GABAR-1 images, there are no neighboring hotspots on the images for other markers, even when we were comparing GABAR-1 and GABAR-2. Nonetheless, when compared to the images from Glur-2 and GABABR1-2 markers, there were some hotspots on the GBAR-1 channel having 2 neighboring peaks on those images. Glur-2 is an excitatory marker while GABAR is an inhibitory marker, thus this observation is worth investigating. 

![Distirbution] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/2_new.png)
![Distirbution] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/1.png)
![Distirbution] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/3_new.png)
![Distirbution] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/4_new.png)

#### Next Steps
The conducted exploratory analysis has raised several new questions which will need to be addressed in future work. First, judging from the feature marginal distributions, it appears that over half of the synapses in the marker file are outliers. This stems from the fact that there are a large number of false positives in the original synapse detection algorithm which was run on the raw images. This means that any conclusions we draw from the primary marker file are immediately questionable, as the majority of robust methods only function when less than half the samples are outliers. We have attemtped to deal with this by log-normalizing the data before conducting any analysis. We have also implemented robust methods of estimating localtion and scatter and avoided using inferential tests which are sensitive to outliers. Nonetheless, this is likely a half measure. What needs to be done in future work is that the original images need to be re-analyzed for synapses via an algorithm that generates fewer false positives at the expense of more false negatives. Next, our work suggests that the synapses likely do cluster, although we have been unable to find them due to the large quantity of outliers. Our work needs to be redone once a dataset with less outliers is generated. Finally, our work shows that markers which we explect to colocalize and cluster strongly with other markers do not necessarily do so. For example, the GABAB receptor, which is conventionally considered an inhibitory marker, seems to colocalize strongly with the excitatory markers. Similarly, Gephyr seems to colocalize strongly will all of the markers, something which cannot easily be explained. Additionally, VGlut2 and Glur2 colocalize extremely strongly. As far as we know, none of these phenomena have been describe din the literature and, if they are correct, they are incredibly important to the field of neuroscience. Undoubtedly, there are even more discoveries to be made from this dataset.

### Methods
Each of the questions required code and (for the inferential, predictive, and assumption checking portions) mathematical theory. This is all explained in detail in each file, tabulated below. Here, we will discuss the methods used in each of these sections, rationalize decision made, and discuss alternatives that could have been performed instead.

| Question Type | Code |
|---------------|------|
| Descriptive | [**``./code/Assignment3_Abridged.ipynb``**](./code/Assignment3_Abridged.ipynb) |
| Exploratory | [**``./code/Assignment3_Abridged.ipynb``**](./code/Assignment3_Abridged.ipynb) |
| Inferential | [**``./code/Assignment4.ipynb``**](./code/Assignment4.ipynb) |
| Predictive  | [**``./code/Assignment5_Classification_FatBoys.ipynb``**](./code/Assignment5_Classification_FatBoys.ipynb) |
| Testing Assumptions | [**``./code/Assignment6_Checking_Assumptions_Fatboys.ipynb``**](./code/Assignment6_Checking_Assumptions_Fatboys.ipynb) |
| Further Clustering | [**``./code/Ivan_Report.ipynb``**](./code/Ivan_Report.ipynb) |
| Previous Work and Literature Search| [**``./Edric-Report-LiteratureSearch.md``**](./docs/Edric-Report-LiteratureSearch.md)|
| Computer Vision and Colocalization Analysis | [**``./code/Colocalization/Synapse_Vis.m``**](./code/Colocalization/Synapse_Vis.m),[**``./code/IvanReport_4_27.ipynb``**](./code/IvanReport_4_27.ipynb), [**``./code/khuang28_4_30_Hotspots_Identificaiton``**](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/code/khuang28_4_30_Hotspots_Identificaiton.m),[**``./code/khuang28visualization043016.pdf``**](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/code/khuang28visualization043016.pdf), [**``./code/khuang28hotspotcv_4_28``**](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/code/khuang28_4_20_Hotspots_Identificaiton.m), [**``synapse_filter``**](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/docs/Team%20Fatboys%205%20Updates%20Report%20Part%202.ipynb) |


#### Descriptive Analysis
Our data is off a relatively standard format, so the descriptive analysis was rather straightforward. We simply examined the number of rows and columns in the two datasets, checked them from invalid data values, and then contacted our collaborator to understand what the individual rows/features correspond to.

#### Exploratory Analysis
We asked the following questions: 

1) What are the mean and standard deviations of the individual feature columns in the dataset? 

2) What are the marginal distributions of the features in the first dataset? 

3) Which features have the greatest variability among the subjects? Which have the least?

4) Does the data form any clear clusters?

5) How many principal components are needed to describe the data well?

6) Does the covariance matrix exhibit any obvious structure?

The answer to (1) was a straightforward computation. We completed (2) by constructing a kernel density estimate from the individual feature columns. (3) was done by examining the previously constructed marginals. (4) was done by using PCA/k-means and t-SNE. (5) was done by constructing a scree plot. (6) was done through visual inspection of the covariance matrix.

#### Inferential Analysis
Here we conducted hypothesis testing on specific feature columns of our data to check whether it formed clusters. We assumed that a feature column assumes a Gaussian mixture model with k components. We wanted to know what number of clusters/components is the most likely. Therefore, we iteratively performed statistical tests on k clusters vs k+1 clusters, where k ranges from 1 to 4. In other words:

F0∼GMM(k)

FA∼GMM(k+1)

H0:n=k

HA:n=k+1

Our test statistic was: 

X=−2(log(λ))

Here, the λ is the likelihood ratio between the alternative and the null, i.e.

λ=likelihood_A* / likelihood_0*

The * indicates that these likelihoods are optimal. In our implementation we used an EM approach to calculate the optimal λ using the normalmixEM method implemented within the mixtools R package. We used bootstrapping to sample from the null and alternative distributions.


#### Predictive Analysis
Let y = 0 denote that a particular synapse is glutamatergic(high brightness of VGlut1) and y = 1 denote that a particular synapse is not glutamatergic(low brightness of VGlut1). This would serve as our labels for classification. We set the threshold to be the mean of the local brightness of VGlut1. For our null generative model that we sampled from, we assumed that all the features (local brightness of other markers) as well as the VGlut1 brightness that we were looking at were sampled from Gaussian distributions. Each feature was sampled independently from a Gaussian with a certain mean and variance. In our code below, we generated the mean and variance randomly. We further assumed that for each feature Xi∼N(μi,σ2i), for the labels Y∼N(μ,σ2), where each μi,σi are randomly sampled from a uniform distribution between 0 and 1. At the end of the day we sought to define a classifier S:X→Y such that the value ∑ni=1θ(S(Xi)≠Yi) is minimized where θ is the indicator function.

The following were the classifiers that we used ( listed with the associated parameters): 

linear discriminant analysis with no parameters

quadratic discriminant analysis with no parameters

support vector machine with penalty parameters set to 0.5

k-nearest neighbours with number of neighbors set to 3

random forest.


#### Testing Assumptions
We computed the correlation on log-normalized features across different excitatory and inhibitory markers. We observe look at the off-diagonal values of the correlation matrix. We assumed data sampled from a GMM with n components compute BIC for number of components ranging from 1 to 10.

#### Further Exploration and Clustering

After normalizing the data, we also log-transformed it to make our analysis more robust to outliers and noise. We also thresholded away all samples with synapsin intensity below threshold. Only 10% of the samples remained after this.

We generated pseudo-labels for the samples by examining their integrated intensity in the VGlut1 channels. For intensities above the mean, we labeled the sample as excitatory (group 1). THose below the mean were called inhibitory (group 2). 

We them performed 2D embedding via PCA on this data. We color group 1 and 2 with blue and red, and we observe that the resulting graph shows obvious and clear delineation between the two groups. 

We further performed hierarchical clustering on the correlation matrix of the integrated brightness feature. 


#### Computer Vision and Colocalization Analysis

We first investigated colocalization by computing the Pearson correlation coefficient between the raw images of different channels. Our results are described above.

The issue with the above procedure is that it only does pixel to pixel comparisons, and hence cannot account for point which do not overlap perfectly but are nonetheless close together. Hence, it is unclear whether the above is truly testing colocalization. Instead, an object based approuch is better. The way this works is that we first locate the (x,y,z) coordinates of the synapses in each channel. Then we compute the median minimum distance for the synapses in channel 1 to the synapses in channel 2. The gives us a measure of colocalization. Finding synapses is difficult to even visually. Several methods exist, foremost among them being the undecimated wavelet transform for point detection, Due to time constraints we did this via a simplified algorithm: we used non-maximal supression, thresholding via the image mean, to find hotspots in the images, which roughly correlates to synapse location. We visually confirmed the later fact by checking that detected maxima cooresponded to synapses. The main fault in this algorithm is that sometimes it detected a single synapse as two or more hotspots.

In order to find nearest-neighbors assumed that the thickness of each slice was 100 nm and the size of each pixel was 100 nm x 100 nm (therefore each voxel was 100 nm x 100 nm x 70 nm) and constructed a k-d tree. Below we have plotted the median minimal distance for GABABR versus the other markers. This plot confirmed the trend that GABABR correlated really well with the VGlut markers compared to other markers.

In addition, we wanted to know, for a given hotspot on the raw images of channel 1, the distribution of the neighboring hotspots on the images of other channels. For each stack of images we first hotspots via the non-max supression algorithm described above. We then computed for any given pair of channel 1 and 2, the distribution of the hotspots in channel 1 within 1.5 pixels of any given hostpots in channel 2 after superimposeing the two channels on top of each other. 

* We also tried out other methods for denoising the image, such as unsharp masking, de-convolution, and a series of edge-based threshold filtering. The results produced from those methods were not so informative and thus were not included in the final report
 
