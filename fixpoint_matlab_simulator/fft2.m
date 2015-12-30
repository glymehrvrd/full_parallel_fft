function [result,eachclass]=fft2(data,bypass)

    if nargin==1
        bypass=[0];
    end;

    r=real(data);
    i=imag(data);

    if bypass(1)==1
        result=data;
    else
        result = [complex(r(1)+r(2),i(1)+i(2)), complex(r(1)-r(2),i(1)-i(2))];
    end;
    eachclass={result(:)};
end