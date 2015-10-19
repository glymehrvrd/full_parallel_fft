% input data, each row an input port, each column a data
d=[1+2i 3+4i;
   5+6i 7+8i];

% convert data to signed fixed-point num
d=sfi(d,16,0);

% convert input data to serial stream, lsb outputs first
d_re=zeros(size(d,1),16*size(d,2));
d_im=zeros(size(d,1),16*size(d,2));
for i=1:size(d,1)
    d_re(i,:)=parallel2serial(real(d(i,:)));
    d_im(i,:)=parallel2serial(imag(d(i,:)));
end;

% input data, starts at time 2
t=0:numel(d_re(1,:))+2;
t=t';
d0_re_in=timeseries([0; 0; d_re(1,:)'; 0],t);
d0_im_in=timeseries([0; 0; d_im(1,:)'; 0],t);
d1_re_in=timeseries([0; 0; d_re(2,:)'; 0],t);
d1_im_in=timeseries([0; 0; d_im(2,:)'; 0],t);

% ctrl signal
d_ctrl=repmat([1 zeros(1,15)],size(d,2)+10,1);
d_ctrl=d_ctrl';
d_ctrl=boolean(d_ctrl(:));

t=0:numel(d_ctrl)+2;
ctrl=timeseries([0;0; d_ctrl; 0],t);
