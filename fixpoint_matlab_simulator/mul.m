function [result] = mul(a,b)
    if a(16)~=a(15)
        throw(MException('mul','overflow'));
    end;

    pp=a&b(1);
    pp(17)=pp(16);
    for i=2:15
        pp=serial_adder(pp,[0 a&b(i)]);
        pp=pp(2:17);
        pp(17)=pp(16);
    end;
    pp=serial_adder(pp,[0 (~a)&b(16)]);
    pp=pp(2:17);
    pp=serial_adder(pp,[b(16) zeros(1,15)]);
    
    result=pp;
end

