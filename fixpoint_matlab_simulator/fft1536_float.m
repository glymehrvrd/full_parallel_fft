function [result,eachclass]=fft1536_float(data)
    [i,w]=calc_param(2,4);
    fft8_float=generate_fft_float(@fft2_float,2,i,w,@fft4_float,4);

    [i,w]=calc_param(8,8);
    fft64_float=generate_fft_float(fft8_float,8,i,w,fft8_float,8);
    
    [i,w]=calc_param(64,4);
    fft256_float=generate_fft_float(fft64_float,64,i,w,@fft4_float,4);

    [i,w]=calc_param(256,2);
    fft512_float=generate_fft_float(fft256_float,256,i,w,@fft2_float,2);

    [i,~]=calc_param(512,3);
    w=ones(512,3);
    fft1536_pre_float=generate_fft_float(fft512_float,512,i,w,@fft3_float,3);

    data=reorder(data,1536,'in');
    [data,eachclass]=fft1536_pre_float(data);
    result=reorder(data,1536,'out');
end