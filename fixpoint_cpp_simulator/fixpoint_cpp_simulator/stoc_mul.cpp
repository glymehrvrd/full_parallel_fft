#include "stdlib.h"
#include "math.h"
#include "stoc_mul.h"
#include "utils.h"

// generate stochastic sequence of width bit
// sequence should have 2^width bit
// little ending storage
// locate all ones to sequence header
// only works for width>=5
void gen_sequence_allhead(uint num, uint* seq, int width)
{
	int t = num;
	for (int i = 0; i < 1 << (width - 5); i++)
	{
		// header
		if (t >= (i + 1) * 32)
		{
			seq[i] = 0xffffffff;
		}
		// set the remainders to zero
		else if (t <= i * 32)
		{
			seq[i] = 0;
		}
		else
		{
			// set the last ones
			int rem = t % 32;
			seq[t / 32] = 0xffffffff << (32 - rem);
		}
	}
}

// ones are uniformly distributed in sequence
void gen_sequence_uniform(uint num, uint* seq, int width)
{
	float step = (float)(1 << width) / num;
	float pos = step;
	for (int i = 0; i < 1 << (width - 5); i++)
	{
		seq[i] = 0;
		while (round(pos) <= 32)
		{
			seq[i] |= 0x80000000 >> int(round(pos) - 1);
			pos += step;
		}
		pos -= 32;
	}
}

// perform bit-xnor between lhs and rhs, store result in lhs
void seq_xnor(uint* lhs, uint* rhs, uint* dout, int width)
{
	for (int i = 0; i < 1 << (width - 5); i++)
	{
		dout[i] = ~(lhs[i] ^ rhs[i]);
	}
}

// perform bit-and between lhs and rhs, store result in lhs
void seq_and(uint* lhs, uint* rhs, uint* dout, int width)
{
	for (int i = 0; i < 1 << (width - 5); i++)
	{
		dout[i] = lhs[i] & rhs[i];
	}
}

// convert stochastic sequence(unipolar) to number
int seq_to_num(uint* seq, int width)
{
	int one_count = 0;
	for (int i = 0; i < 1 << (width - 5); i++)
	{
		for (int j = 0; j < 32; j++)
		{
			one_count += 0x01 & (seq[i] >> j);
		}
	}
	return one_count;
}

// traditional stochastic multiplication
// for 20-bit signed two's complement binary
int trad_stoc_mul(int lhs, int rhs, int width)
{
	uint ulhseq[16384], urhseq[16384];

	lhs = conv_to_signed(lhs, width);
	rhs = conv_to_signed(rhs, width);

	int sign = (lhs >> 31 ^ rhs >> 31) ? -1 : 1;

	gen_sequence_uniform(abs(lhs), ulhseq, 19);
	gen_sequence_allhead(abs(rhs), urhseq, 19);

	seq_and(ulhseq, urhseq, ulhseq, 19);

	return sign * seq_to_num(ulhseq, 19);
}

// two segmented stochastic multiplication
// for 20-bit signed two's complement binary
int seg_two_stoc_mul(int lhs, int rhs, int width)
{
	uint A[32], B[32], C[32], D[32];

	lhs = conv_to_signed(lhs, width);
	rhs = conv_to_signed(rhs, width);

	int sign = (lhs >> 31 ^ rhs >> 31) ? -1 : 1;

	lhs = abs(lhs);
	rhs = abs(rhs) << 1; // now sequence is for 20-bit TCS (exclude the sign bit), so scale needs to be done.

	gen_sequence_uniform(lhs >> 10, A, 10);
	gen_sequence_allhead(lhs & 0x3FF, B, 10);
	gen_sequence_uniform(rhs >> 10, C, 10);
	gen_sequence_allhead(rhs & 0x3FF, D, 10);

	seq_and(A, D, A, 10);
	seq_and(B, C, B, 10);

	return sign * ((lhs >> 10) * (rhs >> 10) + seq_to_num(A, 10) + seq_to_num(B, 10));
}
