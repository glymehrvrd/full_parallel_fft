d_num=10;
% input data, each row an input port, each column a data
d=(rand(2048,d_num)-0.5)*2*2^10+(rand(2048,d_num)-0.5)*1j*2*2^10;

generate_all;
generate_all_float;

for i=1:1
    [fpout2048,clz]=fft2048(int16(d(:,i)));
    [flout2048,clz_float]=fft2048_float(d(:,i));
    
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
        stem(abs(real(clz_err{j})));
        % plot(real(clz_err{j})./real(clz_float{j}));
        subplot(2,1,2);
        stem(abs(imag(clz_err{j})));
        % plot(imag(clz_err{j})./imag(clz_float{j}));
    end;
    
    [fpout1280,clz]=fft1280(int16(d(:,i)));
    [flout1280,clz_float]=fft1280_float(d(:,i));
    
    fpout1280=double(fpout1280)*32;
    ferr=fpout1280-flout1280;
    
    figure;
    subplot(2,1,1);
    stem(abs(real(ferr)));
    subplot(2,1,2);
    stem(abs(imag(ferr)));

    [fpout1536,clz]=fft1536(int16(d(:,i)));
    [flout1536,clz_float]=fft1536_float(d(:,i));
    
    fpout1536=double(fpout1536)*64;
    ferr=fpout1536-flout1536;
    
    figure;
    subplot(2,1,1);
    stem(abs(real(ferr)));
    subplot(2,1,2);
    stem(abs(imag(ferr)));
end;