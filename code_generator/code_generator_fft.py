#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *
from utils import *

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')
temp_fft_ptx_ctrl = env.get_template('fft_ptx_ctrl.vhd.template')

# (lhs_point, rhs_point, delay)
# delay indicates the delay caused by the left-hand-side fft component
fft_list = [(4, 2, False),
            (8, 8, False),
            (4, 8, False),
            (4, 4, False),
            (32, 16, True),
            (32, 64, True)]

for lhs_point, rhs_point, istop in fft_list:
    delay = calc_delay(lhs_point)

    data_arrival_time = {
        'mul': delay, 'shifter': delay + 15, 'rhs_fft': delay + 16}
    ctrl_delay_offset = {'mul': -1, 'shifter': 0, 'rhs_fft': -1}
    ctrl_delay = dict([(k, (data_arrival_time[k] + v + 1) % 16)
                       for k, v in ctrl_delay_offset.iteritems()])
    print ctrl_delay

    point = lhs_point * rhs_point
    with open('gen/fft_pt%d.vhd' % point, 'w') as f:
        index, w = calculate_fft_structure(lhs_point, rhs_point)
        w_fp=[]
        for i,_ in enumerate(w):
            w_fp_ln=[]
            for j,_ in enumerate(w[i]):
                w_fp_ln.append((sfi(w[i,j].real, 16, 14), sfi(w[i,j].imag, 16, 14)))
            w_fp.append(w_fp_ln)
        f.write(temp_fft_ptx.render(
            point=point, lhs_point=lhs_point, rhs_point=rhs_point, index=index, w=w_fp, delay=ctrl_delay, istop=istop))

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
#         point=point, lhs_point=lhs_point, rhs_point=rhs_point, index=index, w=w, delay=ctrl_delay['mul'], istop=istop))
