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


def sfi(f, w, v):
    '''
    convert float to signed fix pointing number
    f: floating number
    w: bit width of the whole number
    v: bit width of the decimal part
    '''
    fpn = int(f * (1 << v))
    if f > 0:
        num_bin = bin(fpn)[2:]
    else:
        num_bin = bin(fpn + (1<<w))[2:]
    return '0' * (w - len(num_bin)) + num_bin


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


def test():
    fxnum = sfi(-0.707, 16, 14)
    print calc_starter('10-0-01010000000')
    print fxnum
    print bintocsd(fxnum)

if __name__ == '__main__':
    print bintocsd('1101')
    # test()
