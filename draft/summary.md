###Summary.md

**Opportunity:**

Analysis of the genetic expression profile of synapses is a challenging problem that is under-addressed. Although immunofluorescence microscopy provides a powerful tool for characterizing the genetic composition of synapses through a limited set of markers, it cannot be used to definitively localize synapses at a high resolution. Nor does it provide much structural or morphological information about the synapses. Currently, electron microscopy (EM) is the gold standard for definitive, high-resolution synapse localization as well as structural and morphological synapse characterization [2].

Synapse type diversity is potentially a complicated and important subject of research. There has been little analysis on the characterization of synapse type, partially due to lack of the appropriate tools [3]. The recent development of conjugate array tomography, a volumetric imaging modality which allows for both immunofluorescence and EM of the same voxel, presents a great opportunity for high-resolution characterization of synapses using both genetic expression and microscopy data, allowing us to tackle this important problem. The full outline of the technique can be found in Collman et al [1]. 

**Significance:**

Synapses are the fundamental building blocks of neuronal communication. While there has been recent attempts to classify cell types based on genetics and imaging, there has been no attempt to classify synapses into sub-groups besides the classical distinction between excitatory and inhibitory synapses. It is well known that synaptic dysfunction can cause many different kinds of diseases such as fragile X and Rett Syndrome. The study and characterization of synapses is thus a clinically important problem that could potentially improve our understanding of diseases that affect millions of patients [3]. In this study, we use well-validated markers and high resolution electron microscopy to tackle the question of synaptic diversity. With the unprecedented scale and resolution of our data, the study could characterize different classes of synapses and potentially yield further insights linking molecules and genes to synaptic structure and diseases.

**Feasibility:** 

Initially the group had doubts as to how each individual synapse could be mapped to each fluorescent data entry point, but the methods outlined in Collman et al [1] were employed to resolve this concern and produce the raw data that was given to the group. First few attempts to classify each data point from a subset of the data to its respective group was not successful; we observed no clear, distinct centers when submitting the raw data to a principle component analysis pipeline. The group will try to prune away irrelevant features to achieve better clustering results through correlation analysis of the features. The data and code provided also lacked some important comments and descriptions that could hinder our progress. Despite these challenges, there are over a million synapses each with 144 features, making this problem computationally and statistically well-posed and tractable. Moreover, the huge memory required to process the whole dataset also presents a computational burden, but with access to computer clusters, computation resources should not be too big of a concern. Overall, we are confident that this project will be feasible and successful.

**Innovation:**

While there has been recent innovation in groups classifying cell types based on RNA-seq and morphological data, there has been no attempt to our knowledge of scientists trying to classify synapses into categories other than crude division into excitatory/inhibitory, glutamatergic/GABAergic etc. We have found no existing publications attempting to classify synapses using fluorescence scan data information, not to mention with the resolution and scale of our dataset. Thus, we conclude that this project is highly innovative. Perhaps we will be the first to study “synaptomics.” 

**References:**

[1] Collman, F., J. Buchanan, K. D. Phend, K. D. Micheva, R. J. Weinberg, and S. J. Smith. "Mapping Synapses by Conjugate Light-Electron Array Tomography." Microscopy 64.Suppl 1 (2015): I74. Web.

[2] Vogt, Nina. "Microscopy: Synapses Seen at Different Scales." Nature Methods Nat Meth 12.6 (2015): 485. Web.

[3] O'Rourke, Nancy A., Nicholas C. Weiler, Kristina D. Micheva, and Stephen J. Smith. "Deep Molecular Diversity of Mammalian Synapses: Why It Matters and How to Measure It." Nature Reviews Neuroscience 13 (2012): 365-79. Nature. Nature Reviews Neuroscience, June 2012. Web.

