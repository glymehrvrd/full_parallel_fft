%1280点FFT可以分解为256×5点
%PFA goods and CRL

r = rand(1280,1);
R = fft(r); 

%中国剩余定理CRL，k = 256k2 + 1025k1 mod 1280
%goods: k = 256k2 + 5k1 mod 1280

for k1 = 0:255
    for k2 = 0:4
        goods(1+k1,1+k2) = mod((256*k2 + 1025*k1),1280);%下标输出
        crl(1+k1,1+k2) = mod((256*k2 + 5*k1),1280);
    end;
end;

for i = 1 : 256
    Y1(i,:)=fft(X1(i,:));
    Y2(i,:)=fft(X2(i,:));
end;


for j = 1 : 5
    Z1(:,j)=fft(Y1(:,j));
    Z2(:,j)=fft(Y2(:,j));
end;

for j1 = 1 : 5
    T1(:,j1)=fft(X1(:,j1));
    T2(:,j1)=fft(X2(:,j1));
end;
for i1 = 1 : 256
    F1(i1,:)=fft(T1(i1,:));
    F2(i1,:)=fft(T2(i1,:));
end;

