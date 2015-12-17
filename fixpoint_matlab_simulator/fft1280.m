function [result,eachclass]=fft1280(data)
    [i,w]=calc_param(2,4);
    fft8=generate_fft(@fft2,2,i,w,@fft4,4);

    [i,w]=calc_param(8,8);
    fft64=generate_fft(fft8,8,i,w,fft8,8);

    [i,w]=calc_param(4,64);
    fft256=generate_fft(@fft4,4,i,w,fft64,64);

    [i,~]=calc_param(256,5);
    w=ones(256,5);
    fft1280_pre=generate_fft(fft256,256,i,w,@fft5,5);
    
    data=reorder(data,1280,'in');
    [data,eachclass]=fft1280_pre(data);
    result=reorder(data,1280,'out');
end