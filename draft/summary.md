###Does Processing Brain Images With the Same Pipeline Improve The Power of Multi-site Inference Tasks?
*Greg Kiar*

-------------

#### Opportunity
With recent advances in processing technologies, mapping the human brain at a 1mm resolution has become a relatively low-burden task for scientists. These processing pipelines can estimate structural or functional connectivity within the brain based on structural MRI and diffusion or functional MRI, respectively. An abundance of such data exists and is currently being collected \[HCP, FCP\] around the globe, but few labs follow the same standard or specifications in their data collection process outside their given facility. Resultantly, the data across sites can be very noticeably different in brightness, contrast, and even texture from one another, making these images - and the scientific claims drawn from them - incredibly difficult to compare. This lack of reliability and reproducibility plagues research \[NTR, PRJ\], and is not limited to MRI. This problems calls into question the validity of any scientific claims made, and hinders true unified progress of the scientific community. If a unified processing strategy for non-uniform data exists it would enable researchers to share data, collaborate, and draw stronger scientific results that can be agreed upon and refined by the community.

#### Significance
If a processing pipeline existed which strengthened the scientific claims made across pooled data it would have potential to dramatically increase the rate at which scientific claims are developed. In MRI connectomics this means that development of the understanding of macroscale brain connectivity patterns and development of diagnostic classifiers can be expedited, leading to better treatment and awareness of mental illness. Approximately 1 in 5 adults suffers from mental illness in a given year in the United States, costing approximately $200 billion in lost earnings \[NAMI\]. Among these mental illnesses, depression is the leading cause of disability around the world today \[NAMI\]. Many of these illnesses, including as Alzheimer's Disease, Autism Spectrum Disorders, ADHD, and  Schizophrenia could be described as connectopathies \[PMD\] and may appear when observing the connectome. Enabling cross-study collaboration and pooling of data would increase the rate at which diagnostic and treatment tools can be developed for these disorders, influencing the lives of billions of people.

####Feasibility
The m2g pipeline \[M2G\] has been developed estimate structural connectomes with a core set of parameters to maximize the test-retest descriminatbility within datasets. This pipeline has been used to generate brain graphs at multiple scales on several datasets collected across multiple sites. Datasets available for use range between dozens and thousands of scans. Within the scope of this project, we expect to be able to perform at least one complete evaluation of this experiment, and possibly to refine it further with more datasets and a larger set of processing differences. Possible setbacks may be due to the computational burden associated with processing larger datasets, and will attempt to be avoided through use of Amazon EC2 instances where applicable.

####Innovation
If successful, this solution will empower reproducible science, remove significant computational duress from researchers, and strengthen future scientific claims. This will provide evidence in favour of using a unified processing strategy for data collected under slightly different acquisition schemes for applications in downstream inference tasks and production of reliable scientific discovery.


####References
  - [HCP] http://www.humanconnectomeproject.org/data/hcp-project/
  - [FCP] http://fcon_1000.projects.nitrc.org/indi/CoRR/html/
  - [NTR] http://www.nature.com/nrd/journal/v10/n9/full/nrd3439-c1.html
  - [PRJ] https://doi.org/10.7717/peerj.148
  - [NAMI] https://www.nami.org/Learn-More/Mental-Health-By-the-Numbers
  - [PMD] http://www.ncbi.nlm.nih.gov/pubmed/22196113
  - [M2G] http://m2g.io/


------------

##Notes:
In class jovo said the following:
- Opportunity: "What awesome things are happening"
- Significance: "How much does it affect a person, and how many people does it affect"
- Feasibility: "To what degree can we solve the problem with the time and resources we have"
- Innovation: "Of relative importance, depending where you work"
