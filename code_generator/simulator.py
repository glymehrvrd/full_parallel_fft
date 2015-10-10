#!/usr/bin/env python

from tocsd import *


def adder(a, b, c):
    s = a + b + c
    return s % 2, s >> 1


def simulate(num, csd, width):
    '''
    simulate the multiplier
    num: multiplicand
    csd: multiplicator, represented in csd number
    width: bit width of the multiplicand
    '''
    starters = calc_starter(csd)

    s = [0] * len(starters)  # adder sum output
    # adder carrier output
    c = [0 if digit == '1' else 1 for (delay, digit) in starters]

    result = []

    # part right of the dot
    for i in xrange(len(csd) + width - 1):
        for j, (delay, digit) in enumerate(reversed(starters)):
            bit = get_bit(num, i - delay)
            if digit != '1':
                bit = ~bit % 2
            s[j], c[j] = adder(s[j - 1] if j != 0 else 0,
                               bit,
                               c[j])
        result.append(s[-1])

    # part left of the dot
    # for i in xrange(width):
    #     for j, (delay, digit) in enumerate(starters):
    #         s[j], c[j] = adder(s[j - 1] if j != 0 else 0,
    #                            get_bit(
    #                                num if digit == '1' else cnum, i + delay),
    #                            c[j])
    #     result.append(s[-1])
    binary = ''.join(map(str, reversed(result)))
    return int(binary, 2) / float(2 ** (len(csd) - 1)), binary
    # return int(binary,2)


def simulate_new(multiplicator, multiplicand, width):
    result = []
    s = [0] * (width + 1)
    if multiplicand[0] == '1':
        s[1:] = [int(multiplicator[i]) for i in xrange(width)]

    for i in xrange(1, width):
        result.append(s[-1])
        s = [0] + s[:-1]
        c = 0
        for j in xrange(width):
            s[width - j], c = adder(int(multiplicator[width - j - 1]) if multiplicand[width - i - 1]
                                                                         == '1' else 0, s[width - j], c)
        # s[1], c = adder(int(multiplicator[0]) if multiplicand[i] == '1' else 0, s[1], c)
        s[0] = c
    return s + list(reversed(result))


if __name__ == '__main__':
    width = 16
    multiplicator = 51557
    multiplicand = 0.707

    print 'multiplicator:', multiplicator
    print 'multiplicator binary:', sfi(multiplicator, width, 0)
    print 'multiplicand:', multiplicand
    print 'multiplicand binary:', sfi(multiplicand, 16, 15)

    # print 'simulate result:', simulate_new(sfi(multiplicator, 16, 15),
    print ''.join(map(str,simulate_new(sfi(multiplicator, 16, 15), sfi(multiplicand, 16, 15), 16)))

    print 'float result:', multiplicator * multiplicand
    print 'float result binary:', sfi(multiplicator * multiplicand, 16, 15)
