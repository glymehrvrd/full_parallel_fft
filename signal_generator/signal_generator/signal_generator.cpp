//----------------------------------------------------------------------------
// randn.c: Gaussian distributed pseudo-random number generator.
//----------------------------------------------------------------------------

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <limits.h>

typedef int fract32;
typedef int cfract32;
typedef int cint32;

typedef void (*sig_func_t)(int n, double level, cfract32* dst); // Signal generator

int randn(double std);

void sig_gaussian(int n, double level, cfract32* dst);
void sig_qpsk(int n, double level, cfract32* dst);
void sig_dl_pusc(int n, double level, cfract32* dst);

int randn(double std)
// Generate normal distributed random number with standard deviation
// of 'std' by just adding up twelve uniform random ints.  This is
// not a high quality generator!  Values are saturated if required.
{
	int i;
	double sum = 0;

	for (i = 0; i < 12; i++)
		sum += rand();

	sum = (sum / RAND_MAX - 6.0) * std;

	if (sum > INT_MAX) return INT_MAX ;
	else if (sum < INT_MIN) return INT_MIN ;
	else return (int)sum;
}

// Input/Output buffers:
cint32 in_int[2048]; // The input buffer, 2048-aligned on TS
cint32 out_int[2048]; // Output buffer for MUT
double re_fp[2048], im_fp[2048]; // In/Out buffer for reference

// Configuration parameters:

#define NUM_STD_LEVELS 21
double std_level_dBov[NUM_STD_LEVELS] = {-60, -54, -48, -42, -36, -30, -24,
	-23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -6, 0};

// ---------------------------------------------------------------------
// Utility functions for accessing cint32 type:

inline static cfract32 make_cfract32(fract32 re, fract32 im)
// Condense two integers into a complex number, trancating the 16 LSB.
{
	return (im & 0xFFFF0000u) | ((re >> 16) & 0xFFFF);
}

inline static fract32 extract_real(cfract32 c)
// Fetch the real part of a complex number.  The result is returned in the 16 MSB.
{
	return c << 16;
}

inline static fract32 extract_imag(cfract32 c)
// Fetch the imaginary part of a complex number. The result is returned in the 16 MSB.
{
	return c & 0xFFFF0000;
}

// ---------------------------------------------------------------------
// Power related functions:

inline static double ratio_dB(double a, double b)
// Compute a/b in dB (power).  Invalid if a == 0 or b == 0.
{
	return 10 * log10(a / b);
}

inline static double power(double re, double im)
// Compute the power (magnitude squared) of a complex number.
{
	return re * re + im * im;
}

// ---------------------------------------------------------------------
// Signal generators:

void sig_gaussian(int n, double level, cfract32* dst)
// Generate a full-spectrum signal of white gaussian pseudo-noise.
// The n points have zero mean and 'level' standard deviation.
// (This operation is noticeably slow.)
{
	int i;
	for (i = 0; i < n; i++)
		dst[i] = make_cfract32(randn(level), randn(level));
}

void sig_qpsk(int n, double level, cfract32* dst)
// Generates a full spectrum of QPSK-like data.
{
	int i;
	int lev = (level <= INT_MAX) ? (int)level : INT_MAX;
	cfract32 qpsk[4] = {
		make_cfract32(lev, lev), make_cfract32(lev, -lev),
		make_cfract32(-lev, lev), make_cfract32(-lev, -lev)
	};

	for (i = 0; i < n; i++)
		dst[i] = qpsk[rand() & 3];
}

void sig_dl_pusc(int n, double level, cfract32* dst)
// Generates a spectrum of QPSK-like data with guardbands and DC zeroed.
{
	int i;
	int right_guard;

	sig_qpsk(n, level, dst);

	switch (n)
	{
	case 128:
		right_guard = 21;
		break;
	case 256:
		right_guard = 27;
		break;
	case 512:
		right_guard = 45;
		break;
	case 1024:
		right_guard = 91;
		break;
	case 2048:
		right_guard = 183;
		break;
	default:
		throw 0;
	}

	// Clear right guard (indices just less than n/2) and left guard
	// (indices n/2 and above).  Then clear the DC carrier (index 0).
	for (i = n / 2 - right_guard; i <= n / 2 + right_guard; i++)
		dst[i] = 0;
	dst[0] = 0;
}


// ---------------------------------------------------------------------
// Main testing functions:

void run_trial(FILE* f, sig_func_t input_func, int n, double level)
// Run one invocation of the MUT and the reference;
// return the signal and noise powers.
{
	// Generate input signal...
	input_func(n, level, in_int);
	for (int i = 0; i < n; ++i)
	{
		fprintf(f, "%d %d\n", extract_real(in_int[i]) >> 16, extract_imag(in_int[i]) >> 16);
	}
}

void run_test(sig_func_t input_func, int groupNum, int n,
              double gain_correction, const char* filename)
// Run a test set: N_trials at each of the standard input levels,
// for one particular MUT with one input model, and write results to a file.
{
	double level_dBov, level;
	int i, j;

	FILE* f = fopen(filename, "wt");

	// Loop over the input levels...
	for (j = 0; j < NUM_STD_LEVELS; j++)
	{
		srand(510200835); // Always use the same pseudo-random sequence
		level_dBov = std_level_dBov[j];
		level = ldexp(pow(10, level_dBov / 20.0), 31);

		// Loop over many trials...
		for (i = 0; i < groupNum; i++)
		{
			run_trial(f, input_func, n, level);
		}
	}

	fclose(f);
}

int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		return 7;
	}
	int groupNum = atoi(argv[1]);

	run_test(&sig_gaussian, groupNum, 1 << 6, pow(2, 3.0), "fft_64_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1 << 7, pow(2, 3.0), "fft_128_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1 << 8, pow(2, 3.0), "fft_256_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1 << 9, pow(2, 3.5), "fft_512_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1 << 10, pow(2, 4.0), "fft_1024_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1 << 11, pow(2, 4.5), "fft_2048_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1280, pow(2, 4.0), "fft_1280_gaussian.txt");
	run_test(&sig_gaussian, groupNum, 1536, pow(2, 4.0), "fft_1536_gaussian.txt");

	run_test(&sig_qpsk, groupNum, 1 << 8, pow(2, 3.0), "fft_256_qpsk.txt");
	run_test(&sig_qpsk, groupNum, 1 << 9, pow(2, 3.5), "fft_512_qpsk.txt");
	run_test(&sig_qpsk, groupNum, 1 << 10, pow(2, 4.0), "fft_1024_qpsk.txt");
	run_test(&sig_qpsk, groupNum, 1 << 11, pow(2, 4.5), "fft_2048_qpsk.txt");

	run_test(&sig_dl_pusc, groupNum, 1 << 8, pow(2, 3.0), "fft_256_dl_pusc.txt");
	run_test(&sig_dl_pusc, groupNum, 1 << 9, pow(2, 3.5), "fft_512_dl_pusc.txt");
	run_test(&sig_dl_pusc, groupNum, 1 << 10, pow(2, 4.0), "fft_1024_dl_pusc.txt");
	run_test(&sig_dl_pusc, groupNum, 1 << 11, pow(2, 4.5), "fft_2048_dl_pusc.txt");
	return 0;
}

