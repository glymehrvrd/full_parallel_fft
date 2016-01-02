function [result]=fft2(data,bypass,ordertest)

    if nargin==1
        bypass=[0];
        ordertest=false;
    elseif nargin==2
        ordertest=false;
    end;

    r=real(data);
    i=imag(data);

    if ordertest
        result=data;
    else
        if bypass(1)
            result=data;
        else
            result=[complex(r(1)+r(2),i(1)+i(2)), complex(r(1)-r(2),i(1)-i(2))];
        end;
    end;
end