function [result] = serial_adder(a,b)
    if length(a)<length(b)
        a=[a zeros(1,length(b)-length(a))];
    elseif length(b)<length(a)
        b=[b zeros(1,length(a)-length(b))];
    end;

    result=zeros(1,length(a));
    c=0;
    for i=1:length(a)
        result(i)=mod(a(i)+b(i)+c,2);
        c=floor((a(i)+b(i)+c)/2);
    end;
end

