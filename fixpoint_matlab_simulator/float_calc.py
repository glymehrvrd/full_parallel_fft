import numpy as np
from numpy.fft import fft
from pprint import pprint

def gen_fft(num,structure,result):
    sz=num.shape[0]

    if not result.has_key(sz):
        result[sz]=fft(num,axis=0).reshape(sz,1,order='F')
    else:
        result[sz]=np.vstack((result[sz],fft(num,axis=0).reshape(sz,1,order='F')))

    if structure.has_key(sz):
        l,r=structure[sz]
        num=num.reshape(l,r)

        for i in xrange(l):
            gen_fft(num[:,i], structure, result)

structure={2048:(32,64),32:(4,8),64:(8,8),16:(4,4),8:(2,4),4:(2,2)}

result={}
gen_fft(np.arange(32), structure,result)
pprint(result)