import numpy as np
import cmath


def calculate_fft_structure(m, n):
    index = np.arange(m * n).reshape(n, m).transpose()
    w = np.ndarray(shape=(m, n), dtype=complex)
    for row in xrange(m):
        for col in xrange(n):
            w[row][
                col] = cmath.exp(-2j * cmath.pi * row * col / complex(m * n))
    w = w.transpose().reshape(m * n, 1)[:, 0]
    return index, w

if __name__ == '__main__':
    index, w = calculate_fft_structure(4, 2)
    print w
