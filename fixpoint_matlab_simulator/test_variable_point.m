generate_all;

d_num=1;
% input data, each row an input port, each column a data
d=int16((rand(2048,d_num)-0.5)*2*2^10+(rand(2048,d_num)-0.5)*1j*2*2^10);

% test for 1024-point
vbout=fft2048(d,[1 0 0 0 0 0 0 0 0 0 0]);
vbout=[vbout(1:2:end);vbout(2:2:end)];
vbout_reordered=vbout;
hout=[fft1024(d(1:1024));fft1024(d(1025:end))];
all(vbout_reordered==hout)

% test for 512-point
vbout=fft2048(d,[1 1 0 0 0 0 0 0 0 0 0]);
vbout_reordered=[];
order=fft4(1:4,[1 1]);
hout=[];
for i=1:4
    vbout_reordered=[vbout_reordered;vbout(i:4:end)];
    hout=[hout;fft512(d(1+512*(order(i)-1):512*order(i)))];
end;
all(vbout_reordered==hout)

% test for 256-point
vbout=fft2048(d,[1 1 1 0 0 0 0 0 0 0 0]);
vbout_reordered=[];
order=fft8(1:8,[1 1 1]);
hout=[];
for i=1:8
    vbout_reordered=[vbout_reordered;vbout(i:8:end)];
    hout=[hout;fft256(d(1+256*(order(i)-1):256*order(i)))];
end;
all(vbout_reordered==hout)

% test for 128-point
vbout=fft2048(d,[1 1 1 1 0 0 0 0 0 0 0]);
vbout_reordered=[];
order=fft16(1:16,[1 1 1 1]);
hout=[];
for i=1:16
    vbout_reordered=[vbout_reordered;vbout(i:16:end)];
    hout=[hout;fft128(d(1+128*(order(i)-1):128*order(i)))];
end;
all(vbout_reordered==hout)

% test for 64-point
vbout=fft2048(d,[1 1 1 1 1 0 0 0 0 0 0]);
vbout_reordered=[];
order=fft32(1:32,[1 1 1 1 1]);
hout=[];
for i=1:32
    vbout_reordered=[vbout_reordered;vbout(i:32:end)];
    hout=[hout;fft64(d(1+64*(order(i)-1):64*order(i)))];
end;
all(vbout_reordered==hout)