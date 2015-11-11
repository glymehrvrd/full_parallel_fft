function [result]=fft4(data)
    r=real(data);
    i=imag(data);
    result(1)=complex(r(1)+r(2)+r(3)+r(4)...
        ,i(1)+i(2)+i(3)+i(4));

    result(2)=complex(r(1)+i(2)-r(3)-i(4)...
        ,i(1)-r(2)-i(3)+r(4));

    result(3)=complex(r(1)-r(2)+r(3)-r(4)...
        ,i(1)-i(2)+i(3)-i(4));

    result(4)=complex(r(1)-i(2)-r(3)+i(4)...
        ,i(1)+r(2)-i(3)-r(4));
end