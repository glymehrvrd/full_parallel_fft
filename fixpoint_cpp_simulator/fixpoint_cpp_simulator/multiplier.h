#pragma once

#include "utils.h"

int arith_rshift(int data, int width, int length);
int serial_adder(int a, int b, int length = 16, int c = 0);
int serial_subtractor(int a, int b, int length = 16);
int mul(int a, int b, int length = 16);
complex complexmul(complex d1, complex d2, int length = 16);
