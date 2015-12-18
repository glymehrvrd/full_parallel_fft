#include "stdafx.h"
#include "multiplicator.h"

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

int serial_adder(int a, int b, int c, int length)
{
	return (a + b + c) & duplbits(1, length);
}

int serial_subtractor(int a, int b, int length)
{
	return serial_adder(a, ~b & duplbits(1, length), 1, length);
}

short mul(short a, short b)
{
	int pp = a & duplbits(b & 0x01, 16);
	pp = pp | ((pp << 1) & 0x10000);
	for (size_t i = 1; i < 15; i++)
	{
		pp = serial_adder(pp, (a & duplbits(b >> i & 0x01)) << 1, 0, 17);
		pp >>= 1;
		pp = pp | ((pp << 1) & 0x10000);
	}
	pp = serial_adder(pp, (~a & duplbits(b >> 15)) << 1, 0, 17);
	pp >>= 1;
	pp = serial_adder(pp, b >> 15 & 0x01);

	return pp;
}

complex complexmul(complex d1, complex d2)
{
	complex result;
	// d2==1
	if (d2.real == 1 << 14 && d2.imag == 0)
	{
		result.real = d1.real >> 1;
		result.imag = d1.imag >> 1;
	}
	// d2==-j
	else if (d2.real == 0 && d2.imag == -1 << 14)
	{
		result.real = d1.imag >> 1;
		result.imag = (short)serial_subtractor(0, d1.real) >> 1;
	}
	else
	{
		short mul1 = mul(d1.real, d2.real);
		short mul2 = mul(d1.imag, d2.imag);
		short mul3 = mul(d1.real, d2.imag);
		short mul4 = mul(d1.imag, d2.real);

		result.real = serial_adder(mul1, serial_subtractor(0, mul2));
		result.imag = serial_adder(mul3, mul4);
	}
	return result;
}

