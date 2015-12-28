function [result] = complexmul(a,b)
    if bitget(a,16)~=bitget(a,15)
        throw(MException('mul','overflow'));
    end;
    result=int32(a).*int32(b);
    result=int16(bitshift(result,-15));
end

