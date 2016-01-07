function [result,eachclass]=fft2_float(data)
    result = fft(data);
    eachclass={result(:)};
end