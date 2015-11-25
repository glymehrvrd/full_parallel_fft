 % set number of input data
d_num=10;
beginner=23+88;

d_out=[];
for i=1:32
    d_re_fp=fi2vec(d_re_out.data(beginner:beginner+16*d_num-1,i));
    d_im_fp=fi2vec(d_im_out.data(beginner:beginner+16*d_num-1,i));

    d_re=zeros(size(d_re_fp,1),d_num);
    d_im=zeros(size(d_im_fp,1),d_num);


    for i=1:size(d_re_fp,1)
        d_re(i,:)=serial2parallel(d_re_fp(i,:));
        d_im(i,:)=serial2parallel(d_im_fp(i,:));
    end;
    d_re=flipud(d_re);
    d_im=flipud(d_im);
    d_out=[d_out; d_re+d_im*1i];
end;
d_out=flipud(d_out);

float_out=fft(d);
hardware_out=d_out*64;