function [result]=fft2(data)
    result = [data(1)+data(2), data(1)-data(2)];
end