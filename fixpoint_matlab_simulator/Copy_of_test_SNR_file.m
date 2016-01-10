dBov_list=[0];
groupNum=1;
fftpt=64;

d=load(['../fixpoint_cpp_simulator/Release/fft_2048_gaussian_0db.txt']);
d=complex(d(:,1),d(:,2));

hout=load(['../fixpoint_cpp_simulator/Release/fft_2048_gaussian_out_0db.txt']);
hout=complex(hout(:,1),hout(:,2));

snr=[];
for dBovIdx=1:length(dBov_list)
    ['dBov is ' int2str(dBov_list(dBovIdx))]
    local_snr=[];
    for i=1+(dBovIdx-1)*groupNum:dBovIdx*groupNum
        fout=fft(d(1+(i-1)*fftpt:i*fftpt))/4;
        
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