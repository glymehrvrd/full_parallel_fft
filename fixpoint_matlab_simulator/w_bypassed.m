function [w] = w_bypassed(w,bypass)
% calculate the twiddle factor after bypass

group_num=2^nnz(bypass);
w=w(1:group_num:end,:);
w=int16(kron(double(w),ones(group_num,1)));

end

