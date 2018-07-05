import matlab.engine
import numpy as np 
from mk2 import *

eng = matlab.engine.start_matlab()
print 'matlab started'
a = np.array([-10.56, -22.33, -29.93, -18.24])
# a = np.array([-10, -10, -10, -10])

m1 = eng.sbioloadproject('frb-fkbp-hrp-model.sbproj')
 
print likelihood(a, eng, m1, 0)

# print errorGaussian(8.39741767365e-5)
# print np.log(errorGaussian(8.39741767365e-5))

# print errorGaussian(7.94412152325e-5)
# print np.log(errorGaussian(7.94412152325e-5))