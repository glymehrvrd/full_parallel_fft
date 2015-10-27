clear all;

% input data
d=[-15014, 15221, -5013, 10284]';

% calculate the should-be result
result1=bitshift(d*(17000),-15,'int32');

% convert data to signed fixed-point num
d=sfi(d,16,0);

% convert input data to serial stream, lsb outputs first
d_bool=zeros(size(d,1),16);
for i=1:size(d,1)
    tmp=d(i);
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
d_ctrl=repmat([1 zeros(1,15)],length(d)+10,1);
d_ctrl=d_ctrl';
d_ctrl=boolean(d_ctrl(:));

t=0:numel(d_ctrl)+2;
ctrl=timeseries([0;0; d_ctrl; 0],t);