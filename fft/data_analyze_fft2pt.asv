% set number of input data
d_num=2;
beginner=5;

d_re_s=fi2vec(d_re_out.data(beginner:beginner+16*d_num-1));
d_im_s=fi2vec(d_im_out.data(beginner:beginner+16*d_num-1));

d_re=zeros(d_num,1);
d_im=zeros(d_num,1);

for j=1:size(d_re_s,2)
    d_re(i)=serial2parallel(d_re_s(:,j));
    d_im(i)=serial2parallel(d_im_s(:,j));
end;

d0=d0_re+d0_im*1i;
d1=d1_re+d1_im*1i;
