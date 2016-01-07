function [result,eachclass]=fft1280_float(data)
    [i,w]=calc_param(2,4);
    fft8_float=generate_fft_float(@fft2_float,2,i,w,@fft4_float,4);

    [i,w]=calc_param(8,8);
    fft64_float=generate_fft_float(fft8_float,8,i,w,fft8_float,8);

    [i,w]=calc_param(4,64);
    fft256_float=generate_fft_float(@fft4_float,4,i,w,fft64_float,64);

    [i,~]=calc_param(256,5);
    w=ones(256,5);
    fft1280_pre_float=generate_fft_float(fft256_float,256,i,w,@fft5_float,5);
    
    data=reorder(data,1280,'in');
    [data,eachclass]=fft1280_pre_float(data);
    result=reorder(data,1280,'out');
end