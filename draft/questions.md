Ivan’s summary (idk if relevant): We have 2 datasets. The first dataset has data for 1,119,299 synapses and 144 features for each synapse. Each 6 consecutive features correspond to a single fluorescent marker, for a total of 24 markers. It is as of now unclear what these 6 features represent. The second dataset has data for the same 1,119,299 synapses and an additional 3 features. These 3 features correspond to the x-location, y-location, and slice number for the corresponding synapse in the conjugate array tomography images.
Questions About my Project
We have D datasets, each with Ni subjects, for i = 1...D.
Each dataset contains graphs, Gni = (V, E, A, Y) for ni=1...Ni.
V is in the set of \mathcal{V}, with cardinality |V|. We know that \mathcal{V} is the same across all datasets.
E is in the set of \mathcal{E} = {V x V: Vm ~ Vp}, for m,p = 1...|V|.
A is an edge attribute which indicates weight and belongs to the set \mathbb{R}+.Implicitly, |A| = |E|. 
Y are class labels and belong to the set {0,1}, and indicate subject gender.
Descriptive 
What are the features?
For the first dataset, each synapse is equipped with 6 features, likely corresponding to some sort of fluorescent marker intensity values in different color channels. (this is our best guess...)
For the second dataset, each synapse is equipped with 3 features, corresponding to the location of the synapse within the image (x, y, z or slice)
How many features do we have?
taken in total, we have 6+3 = 9 features
Are some of the features constant throughout all synapses and thus irrelevant?
Judging from a preliminary look at the data, none of the features are constant throughout all synapses. Thus, all or most of them might be potentially relevant. 
What does each column from the raw data set given represent?
How distinct are the features? Are they highly correlated?
Are the number of features and the number of samples in a good proportion?
Exploratory 
What are the mean and standard deviations of the individual feature columns in the dataset?
What are the marginal distributions of the features in the first dataset?
Which features have the greatest variability among the subjects? Which have the least?
Does the data form any clear clusters?
How many principal components are needed to describe the data well?
Are any of the subjects outliers?
Does the covariance matrix exhibit any obvious structure?
Inferential 

If graphs Gni and Gnj for all i != j are processed the same way, is descriminability maximized?
If our brains are samples Xi in \mathcal{X}, then the observed graphs are Yiq = fq(Xi), for processing strategies fq where q=1,...,Q, and where fq: Xi \sim Yi. If we are asking whether or not using the same functional f improves descriminability, our alernate and hypothesis and null become:
p( ||Axy - Ax'y|| \leq || Axy - Ax'y' || ), where x is the graph observed and y is the label associated with the observed graph. If a superscript indicates processing technique, we have:
HA: p( ||Yijq - Yij'q|| < || Yijq - Yi'j'q' || ) 
H0: p( ||Yijq - Yij'q|| \geq || Yijq - Yi'j'q' || )
Predictive 
What are the most descriptive features (f within F, where F denotes the set of all biomarker features given) that would best separate different types of synapses into their respective classes?  

Causal 
How do the different patterns of the present immuno-stain markers influence the functions of each class of synapses? 
Mechanistic 
How does a difference in gene expression determine the different patterns of the present immuno-stain markers and thus influence the functions of each class of synapses?
Does the precise location of the markers within the synapse provide information on the classes of synapses?
Does the 
