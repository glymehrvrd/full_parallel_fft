function [result] = complexmul(data1,data2,bypass)
    if nargin==2
        bypass=0;
    end;

    if bypass
        result=data1;
    else
        a=real(data1);
        b=imag(data1);
        c=real(data2);
        d=imag(data2);
        
        if any(any((bitget(a,16,'int16')~=bitget(a,15,'int16')) | (bitget(b,16,'int16')~=bitget(b,15,'int16'))))
%              warning('complexmul overflows');
        end;
        mul1=mul(a,c);
        mul2=mul(b,d);
        mul3=mul(a,d);
        mul4=mul(b,c);

        x=serial_adder(mul1,serial_subtractor(0,mul2));
        x=typecast(uint16(x),'int16');
        y=serial_adder(mul3,mul4);
        y=typecast(uint16(y),'int16');

        result=complex(x,y);

        % for data2=1
        ind=find(data2==2^14);
        result(ind)=complex(bitshift(a(ind),-1,'int16'),bitshift(b(ind),-1,'int16'));

        % for data2=-j
        ind=find(data2==-1j*2^14);
        result(ind)=complex(bitshift(b(ind),-1,'int16'),bitshift(-a(ind),-1,'int16'));
    end;
end

