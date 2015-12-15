function [dout] = reorder(data,pt,order)
if pt==1280
    crl=zeros(256,5);
    goods=zeros(256,5);
    for k1 = 0:255
        for k2 = 0:4
            crl(1+k1,1+k2) = mod((256*k2 + 1025*k1),1280);
            goods(1+k1,1+k2) = mod((256*k2 + 5*k1),1280);
        end;
    end;
elseif pt==1536
    crl=zeros(512,3);
    goods=zeros(512,3);
    for k1 = 0:511
        for k2 = 0:2
            crl(1+k1,1+k2) = mod((1024*k2 + 513*k1),1536);
            goods(1+k1,1+k2) = mod((512*k2 + 3*k1),1536);
        end
    end;
end;

crl=crl(:);
goods=goods.';
goods=goods(:);

if strcmp(order,'in')
    dout=data(goods+1);
elseif strcmp(order,'out')
    dout(crl+1)=data;
end;

end
