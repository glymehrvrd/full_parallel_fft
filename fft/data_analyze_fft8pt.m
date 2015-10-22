% set number of input data
d_num=2;
beginner=7;

d_re_out.data=fi(d_re_out.data,0,8,0);
d_im_out.data=fi(d_im_out.data,0,8,0);

d_re_fp=fi2vec(d_re_out.data(beginner:beginner+16*d_num-1));
d_im_fp=fi2vec(d_im_out.data(beginner:beginner+16*d_num-1));

d_re=zeros(size(d_re_fp,1),d_num);
d_im=zeros(size(d_im_fp,1),d_num);

for i=1:size(d_re_fp,1)
    d_re(i,:)=serial2parallel(d_re_fp(i,:));
    d_im(i,:)=serial2parallel(d_im_fp(i,:));
end;

d_out=d_re+d_im*1i;

fft(d)
d_out