function [dout] = testorder_reorder(data,m,n,bypass)
% reorder data because the fft output index is not the same as the input

    group_num=2^nnz(bypass(1:log2(m))==1);
    group_len=m/group_num;

    dout=[];
    for i=1:group_len
        dout=[dout data(1+group_num*(i-1):group_num*i,:)];
    end;

end
