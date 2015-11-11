function [result]=fft2(data)
    r=real(data);
    i=imag(data);

    result = [complex(r(1)+r(2),i(1)+i(2)), complex(r(1)-r(2),i(1)-i(2))];
end