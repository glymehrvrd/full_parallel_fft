function [result,eachclass]=fft3(data)
    result=int16(fft(double(data)));
    eachclass={result(:)};
end