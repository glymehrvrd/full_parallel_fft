function [result] = serial_adder(a,b,c,length)
    if nargin==2
        c=0;
        length=16;
    elseif nargin==1
        length=16;
    end;
    a=int32(a);
    b=int32(b);
    result=bitand(a+b+c,int32(duplbits(1,length)));
end