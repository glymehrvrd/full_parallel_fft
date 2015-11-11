a=zeros(20,1);
for i=1:20
    double(fft2048(int16(d(:,i))))-hardware_out(:,i)
    a(i)=any(double(fft2048(int16(d(:,i))))-hardware_out(:,i));
end;
