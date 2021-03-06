#!/usr/bin/env python


def get_bit(num, at):
    '''
    return bit of position `at`
    '''
    if at < 0:
        return 0
    else:
        return (num >> at) % 2


def twos_comp(val, bits):
    '''
    compute the 2's compliment of int value `val`
    '''
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val                         # return positive value as is


def sfi(f, w, v, result_type='number'):
    '''
    convert float to signed fix pointing number
    f: floating number
    w: bit width of the whole number
    v: bit width of the decimal part
    '''
    fpn = int(round(f * (1 << v)))
    if result_type != 'number':
        if f > 0:
            num_bin = bin(fpn)[2:]
        else:
            num_bin = bin(fpn + (1 << w))[2:]
        return '0' * (w - len(num_bin)) + num_bin
    else:
        return fpn


def calc_starter(csd):
    '''
    calcutate the starter index of each row
    '''
    offset = len(csd) - 1
    starters = []
    for i, digit in enumerate(csd):
        if digit == '1' or digit == '-':
            starters.append((offset - i, digit))
    return list(reversed(starters))


def bintocsd(binary):
    '''
    convert a binary into a canonical signed digit
    '''
    width = len(binary)
    state = 0  # state machine variable
    csd = []
    ind = 0
    while ind < width:
        if binary[ind] == '0':
            if state == 0:
                state = 1
            elif state == 1:
                state = 1
                csd.append('0')
            elif state == 2:
                state = 1
                csd.append('0')
                csd.append('1')
            elif state == 3:
                state = 1
                csd.append('0')
                csd.append('-')
        else:
            if state == 0:
                state = 0
                csd.append('1')
            elif state == 1:
                state = 2
            elif state == 2:
                state = 3
                csd.append('1')
            elif state == 3:
                state = 3
                csd.append('0')
        ind += 1
    if state == 1:
        csd.append('0')
    elif state == 2:
        csd.append('0')
        csd.append('1')
    elif state == 3:
        csd.append('0')
        csd.append('-')
    return ''.join(csd)


def calc_delay(pt, structure={2048:(32,64),32:(4,8),64:(8,8),16:(4,4),8:(2,4),4:2,2:1}):
    try:
        lhspt, rhspt=structure[pt]
    except:
        return structure[pt]

    try:
        l, r = structure[lhspt]
        delay_l = calc_delay(l*r, structure)
    except:
        delay_l = structure[lhspt]
        
    try:
        l, r = structure[rhspt]
        delay_r = calc_delay(l*r, structure)
    except:
        delay_r = structure[rhspt]

    return delay_l + 16 + delay_r


def test():
    print calc_delay(4)
    fxnum = sfi(-0.707, 16, 14)
    print calc_starter('10-0-01010000000')
    print fxnum
    print bintocsd(fxnum)

if __name__ == '__main__':
    # print bintocsd('1101')
    # test()
    print calc_delay(32)-calc_delay(8)
