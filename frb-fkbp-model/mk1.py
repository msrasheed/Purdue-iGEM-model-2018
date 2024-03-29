import numpy as np 
import matlab.engine
import math

stdParams = [1.0, 2.6e-5, 1.0, 2.0e-10, 1.0, 1.0e-13, 1.0, 1.2e-8, 1.0, 435.0, 9.0e-5]
testParams = [2.6e-5, 2.0e-10, 1.0e-13, 1.2e-8, 1.0]
stdParamNames = ["$kf_1$","$kr_1$","$kf_2$","$kr_2$","$kf_3$","$kr_3$","$kf_4$","$kr_4$","$kf_5$","$Km$","$kcat$"] 
testParamNames = ["$kr_1$","$kr_2$","$kr_3$","$kr_4$","$kf_5$"] 
numFails = 0
numTrials = 0

def main():
	import emcee
	import pickle
	import corner
	import progressbar 

	print "Initializing..."

	eng = matlab.engine.start_matlab()
	print "Matlab Engine Started"

	m1 = eng.sbioloadproject('frb-fkbp-hrp-model.sbproj')
	eng.sbioaccelerate(m1["m1"], nargout=0)
	print "Accelerated Model"

	ndim = 5
	nwalkers = 50
	burnRuns = 100
	runs = 1000
	p0 = np.random.rand(ndim * nwalkers).reshape((nwalkers, ndim))
	#p0 = [testParams] * nwalkers

	bar = progressbar.ProgressBar(max_value=burnRuns*nwalkers+100)

	sampler = emcee.EnsembleSampler(nwalkers, ndim, postProb, args=[eng, m1, bar], a=2e-3)
	loadPriorProteinAffData()
	print "Setup Complete"

	pos, prob, state = sampler.run_mcmc(p0, burnRuns)
	print "\nCompleted Burn Run"

	sampler.reset()
	print "Sampler Reset"

	global numTrials
	bar.max_value = numTrials*(runs/burnRuns)
	numTrials = 0
	bar.update(0)

	sampler.run_mcmc(pos, runs)
	print "\nCompleted Real Deal Runs"

	with open('chain.pkl', 'wb') as output:
		pickle.dump(sampler.chain, output)
	print "Saved Sampler Chain"

	samples = sampler.chain[:, :, :].reshape((-1, ndim))
	fig = corner.corner(samples, labels=testParamNames, truths=testParams)
	fig.savefig("triangle.png")
	print "Made Corner Plot"
	print "Done"

def postProb(x, eng, m1, bar):
	global numTrials
	numTrials += 1
	bar.update(numTrials)

	lp = prior(x)
	if not np.isfinite(lp):
		return -np.inf
	return lp + likelihood(x, eng, m1)

def likelihood(x, eng, m1):
	passed = True;
	blue = [[1]]
	time = [[1]]
	try:
		blue, time = eng.frbFkbpSimulator(matlab.double(x.tolist()), m1["m1"], nargout=2)
	except Exception as msg:
		passed = False
		print "Simulation Failed"

	blue = blue[0]
	time = time[0]
	blueCheck = blue
	SSE = 0
	for i in range(0, len(blueCheck)):
		blueCheck[i] = checkCurve(time[i])
		SSE += (blueCheck[i] - blue[i])**2

	if passed:
		return np.log(errorGaussian(SSE))
	else:
		return -np.inf

def prior(x):
	retVal = 1
	if not 0 < x[4] < 2:
		retVal = -np.inf
	else:
		for param in range(len(x) - 1):
			if priorProteinAffData[0, 0] < x[param] < priorProteinAffData[-1, 0]:
				retVal *= priorProteinAffSearch(x[param])
			else:
				retVal = -np.inf
	return retVal
	
def errorGaussian(err):
	mean = 0
	std = .01
	retval = (1/(2*math.pi*std**2))*math.exp(-1*((err-mean)**2)/(2*std**2))
	return retval

def checkCurve(time):
	retval = .1164 * time ** 3.482
	if retval > 1:
		retval = 1
	return retval

priorProteinAffData = []
def loadPriorProteinAffData():
	import csv
	with open("prior.csv") as f:
	    reader = csv.reader(f)
	    next(reader) # skip header
	    data = [r for r in reader]

	data = np.array(data)
	global priorProteinAffData
	priorProteinAffData = data.astype(np.float)
	return priorProteinAffData

def priorProteinAffSearch(num):
	minInd = 0
	maxInd = len(priorProteinAffData) - 1
	return priorProteinAffSearchHelper(minInd, maxInd, num, priorProteinAffData)

def priorProteinAffSearchHelper(minInd, maxInd, num, array):
	retVal_test = 1
	diff = maxInd - minInd
	if diff <= 0:
		if abs(array[maxInd, 0] - num) < abs(array[minInd, 0] - num):
			return array[maxInd, retVal_test]
		else:
			return array[minInd, retVal_test]

	midInd = int(diff/2) + minInd
	if array[midInd, 0] > num:
		return priorProteinAffSearchHelper(minInd, midInd-1, num, array)
	elif array[midInd, 0] < num:
		return priorProteinAffSearchHelper(midInd+1, maxInd, num, array)
	else:
		return array[midInd, retVal_test]

if __name__ == "__main__":
	main()