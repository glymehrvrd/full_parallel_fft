[i,w]=calc_param(4,2);
fft8=generate_fft(@fft4,4,i,w,@fft2,2);

[i,w]=calc_param(8,8);
fft64=generate_fft(fft8,8,i,w,fft8,8);

[i,w]=calc_param(4,8);
fft32=generate_fft(@fft4,4,i,w,fft8,8);

[i,w]=calc_param(32,64);
fft2048=generate_fft(fft32,32,i,w,fft64,64);
