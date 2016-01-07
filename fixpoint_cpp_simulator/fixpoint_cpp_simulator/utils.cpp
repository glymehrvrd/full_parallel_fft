#include "utils.h"
#include <cmath>

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
			result.w[row * n + col].real = round(cos(2 * PI * row * col / (m * n)) * (1 << 14));
			result.w[row * n + col].imag = round(-sin(2 * PI * row * col / (m * n)) * (1 << 14));
		}
	}
	return result;
}

