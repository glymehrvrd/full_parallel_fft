#pragma once

#include "utils.h"

int arith_rshift(int data, int width, int length);
int serial_adder(int a, int b, int length, int c = 0);
int serial_subtractor(int a, int b, int length);
int mul(int a, int b, int);
complex complexmul(complex d1, complex d2, int length);
