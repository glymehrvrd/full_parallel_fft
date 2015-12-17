#!/bin/env python

import numpy as np

def order_after_bypass(pt,structure):
    if pt.size==2:
        return pt
    l,r=structure[pt.size]
    pt=pt.reshape(l,r)
    for i in xrange(r):
        pt[:,i]=order_after_bypass(pt[:,i], structure)
    for j in xrange(l):
        pt[j,:]=order_after_bypass(pt[j,:], structure)
    return pt.transpose().reshape((1,l*r))


a=np.arange(4, )
structure={2048:(32,64),32:(4,8),64:(8,8),16:(4,4),8:(2,4),4:(2,2)}
b=order_after_bypass(a, structure)+1
print b.transpose()