% calculate twiddle factor
function [index,w]=calc_param(m,n)
    r=0:m*n-1;
    index=reshape(r,[m,n]);
    w=zeros(m,n);
    for row=1:m
        for col=1:n
            w(row,col)=exp(-1i*2*pi*(row-1)*(col-1)/(m*n));
        end
    end
end
