import sys
import pickle
import numpy as np
from mk1 import testParamNames, testParams
import matplotlib.pyplot as plt
import corner

defaults = ['chain.pkl', 0, 0, 0]
args = defaults

version = 0;

for i in range(len(sys.argv) - 1):
	args[i] = sys.argv[i+1]
print args

with open(args[0], 'rb') as doc:
	chain = pickle.load(doc)

nwalkers, nruns, ndim = chain.shape
if int(args[1]) == 1:
	for i in range(ndim):
		plt.figure(i)
		data = chain[:,:,i].transpose()
		plt.plot(range(nruns), data)
		plt.plot([0, nruns], [testParams[i], testParams[i]], 'k')
		plt.xlabel('runs')
		plt.ylabel('value')
		plt.title(testParamNames[i] + ' = ' + str(testParams[i]))
	plt.show()

if int(args[2]) == 1:
	plt.figure()
	plt.plot(range(nruns), chain[0,:,:])
	plt.show()

if int(args[3]) == 1:
	dynRange = [(0, 1)] * 5;
	samples = chain[:, :, :].reshape((-1, ndim))
	fig = corner.corner(samples, labels=testParamNames, truths=testParams, range=dynRange)
	fig.savefig("triangle.png")