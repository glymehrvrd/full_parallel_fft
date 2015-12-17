function [result] = complexadd(data1,data2)
    result=complex(real(data1)+real(data2),imag(data1)+imag(data2));
end

