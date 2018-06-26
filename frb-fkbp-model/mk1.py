import csv
import numpy as np 
import emcee
import matlab.engine
import matplotlib.pyplot as plt

with open("data.csv") as f:
	reader = csv.reader(f)
	next(reader) #skip header
	data = [r for r in reader]
print "Test Data Loaded"

eng = matlab.engine.start_matlab()
print "Matlab Engine Started"

def likelihood(x, eng, data):
	sub, time = eng.simulateKinetics(x, nargout=2);


ndim = 8
nwalkers = 250
p0 = np.random.rand(ndim * nwalkers).reshape((nwalkers, ndim))	

sampler = emcee.EnsembleSampler(nwalkers, ndim, likelihood, args=[eng, data])

pos, prob, state = sampler.run_mcmc(p0, 100)
sampler.reset()

sampler.run_mcmc(pos, 1000)
