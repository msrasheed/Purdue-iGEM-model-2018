import matlab.engine
import numpy as np 
from mk2 import *

eng = matlab.engine.start_matlab()
print 'matlab started'
a = np.array([-10.5,-22.3])
m1 = eng.sbioloadproject('frb-fkbp-hrp-model.sbproj')
 
print likelihood(a, eng, m1)