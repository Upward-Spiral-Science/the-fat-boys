Table of Contents: 
Overview Scientific 


Questioning 


Descriptive Analysis 


Exploratory Analysis 


Inferential Analysis 


Predictive Analysis 


Testing Assumptions 


Next Steps 


**Overview**


Synapses are the fundamental building blocks of neuronal communication. While there has been recent attempts to classify cell types based on genetics and imaging, there has been no attempt to classify synapses into sub-groups besides the classical distinction between excitatory and inhibitory synapses. It is well known that synaptic dysfunction can cause many different kinds of diseases such as fragile X and Rett Syndrome. The study and characterization of synapses is thus a clinically important problem that could potentially improve our understanding of diseases that affect millions of patients. In this study, we use well-validated markers and high resolution electron microscopy to tackle the question of synaptic diversity. With the unprecedented scale and resolution of our data, the study could characterize different classes of synapses and potentially yield further insights linking molecules and genes to synaptic structure and diseases.

**Scientific Questioning**


Here we will discuss our analysis of this data, starting with exploratory and descriptive analysis, up to preliminary work on hypothesis testing and classification. The questions posed and their outcomes are described sequentially, with code and methods used to answer them described at the end of this report.


**Descriptive Analysis**


The natural first step when working with any data is to ask exploratory and descriptive questions about it. We have access to the KDM-SYN-100824B dataset, which is composed of 24 conjugate array tomography images of 41 brain slices from the mouse primary somatosensory cortex. Each conjugate array tomography image corresponds to a specific immunostain marker. Our collaborator has already pre-processed the images to generate two secondary sets, which we will call the “marker set” and the “pivot set.” We will primarily rely on these two sets throughout our analysis. The former set contains information about the intensity and distribution of the molecular markers within individual synapses seen in the KDM-SYN-100824B images. The latter set contains the x,y, and slice location of the relevant synapses within the former dataset. In order to determine the structure of our data, we first attempted to determine basic information: dataset size and number of invalid (i.e. Inf/Na/NaN) data points within the data. We found that the marker dataset has data for 1,119,299 subjects (synapses) and 144 features for each subject. Each 6 consecutive features, to our best guess, correspond to a single fluorescent marker, for a total of 144/6 = 24 markers. Upon further investigation, we found that only the first 4 of the 6 features for each marker were relevant for further analysis, so we discarded the last 2. Hence, our feature size was reduced to 4 * 24 = 96. The pivot dataset has data for the same 1,119,299 synapses and l 3 features. These 3 features, as stated above, correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images. There were no invalid data points within the secondary datasets. For the rest of our analysis, we will focus on the marker set.


**Inferential Analysis**
We are now primed to further search our datasets for clusters. We proceeded by using inference analysis to determine how many clusters individual feature columns contained. More formally, we assumed that a feature column assumes a Gaussian mixture model with k components. We wanted to know what number of clusters/components is the most likely. Therefore, we iteratively performed statistical tests on k clusters vs k+1 clusters, where k ranges from 1 to 4. For VGlut1 we achieved the following results:

![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot1.png "Plot1")
![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot2.png "Plot2")

Clearly, for VGlut1, inference testing supports k > 1. For the feature columns we examined, our inference testing results support the existence of clusters within the data.


**Predictive Analysis**

Next we want to see if each marker could be used to predict another marker. To do so for any arbitrary chosen marker, we employed all other markers as the features to build a classifier for the chosen feature. To create labels for the chosen marker, we assign the expression instances into two groups through thresholding. Several types of classifiers were trained and tested using LOO cross-validation, and some results are shown in the figure below. 

![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot3.png "Plot3")

Here we notice that with the classifier which performs significantly better than the others is the Linear Discriminant Analysis, which was expected due to the way we created the labels. Regardless of the classifiers used, in most trials, a marker could be predicted by other markers, which suggests coexpression.


