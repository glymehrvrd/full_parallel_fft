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

param calc_param(int m, int n);

template <class T>
void pickarray(T const din[], T dout[], int start, int step, int length)
{
	int j = 0;
	for (int i = start; i < length; i += step , j++)
	{
		dout[j] = din[i];
	}
}

