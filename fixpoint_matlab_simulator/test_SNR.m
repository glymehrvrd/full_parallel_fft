dBov_list=[-60, -54, -48, -42, -36, -30, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -6, 0];

snr=[];
for dBov=dBov_list
    ['dBov is ' int2str(dBov)]
    local_snr=[];
    parfor i=1:10
        d=signal_gaussian(dBov,[2048,1]);
        hout=double(fft2048(d))*64;
        fout=fft(d);
        
        err=hout-fout;
        err_pow=sum(abs(err).^2);
        
        sign_pow=sum(abs(fout).^2);
        
        local_snr(i)=pow2db(err_pow./sign_pow);
    end;
    snr=[snr mean(local_snr)];
end;

snr_loss=[];
for dBov=dBov_list
    ['dBov is ' int2str(dBov)]
    local_snr=[];
    parfor i=1:10
        d=signal_gaussian(dBov,[2048,1]);
        hout=double(fft2048_loss(d))*64;
        fout=fft(d);
        
        err=hout-fout;
        err_pow=sum(abs(err).^2);
        
        sign_pow=sum(abs(fout).^2);
        
        local_snr(i)=pow2db(err_pow./sign_pow);
    end;
    snr_loss=[snr_loss mean(local_snr)];
end;