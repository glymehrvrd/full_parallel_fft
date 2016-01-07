function [result]=fft2(data,bypass,ordertest)

    if nargin==1
        bypass=0;
        ordertest=false;
    elseif nargin==2
        ordertest=false;
    end;

    if ordertest
        result=data;
    else
        if bypass(1)
            result=data;
        else
            result=[complexadd(data(1),data(2)),complexsub(data(1),data(2))];
        end;
    end;
end