#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *
from utils import *

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')

# (lhs_point, rhs_point, delay)
# delay indicates the delay caused by the left-hand-side fft component
fft_list = [(4, 2),
            (8, 8),
            (4, 8),
            (32, 64)]

for lhs_point, rhs_point in fft_list:
    delay = cal_delay(lhs_point)

    data_arrival_time = {
        'mul': delay, 'shifter': delay + 15, 'rhs_fft': delay + 16}
    ctrl_delay_offset = {'mul': -1, 'shifter': 0, 'rhs_fft': -1}
    ctrl_delay = dict([(k, (data_arrival_time[k] + v + 1) % 16)
                       for k, v in ctrl_delay_offset.iteritems()])
    print ctrl_delay

    point = lhs_point * rhs_point
    with open('gen/fft_pt%d.vhd' % point, 'w') as f:
        index, w = calculate_fft_structure(lhs_point, rhs_point)
        w = [(sfi(i.real, 16, 14), sfi(i.imag, 16, 14)) for i in w]
        f.write(temp_fft_ptx.render(
            point=point, lhs_point=lhs_point, rhs_point=rhs_point, index=index, w=w, delay=ctrl_delay['mul']))
