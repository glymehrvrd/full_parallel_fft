dBov_list=[-60];

% d=load(['../fixpoint_cpp_simulator/Release/fft_2048_gaussian.txt']);
% d=complex(d(:,1),d(:,2));

hout=load(['../fixpoint_cpp_simulator/Release/fft_2048_gaussian_out.txt']);
hout=complex(hout(:,1),hout(:,2));

snr=[];
for dBovIdx=1:length(dBov_list)
    ['dBov is ' int2str(dBov_list(dBovIdx))]
    local_snr=[];
    for i=1+(dBovIdx-1)*100:dBovIdx*100
        fout=fft(d(1+(i-1)*2048:i*2048))/sqrt(2048);
        
        err=hout(1+(i-1)*2048:i*2048)-fout;

        err_pow=sum(abs(err).^2);
        sign_pow=sum(abs(fout).^2);
        
        local_snr=[local_snr pow2db(err_pow./sign_pow)];
    end;
    snr=[snr mean(local_snr)];
end;

plot(dBov_list,snr,'-o');
legend('FFT HAC');
set(gca,'YDir','reverse');