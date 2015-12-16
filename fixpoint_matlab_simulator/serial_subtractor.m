function [result] = serial_subtractor(a,b)
    result=serial_adder(a,serial_adder(~b,1))
end

