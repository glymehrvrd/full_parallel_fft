%% parallel2serial: convert parallel input data into serial data
function [serial_out] = parallel2serial(data)
    serial_out=zeros(length(data),16);
    for i=1:length(data)
        tmp=data(i);
        % due to multiplier property, 1st bit(msb) must equal to 2nd bit
        if bitget(tmp,16)~=bitget(tmp,15)
            error(['Input data overflows: ' num2str(tmp.dec)]);
        end;
        serial_out(i,:)=bitget(real(tmp),1:16);
    end;
    serial_out=serial_out';
    serial_out=serial_out(:);
    serial_out=boolean(serial_out);
    