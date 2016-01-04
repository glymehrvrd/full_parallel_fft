[i,w]=calc_param(2,4);
w(4)=0.70703125-0.70703125i;
w(8)=-0.70703125-0.70703125i;
fft8_loss=generate_fft(@fft2,2,i,w,@fft4,4);

[i,w]=calc_param(2,8);
fft16_loss=generate_fft(@fft2,2,i,w,fft8_loss,8);

[i,w]=calc_param(4,8);
fft32_loss=generate_fft(@fft4,4,i,w,fft8_loss,8);

[i,w]=calc_param(8,8);
fft64_loss=generate_fft(fft8_loss,8,i,w,fft8_loss,8);

[i,w]=calc_param(2,64);
fft128_loss=generate_fft(@fft2,2,i,w,fft64_loss,64);

[i,w]=calc_param(4,64);
fft256_loss=generate_fft(@fft4,4,i,w,fft64_loss,64);

[i,w]=calc_param(8,64);
fft512_loss=generate_fft(fft8_loss,8,i,w,fft64_loss,64);

[i,w]=calc_param(16,64);
fft1024_loss=generate_fft(fft16_loss,16,i,w,fft64_loss,64);

[i,w]=calc_param(32,64);
fft2048_loss=generate_fft(fft32_loss,32,i,w,fft64_loss,64);
