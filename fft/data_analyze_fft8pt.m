% set number of input data
d_num=2;
beginner=22;
beginner_stage=5;
beginner_mul=21;

d_re_out.data=fi(d_re_out.data,0,8,0);
d_im_out.data=fi(d_im_out.data,0,8,0);

stage_re.data=fi(stage_re.data,0,8,0);
stage_im.data=fi(stage_im.data,0,8,0);

mul_re.data=fi(mul_re.data,0,8,0);
mul_im.data=fi(mul_im.data,0,8,0);

d_re_fp=fi2vec(d_re_out.data(beginner:beginner+16*d_num-1));
d_im_fp=fi2vec(d_im_out.data(beginner:beginner+16*d_num-1));

stage_re_fp=fi2vec(stage_re.data(beginner_stage:beginner_stage+16*d_num-1));
stage_im_fp=fi2vec(stage_im.data(beginner_stage:beginner_stage+16*d_num-1));

mul_re_fp=fi2vec(mul_re.data(beginner_mul:beginner_mul+16*d_num-1));
mul_im_fp=fi2vec(mul_im.data(beginner_mul:beginner_mul+16*d_num-1));

d_re=zeros(size(d_re_fp,1),d_num);
d_im=zeros(size(d_im_fp,1),d_num);

d_stage_re=zeros(size(d_re_fp,1),d_num);
d_stage_im=zeros(size(d_im_fp,1),d_num);

d_mul_re=zeros(size(d_re_fp,1),d_num);
d_mul_im=zeros(size(d_im_fp,1),d_num);


for i=1:size(d_re_fp,1)
    d_re(i,:)=serial2parallel(d_re_fp(i,:));
    d_im(i,:)=serial2parallel(d_im_fp(i,:));

    d_stage_re(i,:)=serial2parallel(stage_re_fp(i,:));
    d_stage_im(i,:)=serial2parallel(stage_im_fp(i,:));

    d_mul_re(i,:)=serial2parallel(mul_re_fp(i,:));
    d_mul_im(i,:)=serial2parallel(mul_im_fp(i,:));
end;

d_out=d_re+d_im*1i;

fft(d)
d_out*2