#pragma once

typedef unsigned int uint;

void gen_sequence_allhead(uint num, uint* seq);
void gen_sequence_uniform(uint num, uint* seq);

void seq_xnor(uint *lhs, uint *rhs);
void seq_and(uint* lhs, uint* rhs);

int seq_to_num(uint *seq);
int trad_stoc_mul(int lhs, int rhs, int width);
