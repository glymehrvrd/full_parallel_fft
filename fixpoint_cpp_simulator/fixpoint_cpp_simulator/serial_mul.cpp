#include "utils.h"

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