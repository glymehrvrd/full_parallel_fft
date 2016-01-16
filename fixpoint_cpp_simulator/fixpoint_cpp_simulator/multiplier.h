#pragma once

#include "utils.h"

enum multype { SERIAL_MUL, TRAD_STOC_MUL, SEGMENT_TWO_STOC_MUL };

int mul(int lhs, int rhs, int width, multype type);
complex complexmul(complex lhs, complex rhs, int width, multype type);
