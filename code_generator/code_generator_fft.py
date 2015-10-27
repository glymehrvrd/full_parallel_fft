#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *
from utils import *

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')

with open('gen/fft_ptx.vhd', 'w') as f:
    index, w = calculate_fft_structure(4, 2)
    print w
    w = [(sfi(i.real, 16, 14),sfi(i.imag, 16, 14)) for i in w]
    print w
    f.write(temp_fft_ptx.render(
        point=8, lhs_point=4, rhs_point=2, index=index, w=w))

