clear all;

d=[-15014, 15221, -5013, 10284]';
result1=bitshift(d*(-1061),-15,'int32');

d=sfi(d,16,0);

d_bool=zeros(size(d,1),16);
for i=1:size(d,1)
    tmp=d(i);
    if tmp.bin(1)~=tmp.bin(2)
        error(['Input data overflows: ' num2str(tmp.dec)]);
    end;
    d_bool(i,:)=bitget(tmp,1:16);
end;
d_bool=d_bool';
d_bool=d_bool(:);
d_bool=boolean(d_bool);

t=0:numel(d_bool)+2;
t=t';

d1_in=timeseries([0;0; d_bool; 0],t);

d_ctrl=repmat([1 zeros(1,15)],length(d)+10,1);
d_ctrl=d_ctrl';
d_ctrl=boolean(d_ctrl(:));

t=0:numel(d_ctrl)+2;
ctrl=timeseries([0;0; d_ctrl; 0],t);