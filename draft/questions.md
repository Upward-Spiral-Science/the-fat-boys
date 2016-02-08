
###Questions About My Project

We have 2 datasets. 

The first dataset has data for 1,119,299 subjects (synapses) and 144 features for each subject. Each 6 consecutive features, to our best guess, correspond to a single fluorescent marker, for a total of 144/6 = 24 markers. It is as of now unclear what these 6 features represent exactly. 

The second dataset has data for 1,119,299 synapses and an additional 3 features. These 3 features, to our best guess, correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images.


**Descriptive**
How many features do we have?
Are the 1,119,299 synapses in dataset 1 and dataset 2 in the same order?
What do the features represent exactly in dataset 1 correspond to exactly? 
What do the features represent exactly in dataset 2 correspond to exactly? 
Are some of the features constant throughout and thus irrelevant?
How distinct are the features? Are any of them highly correlated?
Are any of the features NaNs or Zeros or Infinity or undefined or blank? Would it affect our processing?
What is the ratio between the number of features and the number of samples? Is the problem statistically well posed?


**Exploratory** 

What are the mean and standard deviations of the individual feature columns in the dataset?
What are the marginal distributions of the features in the first dataset?
Which features have the greatest variability among the subjects? Which have the least?
Does the data form any clear clusters?
How many principal components are needed to describe the data well?
Are any of the subjects outliers?
Does the covariance matrix exhibit any obvious structure?


**Inferential** 
If graphs Gni and Gnj for all i != j are processed the same way, is descriminability maximized?
If our brains are samples Xi in \mathcal{X}, then the observed graphs are Yiq = fq(Xi), for processing strategies fq where q=1,...,Q, and where fq: Xi \sim Yi. If we are asking whether or not using the same functional f improves descriminability, our alernate and hypothesis and null become:
p( ||Axy - Ax'y|| \leq || Axy - Ax'y' || ), where x is the graph observed and y is the label associated with the observed graph. If a superscript indicates processing technique, we have:
HA: p( ||Yijq - Yij'q|| < || Yijq - Yi'j'q' || ) 
H0: p( ||Yijq - Yij'q|| \geq || Yijq - Yi'j'q' || )


**Predictive**

What are the most descriptive features (f within F, where F denotes the set of all biomarker features given) that would best separate different types of synapses into their respective classes?  

Try to find h, of the form h in \mathcal{H} such that h: Gni=(V, E, W) \to Yni

**Causal** 

How do the different expression levels of the present immuno-stain markers cause and influence the different functions of each class of synapses? 
Does the precise location of the markers within the synapse cause functional differences on the different classes of synapses?


**Mechanistic** 

How does a difference in gene expression determine the different patterns of the present immuno-stain markers and thus influence the functions of each class of synapses?



