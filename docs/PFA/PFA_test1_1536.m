%1536点FFT分解为三个512与512个3点，PFA算法
%indexing有两种方法，goods方法和中国剩余定理法

r = rand(1536,1);%产生0-1均匀测试向量
x = reshape(r,[3,512])';%转成512×3的矩阵

%中国剩余定理，k=（513k2+1024k1）mod 1536
%goods mapping: t=(512k2+3k1) mod 1536
%下标参考
for k1 = 0:511
    for k2 = 0:2
        k(1+k1,1+k2) = mod((1024*k2 + 513*k1),1536);
        t(1+k1,1+k2) = mod((512*k2 + 3*k1),1536);
    end
end;

R = fft(r); %直接做1536点FFT

%分解成为3×512点利用PFA，先做512点，再做3点
%数据reshape重新分组
for i = 0:511
    for j = 0:2
        X1(i+1,j+1) = r(1 + (mod((1024*j + 513*i),1536)));
        X2(i+1,j+1) = r(1 + (mod((512*j + 3*i),1536)));
    end;
end;

for j1 = 1:3 %512点FFT
    Y1(:,j1)=fft(X1(:,j1));
    Y2(:,j1)=fft(X2(:,j1));
end;

for i1 = 1:512
    Z1(i1,:)=fft(Y1(i1,:));
    Z2(i1,:)=fft(Y2(i1,:));
end;

for i2 = 1 : 512
    F1(i2,:)=fft(X1(i2,:));
    F2(i2,:)=fft(X2(i2,:));
end;
for j2 = 1 : 3
    T1(:,j2)=fft(F1(:,j2));
    T2(:,j2)=fft(F2(:,j2));
end;


