// fixpoint_cpp_simulator.cpp : Defines the entry point for the console application.
//

#include "utils.h"
#include <iostream>
#include <fstream>
#include "stdlib.h"
#include "fft_func.h"
#include "fixpoint_cpp_simulator.h"

using namespace std;

int WIDTH;

void print_param(param r)
{
	for (int i = 0; i < 2 * 4; i++)
	{
		cout << r.index[i] << endl;
	}
	for (int i = 0; i < 2 * 4; i++)
	{
		cout << r.w[i].real << " " << r.w[i].imag << "i" << endl;
	}
	system("pause");
}

void read_din(complex din[])
{
	fstream f("data.txt", ios::in);
	for (int i = 0; f >> din[i].real >> din[i].imag; i++);
	f.close();
}

void fftcore(double pdfftdin[], int isize, int idirec)
{
	complex* din = new complex[isize];
	complex* dout = new complex[isize];
	initparam();

	for (int i = 0; i < isize; i++)
	{
		din[i] = complex{(int)round(pdfftdin[i * 2] * 512),
			(int)round(pdfftdin[i * 2 + 1] * 512)};
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
	for (int i = 0; i < isize; i++)
	{
		switch (isize)
		{
		case 64:
			pdfftdin[i * 2] = dout[i].real * 8;
			pdfftdin[i * 2 + 1] = dout[i].imag * 8;
			break;
		case 128:
			pdfftdin[i * 2] = dout[i].real * 16;
			pdfftdin[i * 2 + 1] = dout[i].imag * 16;
			break;
		case 256:
			pdfftdin[i * 2] = dout[i].real * 16;
			pdfftdin[i * 2 + 1] = dout[i].imag * 16;
			break;
		case 512:
			pdfftdin[i * 2] = dout[i].real * 32;
			pdfftdin[i * 2 + 1] = dout[i].imag * 32;
			break;
		case 1024:
			pdfftdin[i * 2] = dout[i].real * 64;
			pdfftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 2048:
			pdfftdin[i * 2] = dout[i].real * 64;
			pdfftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 1280:
			pdfftdin[i * 2] = dout[i].real * 64;
			pdfftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 1536:
			pdfftdin[i * 2] = dout[i].real * 64;
			pdfftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		default:
			break;
		}
		pdfftdin[i * 2] = pdfftdin[i * 2] / 512;
		pdfftdin[i * 2 + 1] = pdfftdin[i * 2 + 1] / 512;
	}

	releaseparam();
	delete[] din;
	delete[] dout;
}

int convToSigned(int data, int width)
{
	if (data >> (width - 1))
	{
		return data - (1 << width);
	}
	else
	{
		return data;
	}
}

int main(int argc, char* argv[])
{
	//	cout << (short)mul(64767, 752) << endl;
	//	system("pause");
	//	return 0;
	// check input argument
	if (argc < 5)
		return 7;
	else if (argc == 5)
		WIDTH = 32;
	else
		WIDTH = atoi(argv[5]);

	int fftPt = atoi(argv[1]);
	int groupNum = atoi(argv[2]);
	char* din_path = argv[3];
	char* dout_path = argv[4];

	initparam();

	complex din[2048];
	complex dout[2048] = {0};

	fstream fin(din_path, ios::in);
	fstream fout(dout_path, ios::out);
	for (int group = 0; group < groupNum; group++)
	{
		printf("do %d group\n", group + 1);
		// read data
		for (int i = 0; i < fftPt; i++)
		{
			fin >> din[i].real >> din[i].imag;
		}
		// do fft
		switch (fftPt)
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
		// do scale adjustment
		int scale = 0;
		for (int i = 0; i < fftPt; i++)
		{
			switch (fftPt)
			{
			case 64:
				scale = 8;
				break;
			case 128:
				scale = 16;
				break;
			case 256:
				scale = 16;
				break;
			case 512:
				scale = 32;
				break;
			case 1024:
				scale = 64;
				break;
			case 2048:
				scale = 64;
				break;
			case 1280:
				scale = 64;
				break;
			case 1536:
				scale = 64;
				break;
			default:
				break;
			}
		}
		scale = 1;
		// write data after fft to file
		for (int i = 0; i < fftPt; i++)
		{
			fout << convToSigned(dout[i].real, WIDTH) * scale << " " << convToSigned(dout[i].imag, WIDTH) * scale << endl;
		}
	}
	fin.close();
	fout.close();

	releaseparam();
	return 0;
}
