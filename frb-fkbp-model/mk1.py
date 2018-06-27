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

	eng = matlab.engine.start_matlab()
	print "Matlab Engine Started"

	m1 = eng.sbioloadproject('frb-fkbp-hrp-model.sbproj')
	eng.sbioaccelerate(m1["m1"], nargout=0)
	print "Accelerated Model"

	ndim = 5
	nwalkers = 50
	burnRuns = 100
	runs = 500
	p0 = np.random.rand(ndim * nwalkers).reshape((nwalkers, ndim))	

	bar = progressbar.ProgressBar(max_value=ndim*burnRuns*nwalkers)

	sampler = emcee.EnsembleSampler(nwalkers, ndim, postProb, args=[eng, m1, bar])

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

	if prior(x):
		return likelihood(x, eng, m1)
	else:
		return -np.inf

def likelihood(x, eng, m1):
	passed = True;
	blue = [[1]]
	time = [[1]]
	global numTrials
	global numFails
	try:
		blue, time = eng.frbFkbpSimulator(x.tolist(), m1["m1"], nargout=2)
	except Exception as msg:
		passed = False
		numFails += 1
		print str(numFails) + "/" + str(numTrials)
		print x

	blue = blue[0]
	time = time[0]
	blueCheck = blue
	SSE = 0
	for i in range(0, len(blueCheck)):
		blueCheck[i] = checkCurve(time[i])
		SSE += (blueCheck[i] - blue[i])**2

	if passed:
		return errorGaussian(SSE)
	else:
		return -np.inf

def prior(x):
	flag = True
	for i in x:
		if not 0 <= i <= 2:
			flag = False
	return flag
	
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