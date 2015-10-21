clc;
clear all;

% input data, each row an input port, each column a data
d=[-5014+5221i -5013-284i;
   -5013+284i -5014-5221i;
   -5013-284i -5013-284i;
   -5014+5221i 5013-284i];

% convert data to signed fixed-point num
d_fp=sfi(d,16,0);

% convert input data to serial stream, lsb outputs first
d_re=zeros(size(d_fp,1),16*size(d_fp,2));
d_im=zeros(size(d_fp,1),16*size(d_fp,2));
for i=1:size(d_fp,1)
    d_re(i,:)=parallel2serial(real(d_fp(i,:)));
    d_im(i,:)=parallel2serial(imag(d_fp(i,:)));
end;

% input data, starts at time 3
t=0:numel(d_re(1,:))+3;
t=t';
d_re_in=timeseries([0; 0; 0; vec2fi(d_re)'; 0],t);
d_im_in=timeseries([0; 0; 0; vec2fi(d_im)'; 0],t);

% ctrl signal
d_ctrl=repmat([1 zeros(1,15)],size(d_fp,2)+10,1);
d_ctrl=d_ctrl';
d_ctrl=boolean(d_ctrl(:));

t=0:numel(d_ctrl)+2;
ctrl=timeseries([0; 0; d_ctrl; 0],t);
