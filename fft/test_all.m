addpath '../fixpoint_matlab_simulator';
generate_all;
a=zeros(1000,1);
for i=1:1000
    double(fft8(int16(d(:,i))))-hardware_out(:,i)
    a(i)=any(double(fft8(int16(d(:,i))))-hardware_out(:,i));
end;
find(a)