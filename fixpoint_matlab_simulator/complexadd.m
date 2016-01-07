function [result] = complexadd(data1,data2)
    r=serial_adder(real(data1),real(data2));
    i=serial_adder(imag(data1),imag(data2));
    
    r=uint16(r);
    i=uint16(i);
    
    r=typecast(r,'int16');
    i=typecast(i,'int16');
    
    result=complex(r,i);
end

