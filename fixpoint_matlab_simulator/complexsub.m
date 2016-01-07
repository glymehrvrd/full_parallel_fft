function [result] = complexsub(data1,data2)
    r=serial_subtractor(real(data1),real(data2));
    i=serial_subtractor(imag(data1),imag(data2));
    
    r=uint16(r);
    i=uint16(i);
    
    r=typecast(r,'int16');
    i=typecast(i,'int16');
    
    result=complex(r,i);
end

