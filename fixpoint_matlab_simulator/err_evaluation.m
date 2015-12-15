d_num=10;
% input data, each row an input port, each column a data
d=(rand(2048,d_num)-0.5)*2*2^10+(rand(2048,d_num)-0.5)*1j*2*2^10;

generate_all;
generate_all_float;

for i=1:1
    [fpout,clz]=fft2048(int16(d(:,i)));
    [flout,clz_float]=fft2048_float(d(:,i));
    
    clz=cellfun(@double,clz,'UniformOutput',false);
    clz{3}=clz{3}*2;
    clz{4}=clz{4}*4;
    clz{5}=clz{5}*4;
    clz{6}=clz{6}*8;
    clz{7}=clz{7}*16;
    clz{8}=clz{8}*16;
    clz{9}=clz{9}*32;
    clz{10}=clz{10}*64;
    clz{11}=clz{11}*64;
    clz_err=cellfun(@minus,clz,clz_float,'UniformOutput',false);
    
    for j=1:size(clz_err,2)
        figure;
        subplot(2,1,1);
        plot(real(clz_err{j})/real(clz_float{j}));
        subplot(2,1,2);
        plot(imag(clz_err{j})/imag(clz_float{j}));
    end;
end;