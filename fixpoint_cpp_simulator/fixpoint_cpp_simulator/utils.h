#pragma once

#define PI 3.141592653589793

struct complex
{
	short real;
	short imag;
};

struct param{
	int *index;
	complex *w;
};

param calc_param(int m, int n);

template <class T>
void pickarray(T const din[], T dout[], size_t start, size_t step, size_t length)
{
	size_t j = 0;
	for (size_t i = start; i < length; i += step, j++)
	{
		dout[j] = din[i];
	}
}