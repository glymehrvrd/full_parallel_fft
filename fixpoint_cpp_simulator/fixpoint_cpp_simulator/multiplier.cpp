#include "multiplier.h"

int duplbits(int a, int n = 16)
{
	int result = 0;
	if (a == 0)
	{
		result = 0;
	}
	else
	{
		result = (a << n) - 1;
	}
	return result;
}

int serial_adder(int a, int b, int length, int c)
{
	a = a & duplbits(1, length);
	b = b & duplbits(1, length);
	return (a + b + c) & duplbits(1, length);
}

int serial_subtractor(int a, int b, int length)
{
	a = a & duplbits(1, length);
	b = b & duplbits(1, length);
	return serial_adder(a, ~b & duplbits(1, length), length, 1);
}

int bitget(int data, int pos)
{
	return data >> pos & 0x01;
}

int arith_rshift(int data, int width, int length)
{
	return data >> length | duplbits(bitget(data, width - 1), length) << (width - length);
}

int mul(int a, int b, int length)
{
	a = a & duplbits(1, length);
	b = b & duplbits(1, length);
	int pp = a & duplbits(b & 0x01, length);
	pp = pp | (pp << 1 & 0x01 << length);
	for (int i = 1; i < length - 1; i++)
	{
		pp = serial_adder(pp, (a & duplbits(bitget(b, i), length)) << 1, length + 1);
		pp >>= 1;
		pp = pp | (pp << 1 & 0x01 << length);
	}
	pp = serial_adder(pp, (~a & duplbits(bitget(b, length - 1), length)) << 1, length + 1);
	pp >>= 1;
	pp = serial_adder(pp, bitget(b, length - 1), length);

	return pp;
}

complex complexmul(complex d1, complex d2, int length)
{
	complex result;
	// d2==1
	if (d2.real == 1 << (length - 2) && d2.imag == 0)
	{
		result.real = arith_rshift(d1.real, length, 1);
		result.imag = arith_rshift(d1.imag, length, 1);
	}
	// d2==-j
	else if (d2.real == 0 && d2.imag == -1 << (length - 2))
	{
		result.real = arith_rshift(d1.imag, length, 1);
		result.imag = arith_rshift(serial_subtractor(0, d1.real, length), length, 1);
	}
	else
	{
		short mul1 = mul(d1.real, d2.real, length);
		short mul2 = mul(d1.imag, d2.imag, length);
		short mul3 = mul(d1.real, d2.imag, length);
		short mul4 = mul(d1.imag, d2.real, length);

		result.real = serial_adder(mul1, serial_subtractor(0, mul2, length), length);
		result.imag = serial_adder(mul3, mul4, length);
	}
	return result;
}

