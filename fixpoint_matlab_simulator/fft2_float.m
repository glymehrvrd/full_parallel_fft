function [result,eachclass]=fft2(data)
    result = fft(data);
    eachclass={result(:)};
end