Given a chosen marker, rather than using all other markers as the features, we then proceed to only use a subset of the markers as the features. For instance, as a control group, we tried to predict an inhibitory neuron marker with other inhibitory neuron markers. Then we attempted to use a set of markers having known association with the chosen markers as the features. However, the initial result for this experiment was not good, as in most cases the classifiers could not predict the chosen marker better than chances. As a future step, we will proceed to investigate why this is the case. 

**Testing Assumptions**

We assume that integrated brightness features of all 24 markers are sampled in an i.i.d. fashion. This is both an independent and identical assumption.


To check independence, check that off diagonal correlation is approximately 0. To check indenticality, check that the optimal number of clusters is approximately 1 under GMM model. 

![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot5.png "Plot5")
![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot6.png "Plot6")
![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot7.png "Plot7")
![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot8.png "Plot8")




**Next Steps**


We have made significant progress in terms of simply exploring our datasets and characterizing some of their features. However, one of the central goals of the project is to actually manage to cluster our synapses into different categories. Although we have significant indirect evidence for the existence of more than 1 cluster within the marker dataset, we have, so far, been unable to actually directly visualize it. Future work will focus on this latter aspect. 
In order to actually visualize the clusters, we will most likely need to change our approach. So far we have simply tried to cluster on the normalized or log-normalized feature columns. Equivalently, we have attempted to separate the synapses by examining where their values feature lie within the individual marginal feature columns. This approach assumes a significant amount of independence between the feature columns, which based off of the correlation matrix, is a faulty assumption. Going forward, we will likely attempt to separate the features based on the joint distributions of multiple feature columns or even the conditional distributions of two or more feature columns.

**Methods**


Each of the questions required code and (for the inferential, predictive, and assumption checking portions) mathematical theory. This is all explained in detail in each file, tabulated below. Here, we will discuss the methods used in each of these sections, rationalize decision made, and discuss alternatives that could have been performed instead.



| Question Type       | Code           |
| ------------- |:-------------:| 
| Descriptive     | [the-fat-boys/draft/questions.md] |
| Exploratory    | [the-fat-boys/draft/Assignment3.ipynb]     | 
| Inferential | [the-fat-boys/draft/Assignment4.ipynb]     | 
| Predictive    | [the-fat-boys/draft/Assignment5_Classification_FatBoys.ipynb] |
| Testing Assumptions    | [the-fat-boys/draft/Assignment6_Checking_Assumptions_Fatboys.ipynb]      | 


**Descriptive Analysis**


Our data is off a relatively standard format, so the descriptive analysis was rather straightforward. We simply examined the number of rows and columns in the two datasets, checked them from invalid data values, and then contacted our collaborator to understand what the individual rows/features correspond to.


**Exploratory Analysis**


We asked the following questions: 


1) What are the mean and standard deviations of the individual feature columns in the dataset? 


2) What are the marginal distributions of the features in the first dataset? 


3) Which features have the greatest variability among the subjects? Which have the least?


4) Does the data form any clear clusters?


5) How many principal components are needed to describe the data well?


6) Does the covariance matrix exhibit any obvious structure?


The answer to (1) was a straightforward computation. We completed (2) by constructing a kernel density estimate from the individual feature columns. (3) was done by examining the previously constructed marginals. (4) was done by using PCA/k-means and t-SNE. (5) was done by constructing a scree plot. (6) was done through visual inspection of the covariance matrix.


**Inferential Analysis**


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


**Predictive Analysis**


As described in the previous section, we iteratively went through all markers and in each trial used all other markers as features to train a classifiers for the marker being iterated through. Some of the tests were non-parametric (LDA, QDA), while others are not(K-nearest neighbour, Linear SVM, and Random Forest). The parameters were used were recommended by the skylearn documentation, and we could customize them to obtain better results.
Below outlines the performance of each of these classifiers tested on simulated data sampled from a Gaussian distribution.


![alt text](https://github.com/Upward-Spiral-Science/the-fat-boys/blob/master/figs/Plot4.png "Plot4")
