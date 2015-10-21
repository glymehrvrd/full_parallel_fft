function [parallel_out] = serial2parallel(data)

d_num=length(data)/16;
parallel_out=zeros(1,d_num);
for i=1:d_num
    p=data(1+16*(i-1):16*i);
    % different approach for +/- data
    if p(end)==0
        parallel_out(i)=bi2de(p);
    else
        parallel_out(i)=-(bitcmp(uint16(bi2de(p)))+1);
    end;
end;
