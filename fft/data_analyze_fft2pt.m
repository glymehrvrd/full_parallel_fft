% set number of input data
d_num=2;
beginner=5;

d0_re=serial2parallel(d0_re_out.data(beginner:beginner+16*d_num-1));
d0_im=serial2parallel(d0_im_out.data(beginner:beginner+16*d_num-1));

d0=d0_re+d0_im*1i;

d1_re=serial2parallel(d1_re_out.data(beginner:beginner+16*d_num-1));
d1_im=serial2parallel(d1_im_out.data(beginner:beginner+16*d_num-1));

d1=d1_re+d1_im*1i;
