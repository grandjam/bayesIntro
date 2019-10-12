require(runjags)
require(mcmcplots)

source(paste(getwd(),"plotPost.R",sep="/"))
source(paste(getwd(),"HDIofMCMC.R",sep="/"))
# Code for plotPost.R and HDIofMCMC.R are from Kruschke, J.K. (2010). Doing Bayesian data analysis: A Tutorial with R and BUGS. Academic Press / Elsevier.

#------------------------------------------------------------------------------
# THE MODEL.

modelstring = "
model {

  ## Likelihood -- distribution for observations of DV
  ## Normal likelihood distribution used because DVs are continuous and assumed to be normally distributed
  ## Note subsetting of regression equation used in regression equation to specify that y, mu.y, and x1 come from each person in the dataset.

  for (i in 1:nTotal) {
    y[i] ~ dnorm(mu.y[i], 1/sig^2) # IMPORTANT NOTE: JAGS parameterizes normal distribution using the mean and precision. Precision is 1/variance
    mu.y[i] <- b0 + b1 * x1[i]
  }

  ## Priors -- distribtion for regression coefficients and likelihood variance
  
  b0 ~ dnorm(0, (1/10)^2)
  b1 ~ dnorm(0, (1/10)^2)
  sig ~ dunif(1/100, 100)
}

" # close quote for modelstring
writeLines(modelstring, con="regressNormalPriors.txt")

#------------------------------------------------------------------------------
# THE DATA.

# Read in data
dat <- read.csv("mechPerfDat.csv")

# Specify data for the model
y = as.numeric(dat$BMCT_tot)
x1 = as.numeric(dat$Mech_SE_avg - mean(dat$Mech_SE_avg))

# Indexing values for JAGS loop
nTotal = nrow(dat)

# Create data list for JAGS
dataList = list(
  y = y, 
  x1 = x1,
  nTotal = nTotal
)

#------------------------------------------------------------------------------
# RUN THE CHAINS

parameters = c( "b0", "b1", "sig")
adaptSteps = 500         # Number of steps to "tune" the samplers.
burnInSteps = 1000       # Number of steps to "burn-in" the samplers.
nChains = 3              # Number of chains to run.
numSavedSteps = 20000    # Total number of steps in chains to save.image     
thinSteps= 1             # Number of steps to "thin" (1=keep every step).   

# Parallel processing code
## Perform adaptation, burn-in, and run final MCMC chains
Start_time <- Sys.time()  
runJagsOut <- run.jags( method = "parallel",
                        model = "regressNormalPriors.txt", 
                        monitor = parameters,
                        data = dataList, 
                        n.chains = nChains, 
                        adapt = adaptSteps,
                        burnin = burnInSteps,
                        sample = ceiling(numSavedSteps/nChains),
                        thin = thinSteps,
                        summarise = F,
                        plots = F
)
Run_time <- Sys.time() - Start_time
Run_time
## Convert JAGS object into a mcmc.list that can be accessed by coda package
codaSamples <- as.mcmc.list(runJagsOut)

# Check MCMC convergence
mcmcplot(codaSamples, parms = c("b0","b1", "sig")) #Trace plots to visually inspect MCMC chains
gelman.diag(codaSamples, multivariate = F)
effectiveSize(codaSamples)

#------------------------------------------------------------------------------
# EXAMINE THE RESULTS

# Convert coda-object codaSamples to matrix object for easier handling.
# But note that this concatenates the different chains into one long chain.
# Result is mcmcChain[ stepIdx , paramIdx ]
mcmcChain = as.matrix( codaSamples )

# Extract regression estimates from MCMC chain #
b0samp = mcmcChain[,"b0"]
b1samp = mcmcChain[,"b1"]
sigSamp = mcmcChain[,"sig"]

# Plot posterior #
plotPost( b0samp , xlab=paste("Intercept") , compVal=0.0 , HDItextPlace=0.9, xlim = c(35, 45))
plotPost( b1samp , xlab=paste("Slope") , compVal=0.0 , HDItextPlace=0.9)
plotPost( sigSamp , xlab=paste("Residual") , compVal=0.0 , HDItextPlace=0.9)


# Frequentist analysis for comparison
out <- lm(y ~ x1)
summary(out)