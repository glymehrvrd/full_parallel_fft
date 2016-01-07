function [result] = serial_subtractor(a,b,len)
    if nargin==2
        len=16;
    end;
    a=int32(a);
    b=int32(b);
    result=serial_adder(a,bitand(bitxor(b,int32(duplbits(1,len))),duplbits(1,len)),1,len);
end