#pragma once
#include <map>
#include "utils.h"

void initparam();
void releaseparam();
void fft2(complex const din[], complex dout[]);
void fft3(complex const din[], complex dout[]);
void fft4(complex const din[], complex dout[]);
void fft5(complex const din[], complex dout[]);
void fft8(complex const din[], complex dout[]);
void fft16(complex const din[], complex dout[]);
void fft32(complex const din[], complex dout[]);
void fft64(complex const din[], complex dout[]);
void fft128(complex const din[], complex dout[]);
void fft256(complex const din[], complex dout[]);
void fft512(complex const din[], complex dout[]);
void fft1024(complex const din[], complex dout[]);
void fft2048(complex const din[], complex dout[]);
void fft1280(complex const din[], complex dout[]);
void fft1536(complex const din[], complex dout[]);

typedef void (*fftx_func)(complex const [], complex []);

void fftx(complex const din[], complex dout[], fftx_func lfft, int m, int* index, complex* w, fftx_func rfft, int n);

