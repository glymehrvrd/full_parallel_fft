function [result] = duplbits(a,n)
    if nargin==1
        n=16;
    end;

    mask=hex2dec('ffffffff');
    if a==0
        result=0;
    else
        result=bitshift(mask,n-32);
    end;
end