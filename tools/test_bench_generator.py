# generate test vector for fft

data = [
    ('data_0_re_in', '0011010000100100'),
    ('data_0_im_in', '0011110101001000'),
    ('data_1_re_in', '0011100111111000'),
    ('data_1_im_in', '0011110111000001'),
    ('data_2_re_in', '0000100000100001'),
    ('data_2_im_in', '0000101000010110'),
    ('data_3_re_in', '0011101001110101'),
    ('data_3_im_in', '0011111000011110'),
    ('data_4_re_in', '0010100001111001'),
    ('data_4_im_in', '0011110101000010'),
    ('data_5_re_in', '0000011000111110'),
    ('data_5_im_in', '0001111100010000'),
    ('data_6_re_in', '0001000111010011'),
    ('data_6_im_in', '0011001100111000'),
    ('data_7_re_in', '0010001100000000'),
    ('data_7_im_in', '0000100100010101')
]

vector_length = len(data[0][1])
for i in xrange(vector_length):
    for (name, vector) in data:
        print '%s<=\'%s\';' % (name, vector[vector_length - i - 1])
    print 'wait for clk_period;'
    print ''

# data = '1100010101011010'
# for i in reversed(data):
#     print "d1_in<='%s';"% i
#     print "wait for clk_period;"
#     print

# data_re_in='0001100000010001' # 6161
# data_im_in='1110011111111001' # -6151

# for i in reversed(range(len(data_re_in))):
#     print "data_re_in<='%s';"%data_re_in[i]
#     print "data_im_in<='%s';"%data_im_in[i]
#     print 'wait for clk_period;'
#     print
