# Introduction to Bayesian Statistics Materials  
This repository contains the slides, data, and R code that accompany the following presentation:

> Grand, J.A. (October, 2019). *You know I'm all about that Bayes: A (relatively) gentle introduction to Bayesian statistics.* Invited presentation for University of Maryland SDOS program brown bag series, College Park, MD.

## Required software and R packages
In order to run the analyses in the provided code, you will need the most recent version of JAGS (Just Another Gibbs Sampler) installed on your computer. JAGS can be downloaded [here](https://sourceforge.net/projects/mcmc-jags/files/).

Additionally, you will need to have [R](https://cran.r-project.org/) and the `runjags` and `mcmcplots` packages installed on your computer. To install these packages, copy the lines below and run them in your R console window.
```R
install.packages("runjags")
install.packages("mcmcplots")
```

## Code files
There are three R files to download:
- **simpleRegressionNormalDV.R** -- contains R code for running simple linear regression model using JAGS
- **plotPost.R** -- contains R code for helper function to make pretty posterior distribution plots
- **HDIofMCMC.R** -- contains R code for computing highest density credibility interval for MCMC samples

Code for plotPost.R and HDIofMCMC.R are from:

> Kruschke, J.K. (2010). *Doing Bayesian data analysis: A Tutorial with R and BUGS.* Academic Press / Elsevier.

## Data file
The sample data file entitled **mechPerfDat.csv** were collected as part of my unpublished master's thesis:

> Grand, J. A. (2008). Changing gears: Modeling gender differences in performance on tests of mechanical comprehension (Order No. 1463014). Available from ProQuest Dissertations & Theses Global. (304593336).

The file contains data from 258 participants who completed a test of mechanical comprehension; a series of measures related to their interests, experience, knowledge, and self-efficacy with mechanical tasks; and measures corresponding to self-reported gender roles and endorsement of male-female stereotypes. The example simple regression analyses used in this presentation use only the mechanical test performance and mechanical self-efficacy data.
