#pragma once

#define PI 3.141592653589793

struct complex
{
	int real;
	int imag;
};

struct param
{
	int* index;
	complex* w;
};

int conv_to_signed(int data, int width);
param calc_param(int m, int n);

complex complexadd(complex lhs, complex rhs);
complex complexsub(complex lhs, complex rhs);

int duplbits(int data, int length);
int bitget(int data, int pos);
int arith_rshift(int data, int length, int width);
int serial_adder(int lhs, int rhs, int width, int carry = 0);
int serial_subtractor(int lhs, int rhs, int width);

template <class T>
void pickarray(T const din[], T dout[], int start, int step, int length)
{
	int j = 0;
	for (int i = start; i < length; i += step , j++)
	{
		dout[j] = din[i];
	}
}

