// fixpoint_cpp_simulator.cpp : Defines the entry point for the console application.
//

#include "utils.h"
#include <iostream>
#include <fstream>
#include "stdlib.h"
#include "math.h"
#include "fft_func.h"
#include "fixpoint_cpp_simulator.h"
#include "multiplier.h"

using namespace std;

int WIDTH;
multype MULTYPE;

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

void fftcore(double pdFftdin[], int iSize, int iDir)
{
	complex* din = new complex[iSize];
	complex* dout = new complex[iSize];
	initparam();

	for (int i = 0; i < iSize; i++)
	{
		din[i] = complex{(int)round(pdFftdin[i * 2] * 512),
			(int)round(pdFftdin[i * 2 + 1] * 512)};
	}
	switch (iSize)
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
	for (int i = 0; i < iSize; i++)
	{
		switch (iSize)
		{
		case 64:
			pdFftdin[i * 2] = dout[i].real * 8;
			pdFftdin[i * 2 + 1] = dout[i].imag * 8;
			break;
		case 128:
			pdFftdin[i * 2] = dout[i].real * 16;
			pdFftdin[i * 2 + 1] = dout[i].imag * 16;
			break;
		case 256:
			pdFftdin[i * 2] = dout[i].real * 16;
			pdFftdin[i * 2 + 1] = dout[i].imag * 16;
			break;
		case 512:
			pdFftdin[i * 2] = dout[i].real * 32;
			pdFftdin[i * 2 + 1] = dout[i].imag * 32;
			break;
		case 1024:
			pdFftdin[i * 2] = dout[i].real * 64;
			pdFftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 2048:
			pdFftdin[i * 2] = dout[i].real * 64;
			pdFftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 1280:
			pdFftdin[i * 2] = dout[i].real * 64;
			pdFftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		case 1536:
			pdFftdin[i * 2] = dout[i].real * 64;
			pdFftdin[i * 2 + 1] = dout[i].imag * 64;
			break;
		default:
			break;
		}
		pdFftdin[i * 2] = pdFftdin[i * 2] / 512;
		pdFftdin[i * 2 + 1] = pdFftdin[i * 2 + 1] / 512;
	}

	releaseparam();
	delete[] din;
	delete[] dout;
}

void print_progress(float progress)
{
	int barWidth = 70;

	printf("[");
	int pos = (int)(barWidth * progress);
	for (int i = 0; i < barWidth; ++i)
	{
		if (i < pos) printf("=");
		else if (i == pos) printf(">");
		else printf(" ");
	}
	printf("] %3d %%\r", int(progress * 100.0));
	fflush(stdout);
}

//#include "trad_stoc_mul.h"

int main(int argc, char* argv[])
{
	//	cout << serial_mul(0, - 1518500250,20) << endl;
	//	system("pause");
	//	return 0;
	// check input argument
	if (argc < 6)
	{
		cout << "not enough parameters." << endl;
		return 7;
	}

	int fftPt = atoi(argv[1]);
	int groupNum = atoi(argv[2]);
	char* din_path = argv[3];
	char* dout_path = argv[4];
//	WIDTH = atoi(argv[5]);
	WIDTH = 20;
	MULTYPE = (multype)atoi(argv[5]);

	initparam();

	complex din[2048];
	complex dout[2048] = {0};

	fstream fin(din_path, ios::in);
	fstream fout(dout_path, ios::out);
	for (int group = 0; group < groupNum; group++)
	{
		print_progress((float)(group + 1) / groupNum);
		// read data
		for (int i = 0; i < fftPt; i++)
		{
			fin >> din[i].real >> din[i].imag;
			din[i].real = din[i].real << 1;
			din[i].imag = din[i].imag << 1;
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
		float scale = 0;
		for (int i = 0; i < fftPt; i++)
		{
			switch (fftPt)
			{
			case 64:
				scale = 4 / 2.0;
				break;
			case 128:
				scale = 4 / 2.0;
				break;
			case 256:
				scale = 8 / 2.0;
				break;
			case 512:
				scale = 8 / 2.0;
				break;
			case 1024:
				scale = 8 / 2.0;
				break;
			case 2048:
				scale = 16 / 2.0;
				break;
			case 1280:
				scale = 8 / 2.0;
				break;
			case 1536:
				scale = 8 / 2.0;
				break;
			default:
				break;
			}
		}
		// write data after fft to file
		for (int i = 0; i < fftPt; i++)
		{
			fout << conv_to_signed(dout[i].real, WIDTH) * scale << " " << conv_to_signed(dout[i].imag, WIDTH) * scale << endl;
		}
	}
	fin.close();
	fout.close();

	releaseparam();
	return 0;
}

