import csv 
import numpy as np
import sys
import matplotlib.pyplot as plt

def main():
	with open("prior.csv") as f:
	    reader = csv.reader(f)
	    next(reader) # skip header
	    data = [r for r in reader]

	data = np.array(data)
	data = data.astype(np.float)

	searchFor = float(sys.argv[1])
	#print data[0,0]
	print binarySearch(searchFor, data)

def binarySearch(num, array):
	minInd = 0
	maxInd = len(array) - 1
	return binarySearchHelper(minInd, maxInd, num, array)

def binarySearchHelper(minInd, maxInd, num, array):
	diff = maxInd - minInd
	if diff <= 0:
		if abs(array[maxInd, 0] - num) < abs(array[minInd, 0] - num):
			return array[maxInd, 0]
		else:
			return array[minInd,0]

	midInd = int(diff/2) + minInd
	if array[midInd, 0] > num:
		return binarySearchHelper(minInd, midInd-1, num, array)
	elif array[midInd, 0] < num:
		return binarySearchHelper(midInd+1, maxInd, num, array)
	else:
		return array[midInd, 0]

if __name__ == "__main__":
	main()