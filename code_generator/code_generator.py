#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from tocsd import *
from simulator import simulate

env = Environment(
    loader=FileSystemLoader('./'), trim_blocks=True, lstrip_blocks=True)
temp_top = env.get_template('top.vhd.template')
temp_Dff_n = env.get_template('Dff_n.vhd.template')
temp_test_top = env.get_template('test_top.vhd.template')


def get_Dff_list(starters):
    Dff_list = set()
    for i in range(1, len(starters)):
        Dff_list.add((starters[i][0] - starters[i - 1][0], False))
    for s in starters:
        Dff_list.add((1, s[1] == '-'))
    return sorted(Dff_list)


def generate_Dff(n, init_1=False):
    return temp_Dff_n.render(n=n, init_1=init_1)


def generate_top(starters, Dff_list):
    return temp_top.render(starters=starters, Dff_list=Dff_list)


def generate_test_top(binarylist):
    return temp_test_top.render(binarylist=binarylist)

width = 16
multiplicator = 51557
multiplicand = 0.707

csdbin = sfi(multiplicand, 16, 15)
csd = bintocsd(csdbin)
multiplicator_bin = sfi(multiplicator, width, 0)

print 'multiplicator:', multiplicator
print 'multiplicator binary:', multiplicator_bin
print 'multiplicand:', multiplicand
print 'multiplicand csd:', csd

rst = simulate(multiplicator, csd, width)
print 'simulate result:', rst[0]
print 'simulate result binary:', rst[1]
print 'float result:', multiplicator * multiplicand

starters = calc_starter(csd)
Dff_list = get_Dff_list(starters)

with open('gen/test_top.vhd', 'w') as f:
    f.write(generate_test_top(reversed(multiplicator_bin)))

with open('gen/top.vhd', 'w') as f:
    f.write(generate_top(starters, Dff_list))

for Dff in Dff_list:
    with open('gen/Dff_' + str(Dff[0]) + ('_init_1' if Dff[1] else '') + '.vhd', 'w') as f:
        f.write(generate_Dff(Dff[0], Dff[1]))
