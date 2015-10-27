clc;
clear all;

% input data
d=[6161-6151i 5013-2845i -2593-2812i];

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
d_ctrl=repmat([1 zeros(1,15)],size(d_fp,2)+10,1);
d_ctrl=d_ctrl';
d_ctrl=boolean(d_ctrl(:));

t=0:numel(d_ctrl)+2;
ctrl=timeseries([0; 0; d_ctrl; 0],t);
