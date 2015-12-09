#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *
from utils import *
import math


def find_subsets(point, structure):
    if point == 32:
        point = point >> 1
        while point > 1:
            yield point
            point = point >> 1
    else:
        while structure.has_key(point):
            point, _ = structure[point]
            yield point


def to_bin(f, w=16):
    if f > 0:
        num_bin = bin(f)[2:]
    else:
        num_bin = bin(f + (1 << w))[2:]
    return '0' * (w - len(num_bin)) + num_bin


def log2(num):
    return int(math.log(num, 2))

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
env.filters['find_subsets'] = find_subsets
env.filters['to_bin'] = to_bin
env.filters['log2'] = log2
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')
temp_fft_ptx_ctrl = env.get_template('fft_ptx_ctrl.vhd.template')

# (lhs_point, rhs_point, delay)
# delay indicates the delay caused by the left-hand-side fft component
structure = {2048: (32, 64), 512: (16, 32), 64: (8, 8), 32: (
    4, 8), 16: (4, 4), 8: (2, 4), 4: (2, 2)}

# print list(find_subsets(8, structure))
# exit()

for point, (lhs_point, rhs_point) in structure.iteritems():
    if point in [4, 2]:
        continue
    print 'generating %d point fft, using %d fft and %d fft.' % (point, lhs_point, rhs_point)
    delay = calc_delay(lhs_point)
    data_arrival_time = {
        'mul': delay, 'shifter': delay + 15, 'rhs_fft': delay + 16}
    ctrl_delay_offset = {'mul': -1, 'shifter': 0, 'rhs_fft': -1}
    ctrl_delay = dict([(k, (data_arrival_time[k] + v + 1) % 16)
                       for k, v in ctrl_delay_offset.iteritems()])
    print ctrl_delay

    with open('gen/fft_pt%d.vhd' % point, 'w') as f:
        index, w = calculate_fft_structure(lhs_point, rhs_point)
        w_fp = []
        for i, _ in enumerate(w):
            w_fp_ln = []
            for j, _ in enumerate(w[i]):
                w_fp_ln.append(
                    (sfi(w[i, j].real, 16, 14), sfi(w[i, j].imag, 16, 14)))
            w_fp.append(w_fp_ln)
        f.write(temp_fft_ptx.render(
            point=point, lhs_point=lhs_point, rhs_point=rhs_point,
            structure=structure, index=index, w=w_fp,
            delay=ctrl_delay, istop=(point == 2048), gen_all_fft=(point in [2048, 32])))

# lhs_point, rhs_point, _ = fft_list[-1]
# point = lhs_point * rhs_point
# with open('gen/fft_pt%d.vhd' % point, 'w') as f:
#     delay = calc_delay(lhs_point)

#     data_arrival_time = {
#         'mul': delay, 'shifter': delay + 15, 'rhs_fft': delay + 16}
#     ctrl_delay_offset = {'mul': -1, 'shifter': 0, 'rhs_fft': -1}
#     ctrl_delay = dict([(k, (data_arrival_time[k] + v + 1) % 16)
#                        for k, v in ctrl_delay_offset.iteritems()])

#     index, w = calculate_fft_structure(lhs_point, rhs_point)
#     w = [(sfi(i.real, 16, 14), sfi(i.imag, 16, 14)) for i in w]
#     f.write(temp_fft_ptx_ctrl.render(
# point=point, lhs_point=lhs_point, rhs_point=rhs_point, index=index, w=w,
# delay=ctrl_delay['mul'], istop=istop))
