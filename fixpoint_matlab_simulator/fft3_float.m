function [result,eachclass]=fft3_float(data)
    result=fft(data);
    eachclass={result(:)};
end