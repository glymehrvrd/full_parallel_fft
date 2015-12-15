[i,w]=calc_param(2,4);
fft8_float=generate_fft_float(@fft2_float,2,i,w,@fft4_float,4);

[i,w]=calc_param(8,8);
fft64_float=generate_fft_float(fft8_float,8,i,w,fft8_float,8);

[i,w]=calc_param(4,8);
fft32_float=generate_fft_float(@fft4_float,4,i,w,fft8_float,8);

[i,w]=calc_param(32,64);
fft2048_float=generate_fft_float(fft32_float,32,i,w,fft64_float,64);
