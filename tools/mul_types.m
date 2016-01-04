% get twiddle factor types after each type of bypass
num=4;

d_ori=(1:num).';
d=d_ori;
for i=2:log2(num)
    d=[d w_bypassed(d_ori,ones(1,i-1))];
end;

tp=[];
for i=1:size(d,1)
    d_i=d(i,:);
    d_i(d_i==1)=[];
    tp(i)=length(unique(d_i));
end;
tp=tp.';