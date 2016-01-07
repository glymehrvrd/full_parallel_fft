function [dout] = signal_gaussian(dBov,size)
% generate gaussian distributed signal

std=32768*db2mag(dBov);

dout_real=round(normrnd(0,std,size));
dout_imag=round(normrnd(0,std,size));

dout_real(dout_real>intmax('int16'))=intmax('int16');
dout_real(dout_real<intmin('int16'))=intmin('int16');
dout_imag(dout_imag>intmax('int16'))=intmax('int16');
dout_imag(dout_imag<intmin('int16'))=intmin('int16');


dout=complex(dout_real,dout_imag);

end

