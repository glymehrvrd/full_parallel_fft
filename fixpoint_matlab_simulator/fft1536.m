function [result,eachclass]=fft1536(data)
    [i,w]=calc_param(2,4);
    fft8=generate_fft(@fft2,2,i,w,@fft4,4);

    [i,w]=calc_param(8,8);
    fft64=generate_fft(fft8,8,i,w,fft8,8);

    [i,w]=calc_param(8,64);
    fft512=generate_fft(fft8,8,i,w,fft64,64);
    
    [i,w]=calc_param(512,3);
    w=ones(512,3);
    fft1536_pre=generate_fft(fft512,512,i,w,@fft3,3);

    data=reorder(data,1536,'in');
    [data,eachclass]=fft1536_pre(data);
    result=reorder(data,1536,'out');
end