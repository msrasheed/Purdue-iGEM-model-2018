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


