function [x,y] = complexmul(a,b,c,d)
    % for data2=1
    if all(c==bitget(2^14,1:16))
        x=[a(2:16) a(16)];
        y=[b(2:16) a(16)];
    % for data2=-j
    elseif all(d==bitget(-2^14,1:16,'int16'))
        x=[b(2:16) b(16)];
        y=serial_adder(~a(1:16),1);
        y=[y(2:16) y(16)];
    else
        mul1=mul(a,c);
        mul2=mul(b,d);
        mul3=mul(a,d);
        mul4=mul(b,c);

        x=serial_adder(mul1,serial_adder(~mul2,1));
        y=serial_adder(mul3,mul4);
    end;
end

