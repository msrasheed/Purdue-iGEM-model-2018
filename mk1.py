import csv
import numpy as np 
import math
import emcee
import matlab.engine
import matplotlib.pyplot as plt

def main():
	with open("data.csv") as f:
		reader = csv.reader(f)
		next(reader) #skip header
		data = [r for r in reader]
	print "Test Data Loaded"

	eng = matlab.engine.start_matlab()
	print "Matlab Engine Started"

	ndim = 8
	nwalkers = 250
	p0 = np.random.rand(ndim * nwalkers).reshape((nwalkers, ndim))	

	sampler = emcee.EnsembleSampler(nwalkers, ndim, likelihood, args=[eng, data])

	pos, prob, state = sampler.run_mcmc(p0, 100)
	sampler.reset()

	sampler.run_mcmc(pos, 1000)

def likelihood(x, eng, data):
	blue, time = eng.frbFkbpSimulator(x, nargout=2)
	blue = blue[0]
	time = time[0]
	blueCheck = blue
	SSE = 0
	for i in range(0, len(blueCheck)):
		blueCheck[i] = checkCurve(time[i])
		SSE += (blueCheck[i] - blue[i])**2
		
	
def errorGaussian(err):
	mean = 0
	std = .4
	retval = (1/(2*math.pi*std**2))*math.exp(-1*((err-mean)**2)/(2*std**2))
	return retval

def checkCurve(time):
	retval = .1164 * time ** 3.482
	if retval > 1:
		retval = 1
	return retval

if __name__ == "__main__":
	main()