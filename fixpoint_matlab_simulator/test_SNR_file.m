dBov_list=[-60, -54, -48, -42, -36, -30, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -6, 0];
groupNum=100;
fftpt=1280;

d=load(['../fixpoint_cpp_simulator/Release/fft_' int2str(fftpt) '_gaussian.txt']);
d=complex(d(:,1),d(:,2));

hout=load(['../fixpoint_cpp_simulator/Release/fft_' int2str(fftpt) '_gaussian_out.txt']);
hout=complex(hout(:,1),hout(:,2));

snr=[];
for dBovIdx=1:length(dBov_list)
    ['dBov is ' int2str(dBov_list(dBovIdx))]
    local_snr=[];
    for i=1+(dBovIdx-1)*groupNum:dBovIdx*groupNum
        fout=fft(d(1+(i-1)*fftpt:i*fftpt));
        
        err=hout(1+(i-1)*fftpt:i*fftpt)-fout;

        err_pow=sum(abs(err).^2);
        sign_pow=sum(abs(fout).^2);
        
        local_snr=[local_snr pow2db(err_pow./sign_pow)];
    end;
    snr=[snr mean(local_snr)];
end;

plot(dBov_list,snr,'-o');
legend('FFT HAC');
set(gca,'YDir','reverse');