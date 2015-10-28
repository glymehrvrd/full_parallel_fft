x=rand(16,1);
result1=fft(x);

y=reshape(x,[4,4]).';

W=zeros(4,4);
for row=1:4
    for col=1:4
        W(row,col)=exp(-1j*2*pi*(col-1)*(row-1)/16);
    end;
end;

y=fft(y).*W;
y=y.';
result2=fft(y);

result1
% result2=result2.';
% result2=result2(:);
result2
