function [parallel_out] = serial2parallel(data)

d_num=length(data)/16;
parallel_out=zeros(d_num,1);
for i=1:d_num
    p=data(1+16*(i-1):16*i)';
    % different approach for +/- data
    if p(end)==0
        parallel_out(i)=bi2de(p);
    else
        parallel_out(i)=-(bitcmp(bi2de(p),'uint16')+1);
    end;
end;
