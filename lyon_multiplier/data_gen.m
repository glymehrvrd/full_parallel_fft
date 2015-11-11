clear all;

% input data
d=[-7841-9346, 15221, -5013, 10284]';

% calculate the should-be result
result1=bitshift(d*(-11586),-15,'int32');

% convert data to signed fixed-point num
d_fp=sfi(d,16,0);

% convert input data to serial stream, lsb outputs first
d_bool=zeros(size(d_fp,1),16);
for i=1:size(d_fp,1)
    tmp=d_fp(i);
    % due to multiplier property, 1st bit(msb) must equal to 2nd bit
    if tmp.bin(1)~=tmp.bin(2)
        error(['Input data overflows: ' num2str(tmp.dec)]);
    end;
    d_bool(i,:)=bitget(tmp,1:16);
end;
d_bool=d_bool';
d_bool=d_bool(:);
d_bool=boolean(d_bool);

% d1_in, starts at time 2
t=0:numel(d_bool)+2;
t=t';
d1_in=timeseries([0;0; d_bool; 0],t);

% ctrl signal
d_ctrl=repmat(eye(16),size(d_fp,2)+10,1);
d_ctrl=fliplr(d_ctrl);

t=0:size(d_ctrl,1)+2;
ctrl=[zeros(2,16);d_ctrl;zeros(1,16)];
ctrl=[t' ctrl];