f=fopen('d:\\dout.txt','r');
d_cout=[];
i=1;
while(1)
    [tmp,cnt]=fscanf(f,'%d',2);
    d_cout=[d_cout;tmp.'];
    i=i+1;
    if(cnt==0)
        break;
    end;
end;
fclose(f);

d_cout=int16(complex(d_cout(:,1),d_cout(:,2)));
