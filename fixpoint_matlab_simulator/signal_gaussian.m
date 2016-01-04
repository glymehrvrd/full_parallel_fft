function [dout] = signal_gaussian(dBov,size)
% generate gaussian distributed signal

std=32768*db2mag(dBov)/3;
dout=complex(round(normrnd(0,std,size)),round(normrnd(0,std,size)));

end

