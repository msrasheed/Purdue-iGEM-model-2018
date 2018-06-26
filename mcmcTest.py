import numpy as np
import emcee

def lnprob(x):

ndim = 7;
nwalkers = 50
p0 = np.random.rand(nwalkers * ndim).reshape((nwalkers, ndim))

sampler = emcee.EnsembleSampler(nwalkers, ndim, lnprob, args=[])

