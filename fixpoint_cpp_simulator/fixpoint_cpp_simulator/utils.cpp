#include "utils.h"
#include "fft_func.h"
#include <cmath>
#include "fixpoint_cpp_simulator.h"

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

