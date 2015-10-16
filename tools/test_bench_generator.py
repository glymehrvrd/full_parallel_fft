# generate test vector for fft

data = [
    ('data_0_re_in', '0001'),
    ('data_0_im_in', '0010'),
    ('data_1_re_in', '0011'),
    ('data_1_im_in', '0100'),
    ('data_2_re_in', '0101'),
    ('data_2_im_in', '1010'),
    ('data_3_re_in', '0111'),
    ('data_3_im_in', '1000')
]

vector_length = len(data[0][1])
for i in xrange(vector_length):
    for (name,vector) in data:
        print '%s<=\'%s\';'%(name,vector[vector_length-i-1])
    print 'wait for clk_period;'
    print ''

data = '1100010101011010'
for i in reversed(data):
    print "d1_in<='%s';"% i
    print "wait for clk_period;"
    print

