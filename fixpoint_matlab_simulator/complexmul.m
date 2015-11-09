function [result] = complexmul(data1,data2)
    % TODO: SPECIAL FOR data2==1 or -j
    a=real(data1);
    b=imag(data1);
    c=real(data2);
    d=imag(data2);
    mul1=a.*(c-d);
    mul2=b.*(c+d);
    mul3=d.*(a-b);
    mul1=fi(mul1,1,16,0,'RoundMode','floor')/2;
    mul2=fi(mul2,1,16,0,'RoundMode','floor')/2;
    mul3=fi(mul3,1,16,0,'RoundMode','floor')/2;
    x=mul1+mul3;
    y=mul2+mul3;
    x=fi(x,1,16,0,'RoundMode','floor');
    y=fi(y,1,16,0,'RoundMode','floor');
    result=x+1j*y;
    result=fi(result,1,16,0,'RoundMode','floor');
end

