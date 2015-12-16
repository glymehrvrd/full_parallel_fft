function [result]=fft2(data)

    result={{serial_adder(data{1}{1},data{2}{1}),...  % real
        serial_adder(data{1}{2},data{2}{2})},...     % imaginary
        {serial_subtractor(data{1}{1},data{2}{1}),... % real
        serial_subtractor(data{1}{2},data{2}{2})}};   % imaginary

end