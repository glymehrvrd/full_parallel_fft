% set number of input data
d_num=4;
d=simout.data(19:19+16*d_num-1);

% retrieve calculation result from serial output
p=zeros(d_num,16);
results=zeros(d_num,1);
for i=1:d_num
    p(i,:)=d(1+16*(i-1):16*i);
    % different approach for +/- data
    if p(i,end)==0
        results(i)=bi2de(p(i,:));
    else
        results(i)=-(bitcmp(bi2de(p(i,:)),'uint16')+1);
    end;
end;

