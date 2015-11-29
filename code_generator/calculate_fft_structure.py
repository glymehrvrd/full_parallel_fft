import numpy as np
import cmath


def calculate_fft_structure(m, n):
    index = np.arange(m * n).reshape(m, n)
    w = np.ndarray(shape=(m, n), dtype=complex)
    for row in xrange(m):
        for col in xrange(n):
            w[row][
                col] = cmath.exp(-2j * cmath.pi * row * col / complex(m * n))
    return index, w

if __name__ == '__main__':
    index, w = calculate_fft_structure(4, 2)
    for i in xrange(8):
        print w[i/2,i%2]
    print w
    print index
