### Synaptic Diversity
***The Fat Boys*** <br/>
May 4th, 2016

-------

**Table of Contents:**
- [Overview](./final_report.md#overview)
- [Scientific Questioning](./final_report.md#scientific-questioning)
  - [Descriptive Analysis](./final_report.md#descriptive-analysis)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis)
  - [Inferential Analysis](./final_report.md#inferential-analysis)
  - [Predictive Analysis](./final_report.md#predictive-analysis)
  - [Testing Assumptions](./final_report.md#testing-assumptions)
  - [Further Exploration and Clustering](./final_report.md#clustering)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis)
- [Methods](./final_report.md#methods)
  - [Descriptive Analysis](./final_report.md#descriptive-analysis-1)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis-1)
  - [Inferential Analysis](./final_report.md#inferential-analysis-1)
  - [Predictive Analysis](./final_report.md#predictive-analysis-1)
  - [Testing Assumptions](./final_report.md#testing-assumptions-1)
  - [Further Exploration and Clustering](./final_report.md#clustering-1)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis-1)

----------

### Overview
Synapses are the fundamental building blocks of neuronal communication. While there has been recent attempts to classify cell types based on genetics and imaging, there has been no attempt to classify synapses into sub-groups besides the classical distinction between excitatory and inhibitory synapses. It is well known that synaptic dysfunction can cause many different kinds of diseases such as fragile X and Rett Syndrome. The study and characterization of synapses is thus a clinically important problem that could potentially improve our understanding of diseases that affect millions of patients. In this study, we use well-validated markers and high resolution electron microscopy to tackle the question of synaptic diversity. With the unprecedented scale and resolution of our data, the study could characterize different classes of synapses and potentially yield further insights linking molecules and genes to synaptic structure and diseases.


### Scientific Questioning
Here we will discuss our analysis of this data, starting with exploratory and descriptive analysis, up to preliminary work on hypothesis testing and classification. The questions posed and their outcomes are described sequentially, with code and methods used to answer them described at the end of this report.

#### Descriptive Analysis
The natural first step when working with any data is to ask exploratory and descriptive questions about it. We have access to the KDM-SYN-100824B dataset, which is composed of 24 conjugate array tomography images of 41 brain slices from the mouse primary somatosensory cortex. Each conjugate array tomography image corresponds to a specific immunostain marker. Our collaborator has already pre-processed the images to generate two secondary sets, which we will call the “marker set” and the “pivot set.” We will primarily rely on these two sets throughout our analysis. The former set contains information about the intensity and distribution of the molecular markers within individual synapses seen in the KDM-SYN-100824B images. The latter set contains the x,y, and slice location of the relevant synapses within the former dataset. In order to determine the structure of our data, we first attempted to determine basic information: dataset size and number of invalid (i.e. Inf/Na/NaN) data points within the data. We found that the marker dataset has data for 1,119,299 subjects (synapses) and 144 features for each subject. Each 6 consecutive features, to our best guess, correspond to a single fluorescent marker, for a total of 144/6 = 24 markers. Upon further investigation, we found that only the first 4 of the 6 features for each marker were relevant for further analysis, so we discarded the last 2. Hence, our feature size was reduced to 4 * 24 = 96. The pivot dataset has data for the same 1,119,299 synapses and l 3 features. These 3 features, as stated above, correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images. There were no invalid data points within the secondary datasets. For the rest of our analysis, we will focus on the marker set. The markers are respectively 'Synap','Synap','VGlut1','VGlut1','VGlut2','Vglut3', 'psd','glur2','nmdar1','nr2b','gad','VGAT', 'PV','Gephyr','GABAR1','GABABR','CR1','5HT1A', 'NOS','TH','VACht','Synapo','tubuli','DAPI', and the four features are respectively f0 = integrated brightness f1 = local brightness f2 = distance to Center of Mass f3 = moment of inertia around synapsin maxima.

#### Exploratory Analysis

We are now ready to begin exploring the dataset. For now, we focus only on the large CSV file we were given. We will worry about the raw images later. We first normalize our data by converting to z-scores. Then we check the Feature Marginals. See the figure below.

![Marginals](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Marginals.png)

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

Indeed, BIC suggests between 5-10 clusters within the data. 

![Correlation](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Correlation.png)
![Covariance](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Covariance.png)

#### Inferential Analysis

We are now primed to further search our datasets for clusters. We proceeded by using inference analysis to determine how many clusters individual feature columns contained. More formally, we assumed that a feature column assumes a Gaussian mixture model with k components. We wanted to know what number of clusters/components is the most likely. Therefore, we iteratively performed statistical tests on k clusters vs k+1 clusters, where k ranges from 1 to 4. For VGlut1 we achieved the following results:

Clearly, for VGlut1, inference testing supports k > 1. For the feature columns we examined, our inference testing results support the existence of clusters within the data.


#### Predictive Analysis

![simulated_data] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/simulated.png)

The classification accuracy on real data was based on the five tested classifiers around the low 80s. The classification accuracy on our null model of independent Gaussian-distributed features was slightly better than chance at around the low 50s. This means that the features of true data was likely not independent and highly correlated. The marginal plots of the features did look bell-curve like though, so the gaussian assumption was not out of nowhere.
Next, We need to test new assumptions and generate new distributions to sample from; we would most likely sample from Gaussians that are correlated. Also, we can calculate means and standard deviation from the real data, and then construct the parametric gaussian model based on those values to see if we can get a better null distribution.

Furthermore we want to see if each marker could be used to predict another marker. To do so for any arbitrary chosen marker, we employed all other markers as the features to build a classifier for the chosen feature. To create labels for the chosen marker, we assigned the expression instances into two groups through thresholding. Several types of classifiers were trained and tested using LOO cross-validation, and some results are shown in the figure below.

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

![MarginalsSynapsin](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/SynapsinMarginal.png)

![MarginalsSynapsinPostrm](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/SynapsinMarginalPostrm.png)

![PCAPostrm](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Clustafterrm.png)


![Dendrogram](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/Dendrogram.png)


#### Computer Vision and Colocalization Analysis

![ColocviaCorr](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/ColocGABABviaCorr.png)

We wanted to look at the Pearson correlation between the hotspots from raw images of different markers. As seen from the above graphs, hotspots from GABAR correlated perfectly with itself (as a sanity check), followed by GABAR-1 and Vglut-1. We were confused to see that Vlug-1 correlated the second best with Vglut-1 because the former is a inhibitory synapse marker, and the later is a excitatory synapse marker. 

![ColocviaMed](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/FinalReport/ColocGABABviaMedian.png)

We directly plotted the median minimal distance between a hotspot on the raw images for GABAR and the corresponding a correpsonding hotspot on the raw images for other markers. This plot confirmed the trend that GABAR correlated really well with the Vlut markers compared to other markers. 

 
![ColocviaAll](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/MatrixColocwDAPI.png)
![ColocDAPI](https://raw.githubusercontent.com/Upward-Spiral-Science/the-fat-boys/master/figs/FinalReport/MatrixColoc.png)

![Distirbution] (https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/gaba_neighbor.png)

We tried to evaluate for a given hotspot on the raw images of a marker, the distribution of the neighboring hotspots on the images of another marker. We have conducted this analysis for all 24 markers, but we are examining the results for the GABAR hotspots over here. As a sanity check, all hotspots from the GABAR-1 images have at least one neighbor when compared to the same images (the count came from the hotspot itself).  However, for most hotspots on the GABAR-1 images, there are no neighboring hotspots on the images for other markers, even when we were comparing GABAR-1 and GABAR-2. Nonetheless, when compared to the images from Glur-2 and GABABR1-2 markers, there were some hotspots on the GBAR-1 channel having 2 neighboring peaks on those images. Glur-2 is an excitatory marker while GABAR is an inhibitory marker, thus this observation is worth investigating. 

#### Next Steps
The conducted exploratory analysis has raised several new questions which will need to be addressed in future work. First, judging from the feature marginal distributions, it appears that over half of the synapses in the marker file are outliers. This stems from the fact that there are a large number of false positives in the original synapse detection algorithm which was run on the raw images. This means that any conclusions we draw from the primary marker file are immediately questionable, as the majority of robust methods only function when less than half the samples are outliers. We have attemtped to deal with this by log-normalizing the data before conducting any analysis. We have also implemented robust methods of estimating localtion and scatter and avoided using inferential tests which are sensitive to outliers. Nonetheless, this is likely a half measure. What needs to be done in future work is that the original images need to be re-analyzed for synapses via an algorithm that generates fewer false positives at the expense of more false negatives. Next, our work suggests that the synapses likely do cluster, although we have been unable to find them due to the large quantity of outliers. Our work needs to be redone once a dataset with less outliers is generated. Finally, our work shows that markers which we explect to colocalize and cluster strongly with other markers do not necessarily do so. For example, the GABAB receptor, which is conventionally considered an inhibitory marker, seems to colocalize strongly with the excitatory markers. Similarly, Gephyr seems to colocalize strongly will all of the markers, something which cannot easily be explained. Additionally, VGlut2 and Glur2 colocalize extremely strongly. As far as we know, none of these phenomena have been describe din the literature and, if they are correct, they are incredibly important to the field of neuroscience. Undoubtedly, there are even more discoveries to be made from this dataset.

### Methods
Each of the questions required code and (for the inferential, predictive, and assumption checking portions) mathematical theory. This is all explained in detail in each file, tabulated below. Here, we will discuss the methods used in each of these sections, rationalize decision made, and discuss alternatives that could have been performed instead.

| Question Type | Code |
|---------------|------|
| Descriptive | [**``./draft/Assignment3_Abridged.ipynb``**](./draft/Assignment3_Abridged.ipynb) |
| Exploratory | [**``./draft/Assignment3_Abridged.ipynb``**](./draft/Assignment3_Abridged.ipynb) |
| Inferential | [**``./draft/Assignment4.ipynb``**](./draft/Assignment4.ipynb) |
| Predictive  | [**``./draft/Assignment5_Classification_FatBoys.ipynb``**](./draft/Assignment5_Classification_FatBoys.ipynb) |
| Testing Assumptions | [**``./draft/Assignment6_Checking_Assumptions_Fatboys.ipynb``**](./draft/Assignment6_Checking_Assumptions_Fatboys.ipynb) |
| Further Clustering | [**``./draft/Ivan_Report.ipynb``**](./draft/Ivan_Report.ipynb) |
| Previous Work and Literature Search| [**``./Edric-Report-LiteratureSearch.md``**](./Edric-Report-LiteratureSearch.md)|
| Computer Vision and Colocalization Analysis | [**``../code/Colocalization/Synapse_Vis.m``**](./code/Colocalization/Synapse_Vis.m),[**``./draft/IvanReport_4_27.ipynb``**](./draft/IvanReport_4_27.ipynb) |

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
We computed the correlation on log-normalized features across different excitatory and inhibitory markers. We observe

#### Further Exploration and Clustering




#### Computer Vision and Colocalization Analysis
We investigated how well a set of peaks on the raw images of a marker colocalized with another set of peaks on the raw images of another marker. To accomplish this, we first subsampled on the images to find a section of the images to anlyze, denoise the images through applying a hard threshold and non-max supression, and finally recorded the peak locations. 

We first picked out the hospots for the GABAR-1 markers, and found the spatial correlation between these hotspots with those on the images for all other markers based on a 1-neareast neighbor test. Then we performed the same procedure for the hostpots of all other images and constructed the correspdoning correlation heatmap. 

In addition, we wanted to know, for a given hotspot on the raw images of channel A, the distribution of the neighboring hotspots on the images of other channels. For each stack of images we applied a hard threshold and then identified the hospots through non-max suppression. We then computed for any given pair of channel A and B, the distribution of the hotspots in channel A within 1.5 pixels of any given hostpots in channel B after superimposeing the two channels on top of each other. 

* We also tried out other methods for denoising the image, such as unsharp masking, de-convolution, and a series of edge-based threshold filtering. The results produced from those methods were not so informative and thus were not included in the final report
