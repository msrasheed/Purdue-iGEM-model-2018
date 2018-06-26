import csv

with open("Data_CCPP_measurements.csv") as f:
    reader = csv.reader(f)
    next(reader) # skip header
    data = [r for r in reader]

print data