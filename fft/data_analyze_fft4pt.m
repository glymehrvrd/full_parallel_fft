% set number of input data
d_num=100;
beginner=6;
beginner_stage=5;

d_re_fp=fi2vec(d_re_out.data(beginner:beginner+16*d_num-1));
d_im_fp=fi2vec(d_im_out.data(beginner:beginner+16*d_num-1));

stage_re.data=fi(stage_re.data,0,8,0);
stage_im.data=fi(stage_im.data,0,8,0);

stage_re_fp=fi2vec(stage_re.data(beginner_stage:beginner_stage+16*d_num-1));
stage_im_fp=fi2vec(stage_im.data(beginner_stage:beginner_stage+16*d_num-1));

d_stage_re=zeros(size(d_re_fp,1),d_num);
d_stage_im=zeros(size(d_im_fp,1),d_num);

d_re=zeros(size(d_re_fp,1),d_num);
d_im=zeros(size(d_im_fp,1),d_num);


for i=1:size(d_re_fp,1)
    d_re(i,:)=serial2parallel(d_re_fp(i,:));
    d_im(i,:)=serial2parallel(d_im_fp(i,:));
    
    d_stage_re(i,:)=serial2parallel(stage_re_fp(i,:));
    d_stage_im(i,:)=serial2parallel(stage_im_fp(i,:));
end;

d_out=d_re+d_im*1i;

float_out=fft(d);
hardware_out=d_out;