#include "multiplier.h"
#include "trad_stoc_mul.h"

int duplbits(int data, int length)
{
	int result;
	if (data == 0)
	{
		result = 0;
	}
	else
	{
		result = 0xffffffff >> (32 - length);
	}
	return result;
}

int serial_adder(int lhs, int rhs, int width, int carry)
{
	lhs = lhs & duplbits(1, width);
	rhs = rhs & duplbits(1, width);
	return (lhs + rhs + carry) & duplbits(1, width);
}

int serial_subtractor(int lhs, int rhs, int width)
{
	lhs = lhs & duplbits(1, width);
	rhs = rhs & duplbits(1, width);
	return serial_adder(lhs, ~rhs & duplbits(1, width), width, 1);
}

int bitget(int data, int pos)
{
	return data >> pos & 0x01;
}

int arith_rshift(int data, int length, int width)
{
	return data >> length | duplbits(bitget(data, width - 1), length) << (width - length);
}

int serial_mul(int lhs, int rhs, int width)
{
	if (lhs >> (width - 2) == 1 || lhs >> (width - 2) == 2)
	{
		// overflows
		// throw 1;
	}
	lhs = lhs & duplbits(1, width);
	rhs = rhs & duplbits(1, width);
	int pp = lhs & duplbits(rhs & 0x01, width);
	pp = pp | (pp << 1 & 0x01 << width);
	for (int i = 1; i < width - 1; i++)
	{
		pp = serial_adder(pp, (lhs & duplbits(bitget(rhs, i), width)) << 1, width + 1);
		pp >>= 1;
		pp = pp | (pp << 1 & 0x01 << width);
	}
	pp = serial_adder(pp, (~lhs & duplbits(bitget(rhs, width - 1), width)) << 1, width + 1);
	pp >>= 1;
	pp = serial_adder(pp, bitget(rhs, width - 1), width);

	return pp;
}

int mul(int lhs, int rhs, int width, multype type)
{
	switch (type)
	{
	case SERIAL_MUL:
		return serial_mul(lhs, rhs, width);
	case TRAD_STOC_MUL:
		return trad_stoc_mul(lhs, rhs, width);
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

