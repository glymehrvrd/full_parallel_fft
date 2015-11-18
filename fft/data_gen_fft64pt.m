clc;
clear all;

% input data, each row an input port, each column a data
d=rand(64,2)+1j*rand(64,2);
d=d*1000;

% convert data to signed fixed-point num
d_fp=sfi(d,16,0);

% convert input data to serial stream, lsb outputs first
d_re=zeros(size(d_fp,1),16*size(d_fp,2));
d_im=zeros(size(d_fp,1),16*size(d_fp,2));
for i=1:size(d_fp,1)
    d_re(i,:)=parallel2serial(real(d_fp(i,:)));
    d_im(i,:)=parallel2serial(imag(d_fp(i,:)));
end;

% make the bit order correct
d_re=flipud(d_re);
d_im=flipud(d_im);

% input data, starts at time 3
t=0:numel(d_re(1,:))+3;
t=t';
d_re_in=[zeros(3,size(d_re,1)); d_re'; zeros(1,size(d_re,1))];
d_re_in=[t d_re_in];

d_im_in=[zeros(3,size(d_im,1)); d_im'; zeros(1,size(d_im,1))];
d_im_in=[t d_im_in];

% ctrl signal
ctrl=gen_ctrl(size(d_fp,2));