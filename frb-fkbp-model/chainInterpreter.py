import sys
import pickle
import numpy as np
import numpy.ma as ma
from mk2 import testParamNames, testParams
import matplotlib.pyplot as plt
import corner

def main():
	args = {
		'doc': 'chain.pkl',
		'allWalkerGraph': False,
		'firstWalkerHist': False,
		'triangle': False,
		'version': 2,
		'filter' : False,
		'firstTrial' : 0
	} 

	#args['doc'] = sys.argv[1]
	options = []
	i = 1
	while i < len(sys.argv):
		if sys.argv[i][0] == '-':
			if sys.argv[i] == '-awg':
				args['allWalkerGraph'] = True
			elif sys.argv[i] == '-fwh':
				args['firstWalkerHist'] = True
			elif sys.argv[i] == '-tri':
				args['triangle'] = True
			elif sys.argv[i] == '-fil':
				args['filter'] = True
		else:
			if sys.argv[i-1][0] == '-':
				if sys.argv[i-1] == '-v':
					args['version'] = int(sys.argv[i])
				if sys.argv[i-1] == '-tr':
					args['firstTrial'] = int(sys.argv[i])
			elif sys.argv[i-1] == 'chainInterpreter.py':
				args['doc'] = sys.argv[i]
		i = i + 1

	print args

	with open(args['doc'], 'rb') as doc:
		chain = pickle.load(doc)

	if args['version'] == 2:
		chain = np.exp(chain)

	nwalkers, nruns, ndim = chain.shape
	# print chain.shape
	chain = chain[:,args['firstTrial']:nruns,:]
	# print chain.shape

	if args['filter']:
		chain = ma.masked_array(chain, mask=False)
		for i in range(ndim):
			for j in range(nwalkers):
				stDev = np.std(chain[j,:,i])
				if stDev > .001:
					chain[j,:,i] = ma.masked_array([None] * (nruns - args['firstTrial']), mask=True)

	if args['allWalkerGraph']:
		for i in range(ndim):
			plt.figure(i)
			data = chain[:,:,i].transpose()
			plt.plot(range(args['firstTrial'], nruns), data)
			average = np.average(data)
			plt.plot([0, nruns], [testParams[i], testParams[i]], 'k')
			plt.plot([0, nruns], [average, average], 'b')
			plt.xlabel('runs')
			plt.ylabel('value')
			plt.title(testParamNames[i] + ' = ' + str(testParams[i]) + ' | avg = %.2E' % average)
		plt.show()

	if args['firstWalkerHist']:
		plt.figure()
		plt.plot(range(nruns), chain[0,:,:])
		plt.show()

	if args['triangle']:
		dynRange = [(0, 1)] * 5;
		samples = chain[:, :, :].reshape((-1, ndim))
		fig = corner.corner(samples, labels=testParamNames, truths=testParams)
		fig.savefig("triangle.png")


if __name__ == '__main__':
	main()