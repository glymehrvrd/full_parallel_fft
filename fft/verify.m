disp('error cased by first fft');
[fft(d([1 3 5 7])); fft(d([2 4 6 8]))]-(d_stage_re+1j*d_stage_im)

disp('error caused by multiplier');
(d_stage_re+1i*d_stage_im).*w-(d_mul_re+1j*d_mul_im)*2

disp('error caused by second fft');
