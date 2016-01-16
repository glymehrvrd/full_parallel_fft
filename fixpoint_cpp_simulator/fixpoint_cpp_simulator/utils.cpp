#include "utils.h"
#include "fixpoint_cpp_simulator.h"
#include <math.h>

int conv_to_signed(int data, int width)
{
	if (data > 0 && data >> (width - 1))
	{
		return data - (1 << width);
	}
	else
	{
		return data;
	}
}

param calc_param(int m, int n)
{
	param result;
	result.index = new int[m * n];
	result.w = new complex[m * n];

	for (int row = 0; row < m; row++)
	{
		for (int col = 0; col < n; col++)
		{
			result.index[row * n + col] = row * n + col;
			result.w[row * n + col].real = (int)round(cos(2 * PI * row * col / (m * n)) * (1 << (WIDTH - 1)));
			result.w[row * n + col].imag = (int)round(-sin(2 * PI * row * col / (m * n)) * (1 << (WIDTH - 1)));
		}
	}
	return result;
}

complex complexadd(complex lhs, complex rhs)
{
	complex result;
	result.real = serial_adder(lhs.real, rhs.real, WIDTH);
	result.imag = serial_adder(lhs.imag, rhs.imag, WIDTH);
	return result;
}

complex complexsub(complex lhs, complex rhs)
{
	complex result;
	result.real = serial_subtractor(lhs.real, rhs.real, WIDTH);
	result.imag = serial_subtractor(lhs.imag, rhs.imag, WIDTH);
	return result;
}

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
