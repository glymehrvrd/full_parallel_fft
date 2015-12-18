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

