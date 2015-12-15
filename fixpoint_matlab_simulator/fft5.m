function [result,eachclass]=fft5(data)
    result=int16(fft(double(data)));
    eachclass={result(:)};
end