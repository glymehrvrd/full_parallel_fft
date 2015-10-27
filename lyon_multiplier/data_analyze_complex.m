% set number of input data
d_num=3;
beginner=20;

d_re_fp=d_re_out.data(beginner:beginner+16*d_num-1)';
d_im_fp=d_im_out.data(beginner:beginner+16*d_num-1)';

d_re=serial2parallel(d_re_fp);
d_im=serial2parallel(d_im_fp);

d_out=d_re+d_im*1i;
