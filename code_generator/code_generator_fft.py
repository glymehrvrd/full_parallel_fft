#!/usr/bin/env python

from jinja2 import Environment, FileSystemLoader
from calculate_fft_structure import *

env = Environment(
    loader=FileSystemLoader('templates/'), trim_blocks=True, lstrip_blocks=True)
temp_fft_ptx = env.get_template('fft_ptx.vhd.template')

with open('gen/fft_ptx.vhd', 'w') as f:
    index, w = calculate_fft_structure(4, 2)
    f.write(temp_fft_ptx.render(
        point=8, lhs_point=4, rhs_point=2, index=index, w=w))
