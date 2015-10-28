#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *
from utils import *

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')

fft_list = [(4, 2),
            (8, 8),
            (4, 8),
            (64, 32)]

for lhs_point,rhs_point in fft_list:
    point=lhs_point*rhs_point
    with open('gen/fft_pt%d.vhd'%point,'w') as f:
        index, w = calculate_fft_structure(lhs_point, rhs_point)
        w = [(sfi(i.real, 16, 14), sfi(i.imag, 16, 14)) for i in w]
        f.write(temp_fft_ptx.render(
            point=point, lhs_point=lhs_point, rhs_point=rhs_point, index=index, w=w))
