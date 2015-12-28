// fixpoint_cpp_simulator.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "utils.h"
#include <iostream>
#include <fstream>
#include "stdlib.h"
#include "multiplicator.h"
#include "fft_func.h"
using namespace std;

void print_param(param r)
{
	for (size_t i = 0; i < 2 * 4; i++)
	{
		cout << r.index[i] << endl;
	}
	for (size_t i = 0; i < 2 * 4; i++)
	{
		cout << r.w[i].real << " " << r.w[i].imag << "i" << endl;
	}
	system("pause");
}

void read_din(complex din[])
{
	fstream f("data.txt", ios::in);
	for (size_t i = 0; f >> din[i].real >> din[i].imag; i++);
	f.close();
}

void fftcore(double pdfftdin[], int isize, int idirec)
{
	complex *din = new complex[isize];
	complex *dout = new complex[isize];
	initparam();

	for (size_t i = 0; i < isize; i++)
	{
		din[i] = complex{ round(pdfftdin[i * 2] * 1024),
			round(pdfftdin[i * 2 + 1] * 1024) };
	}
	switch (isize)
	{
		case 64:
			fft64(din, dout);
			break;
		case 128:
			fft128(din, dout);
			break;
		case 256:
			fft256(din, dout);
			break;
		case 512:
			fft512(din, dout);
			break;
		case 1024:
			fft1024(din, dout);
			break;
		case 2048:
			fft2048(din, dout);
			break;
		case 1280:
			fft1280(din, dout);
			break;
		case 1536:
			fft1536(din, dout);
			break;
		default:
			break;
	}
	for (size_t i = 0; i < isize; i++)
	{
		pdfftdin[i * 2] = dout[i].real / 1024.0;
		pdfftdin[i * 2 + 1] = dout[i].imag / 1024.0;
	}

	releaseparam();
	delete[] din;
	delete[] dout;
}

int _tmain(int argc, _TCHAR* argv[])
{
	initparam();

	complex a[2048];
	complex b[2048] = {0};
	read_din(a);

	fft1536(a, b);

	fstream f("d:\\dout.txt", ios::out);
	for (size_t i = 0; i < 1536; i++)
	{
		f << b[i].real << " " << b[i].imag << endl;
	}
	f.close();

	system("pause");

	releaseparam();
	return 0;
}

