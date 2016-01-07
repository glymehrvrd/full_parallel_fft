function [result] = mul(a,b)
    if bitget(a,16)~=bitget(a,15)
        % warning('mul is overflowed'));
    end;
    
    a=int32(a);
    b=int32(b);
    a=bitand(a,hex2dec('ffff'));
    b=bitand(b,hex2dec('ffff'));
    
    pp=bitand(a,duplbits(bitand(b,1),16));
    pp=bitor(pp,bitand(bitshift(pp,1),hex2dec('10000')));
    for i=1:14
        pp=serial_adder(pp,bitshift(bitand(a,duplbits(bitand(bitshift(b,-i),1))),1),0,17);
        pp=bitshift(pp,-1);
        pp=bitor(pp,bitand(bitshift(pp,1),hex2dec('10000')));
    end;
    pp=serial_adder(pp,bitshift(bitand(bitxor(a,hex2dec('ffff')),duplbits(bitshift(b,-15))),1),0,17);
    pp=bitshift(pp,-1);
    pp=serial_adder(pp,bitand(bitshift(b,-15),1));
    pp=bitand(pp,duplbits(1,16));
    result=typecast(uint16(pp),'int16');
end
