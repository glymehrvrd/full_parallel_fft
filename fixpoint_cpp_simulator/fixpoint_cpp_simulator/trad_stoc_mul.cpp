#include "stdlib.h"
#include "math.h"
#include "trad_stoc_mul.h"
#include "utils.h"
#include <iostream>

// generate stochastic sequence of 2^19 bit
// seq length is 16384 = 2^19/32, because two's complement is of 19-bit length (exclude the sign bit)
// little ending storage
// locate all ones to sequence header
void gen_sequence_allhead(uint num, uint* seq)
{
	int t = num;
	for (int i = 0; i < 16384; i++)
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
void gen_sequence_uniform(uint num, uint* seq)
{
	float step = (float)524288 / num;
	float pos = step;
	for (int i = 0; i < 16384; i++)
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
void seq_xnor(uint* lhs, uint* rhs)
{
	for (int i = 0; i < 16384; i++)
	{
		lhs[i] = ~(lhs[i] ^ rhs[i]);
	}
}

// perform bit-and between lhs and rhs, store result in lhs
void seq_and(uint* lhs, uint* rhs)
{
	for (int i = 0; i < 16384; i++)
	{
		lhs[i] = lhs[i] & rhs[i];
	}
}

// convert stochastic sequence(unipolar) to number
int seq_to_num(uint* seq)
{
	int one_count = 0;
	for (int i = 0; i < 16384; i++)
	{
		for (int j = 0; j < 32; j++)
		{
			one_count += 0x01 & (seq[i] >> j);
		}
	}
	//	return one_count - 524288;
	return one_count;
}

// stochastic multiplication
int trad_stoc_mul(int lhs, int rhs, int width)
{
	uint ulhseq[16384], urhseq[16384];

	lhs = conv_to_signed(lhs, width);
	rhs = conv_to_signed(rhs, width);

	int sign = (lhs >> 31 ^ rhs >> 31) ? -1 : 1;

	gen_sequence_uniform(abs(lhs), ulhseq);
	gen_sequence_allhead(abs(rhs), urhseq);

	seq_and(ulhseq, urhseq);

	return sign * seq_to_num(ulhseq);
}

