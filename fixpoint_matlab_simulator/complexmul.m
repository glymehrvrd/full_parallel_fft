function [result] = complexmul(data1,data2,bypass)
    if nargin==2
        bypass=0;
    end;

    if bypass==1
        result=data1;
    else
        a=real(data1);
        b=imag(data1);
        c=real(data2);
        d=imag(data2);
        
        if any(any((bitget(a,16,'int16')~=bitget(a,15,'int16')) | (bitget(b,16,'int16')~=bitget(b,15,'int16'))))
            throw(MException('complexmul','overflow'));
        end;
        mul1=int32(a).*int32(c);
        mul2=int32(b).*int32(d);
        mul3=int32(a).*int32(d);
        mul4=int32(b).*int32(c);

        mul1=int16(bitshift(mul1,-15));
        mul2=int16(bitshift(mul2,-15));
        mul3=int16(bitshift(mul3,-15));
        mul4=int16(bitshift(mul4,-15));

        x=bitshift(mul1-mul2,0);
        y=bitshift(mul3+mul4,0);

        result=complex(x,y);

        % for data2=1
        ind=find(data2==2^14);
        result(ind)=complex(bitshift(a(ind),-1,'int16'),bitshift(b(ind),-1,'int16'));

        % for data2=-j
        ind=find(data2==-1j*2^14);
        result(ind)=complex(bitshift(b(ind),-1,'int16'),bitshift(-a(ind),-1,'int16'));
    end;
end

