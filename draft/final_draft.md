### Synaptic Diversity
***The Fat Boys*** <br/>
May 4th, 2016

-------

**Table of Contents:**
- [Overview](./final_report.md#overview)
- [Scientific Questioning](./final_report.md#scientific-questioning)
  - [Decriptive Analysis](./final_report.md#descriptive-analysis)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis)
  - [Inferential Analysis](./final_report.md#inferential-analysis)
  - [Predictive Analysis](./final_report.md#predictive-analysis)
  - [Testing Assumptions](./final_report.md#testing-assumptions)
  - [Further Clustering](./final_report.md#clustering)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis)
- [Methods](./final_report.md#methods)
  - [Decriptive Analysis](./final_report.md#descriptive-analysis-1)
  - [Exploratory Analysis](./final_report.md#exploratory-analysis-1)
  - [Inferential Analysis](./final_report.md#inferential-analysis-1)
  - [Predictive Analysis](./final_report.md#predictive-analysis-1)
  - [Testing Assumptions](./final_report.md#testing-assumptions-1)
  - [Further Clustering](./final_report.md#clustering-1)
  - [Computer Vision and Colocalization Analysis](./final_report.md#computer-vision-and-colocalization-analysis-1)

----------

### Overview
Synapses are the fundamental building blocks of neuronal communication. While there has been recent attempts to classify cell types based on genetics and imaging, there has been no attempt to classify synapses into sub-groups besides the classical distinction between excitatory and inhibitory synapses. It is well known that synaptic dysfunction can cause many different kinds of diseases such as fragile X and Rett Syndrome. The study and characterization of synapses is thus a clinically important problem that could potentially improve our understanding of diseases that affect millions of patients. In this study, we use well-validated markers and high resolution electron microscopy to tackle the question of synaptic diversity. With the unprecedented scale and resolution of our data, the study could characterize different classes of synapses and potentially yield further insights linking molecules and genes to synaptic structure and diseases.


### Scientific Questioning
Here we will discuss our analysis of this data, starting with exploratory and descriptive analysis, up to preliminary work on hypothesis testing and classification. The questions posed and their outcomes are described sequentially, with code and methods used to answer them described at the end of this report.

#### Descriptive Analysis
The natural first step when working with any data is to ask exploratory and descriptive questions about it. We have access to the KDM-SYN-100824B dataset, which is composed of 24 conjugate array tomography images of 41 brain slices from the mouse primary somatosensory cortex. Each conjugate array tomography image corresponds to a specific immunostain marker. Our collaborator has already pre-processed the images to generate two secondary sets, which we will call the “marker set” and the “pivot set.” We will primarily rely on these two sets throughout our analysis. The former set contains information about the intensity and distribution of the molecular markers within individual synapses seen in the KDM-SYN-100824B images. The latter set contains the x,y, and slice location of the relevant synapses within the former dataset. In order to determine the structure of our data, we first attempted to determine basic information: dataset size and number of invalid (i.e. Inf/Na/NaN) data points within the data. We found that the marker dataset has data for 1,119,299 subjects (synapses) and 144 features for each subject. Each 6 consecutive features, to our best guess, correspond to a single fluorescent marker, for a total of 144/6 = 24 markers. Upon further investigation, we found that only the first 4 of the 6 features for each marker were relevant for further analysis, so we discarded the last 2. Hence, our feature size was reduced to 4 * 24 = 96. The pivot dataset has data for the same 1,119,299 synapses and l 3 features. These 3 features, as stated above, correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images. There were no invalid data points within the secondary datasets. For the rest of our analysis, we will focus on the marker set.

#### Exploratory Analysis



#### Inferential Analysis


#### Predictive Analysis


#### Testing Assumptions

#### Further Clustering

#### Computer Vision and Colocalization Analysis

#### Next Steps
The conducted exploratory analysis has raised several new questions which will need to be addressed in future work. First, judging from the feature marginal distributions, it appears that over half of the synapses in the marker file are outliers. This stems from the fact that there are a large number of false positives in the original synapse detection algorithm which was run on the raw images. This means that any conclusions we draw from the primary marker file are immediately questionable, as the majority of robust methods only function when less than half the samples are outliers. We have attemtped to deal with this by log-normalizing the data before conducting any analysis. We have also implemented robust methods of estimating localtion and scatter and avoided using inferential tests which are sensitive to outliers. Nonetheless, this is likely a half measure. What needs to be done in future work is that the original images need to be re-analyzed for synapses via an algorithm that generates fewer false positives at the expense of more false negatives. Next, our work suggests that the synapses liekly do cluster, although we have been unable to find them due to the large quantity of outliers.

### Methods
Each of the questions required code and (for the inferential, predictive, and assumption checking portions) mathematical theory. This is all explained in detail in each file, tabulated below. Here, we will discuss the methods used in each of these sections, rationalize decision made, and discuss alternatives that could have been performed instead.

| Question Type | Code |
|---------------|------|
| Descriptive | [**``./code/descriptive_and_exploratory_answers.ipynb``**](./code/descriptive_and_exploratory_answers.ipynb) |
| Exploratory | [**``./code/descriptive_and_exploratory_answers.ipynb``**](./code/descriptive_and_exploratory_answers.ipynb) |
| Inferential | [**``./code/inferential_simulation.ipynb``**](./code/inferential_simulation.ipynb) |
| Predictive  | [**``./code/classification_simulation.ipynb``**](./code/classification_simulation.ipynb) |
| Testing Assumptions | [**``./code/test_assumptions.ipynb``**](./code/test_assumptions.ipynb) |
| Extended Exploratory | [**``code/extended_exploratory.ipynb``**](code/extended_exploratory.ipynb),  [**``./code/extended_exploratory-on-new-datasets.ipynb``**](./code/extended_exploratory-on-new-datasets.ipynb) |
| Sample Distributions | [**``./code/multiple_distributions.ipynb``**](./code/multiple_distributions.ipynb) |
| Dimensionality Reduction | [**``./code/scree_plots.md``**](./code/scree_plots.md), [**``./code/multipanel_scree_plots.md``**](./code/multipanel_scree_plots.md) |

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


#### Testing Assumptions


#### Computer Vision and Colocalization Analysis
Scree plots show the singular values of the Singular Value Decomposition of a matrix. We took the adjacency matrix of our graphs, and performed the SVD on them. The elbows were found using code provided by Youngser Park, an implementation of the Zhu Ghodsi method published in 2006.
