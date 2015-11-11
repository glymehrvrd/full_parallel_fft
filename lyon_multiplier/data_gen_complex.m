clc;
clear all;

% input data
d=[-7841+9346i 5013-2845i -2593-2812i];

% convert data to signed fixed-point num
d_fp=sfi(d,16,0);

d_re=parallel2serial(real(d_fp));
d_im=parallel2serial(imag(d_fp));
% input data, starts at time 3
t=0:numel(d_re)+3;
t=t';
d_re_in=timeseries([0; 0; 0; d_re; 0],t);
d_im_in=timeseries([0; 0; 0; d_im; 0],t);

% ctrl signal
d_ctrl=repmat(eye(16),size(d_fp,2)+10,1);
d_ctrl=fliplr(d_ctrl);

t=0:size(d_ctrl,1)+2;
ctrl=[zeros(2,16);d_ctrl;zeros(1,16)];
ctrl=[t' ctrl];
