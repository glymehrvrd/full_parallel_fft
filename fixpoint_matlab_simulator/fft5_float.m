function [result,eachclass]=fft5_float(data)
    result=fft(data);
    eachclass={result(:)};
end