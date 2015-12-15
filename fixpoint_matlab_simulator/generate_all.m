[i,w]=calc_param(2,4);
fft8=generate_fft(@fft2,2,i,w,@fft4,4);

[i,w]=calc_param(4,8);
fft32=generate_fft(@fft4,4,i,w,fft8,8);

[i,w]=calc_param(8,8);
fft64=generate_fft(fft8,8,i,w,fft8,8);

[i,w]=calc_param(64,2);
fft128=generate_fft(fft64,64,i,w,@fft2,2);

[i,w]=calc_param(64,4);
fft256=generate_fft(fft64,64,i,w,@fft4,4);

[i,w]=calc_param(256,2);
fft512=generate_fft(fft256,256,i,w,@fft2,2);

[i,w]=calc_param(512,2);
fft1024=generate_fft(fft512,512,i,w,@fft2,2);

[i,w]=calc_param(32,64);
fft2048=generate_fft(fft32,32,i,w,fft64,64);
