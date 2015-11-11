function [result] = complexmul(data1,data2)
    a=real(data1);
    b=imag(data1);
    c=real(data2);
    d=imag(data2);
    mul1=int32(a).*int32(c-d);
    mul2=int32(b).*int32(c+d);
    mul3=int32(d).*int32(a-b);
    mul1=int16(bitshift(mul1,-15));
    mul2=int16(bitshift(mul2,-15));
    mul3=int16(bitshift(mul3,-15));
    x=mul1+mul3;
    y=mul2+mul3;
    result=complex(x,y);

    % for data2=1
    ind=find(data2==2^14);
    result(ind)=complex(bitshift(a(ind),-1),bitshift(b(ind),-1));

    % for data2=-j
    ind=find(data2==-1j*2^14);
    result(ind)=complex(bitshift(b(ind),-1),bitshift(-a(ind),-1));
end

