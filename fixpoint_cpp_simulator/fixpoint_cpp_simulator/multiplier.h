#pragma once

#include "utils.h"

enum multype { SERIAL_MUL, TRAD_STOC_MUL };

int arith_rshift(int data, int length, int width);
int serial_adder(int lhs, int rhs, int width, int carry = 0);
int serial_subtractor(int lhs, int rhs, int width);
int serial_mul(int lhs, int rhs, int width);

int mul(int lhs, int rhs, int width, multype type);
complex complexmul(complex lhs, complex rhs, int width, multype type);
