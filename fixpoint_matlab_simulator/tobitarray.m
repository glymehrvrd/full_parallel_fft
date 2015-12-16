function [dout]=tobitarray(din)
    dout=cell(size(din));
    for i=1:size(din,1)
        for j=1:size(din,2)
            dout{i,j}=de2bi(din(i,j),16);
        end;
    end;
end