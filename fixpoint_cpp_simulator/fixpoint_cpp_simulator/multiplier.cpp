#include "multiplier.h"
#include "stoc_mul.h"
#include "serial_mul.h"

int mul(int lhs, int rhs, int width, multype type)
{
	switch (type)
	{
	case SERIAL_MUL:
		return serial_mul(lhs, rhs, width);
	case TRAD_STOC_MUL:
		return trad_stoc_mul(lhs, rhs, width);
	case SEGMENT_TWO_STOC_MUL:
		return seg_two_stoc_mul(lhs, rhs, width);
	default:
		return serial_mul(lhs, rhs, width);
	}
}

complex complexmul(complex lhs, complex rhs, int width, multype type)
{
	complex result;
	// d2==1
	if (rhs.real == 1 << (width - 1) && rhs.imag == 0)
	{
		result = lhs;
	}
	// d2==-j
	else if (rhs.real == 0 && rhs.imag == -1 << (width - 1))
	{
		result.real = lhs.imag;
		result.imag = serial_subtractor(0, lhs.real, width);
	}
	else
	{
		int mul1 = mul(lhs.real, rhs.real, width, type);
		int mul2 = mul(lhs.imag, rhs.imag, width, type);
		int mul3 = mul(lhs.real, rhs.imag, width, type);
		int mul4 = mul(lhs.imag, rhs.real, width, type);

		result.real = serial_adder(mul1, serial_subtractor(0, mul2, width), width);
		result.imag = serial_adder(mul3, mul4, width);
	}
	return result;
}

