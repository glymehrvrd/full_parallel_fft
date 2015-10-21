function [fiout] = vec2fi(vec)
% convert vector to fi object.
% fi word length equals to row number of vec. i.e, convert
% each column into a fi object.

fiout=fi(zeros(1,size(vec,2)),0,size(vec,1),0);

for j=1:size(vec,2)
    for i=1:size(vec,1)
        if vec(i,j)==1
            fiout(j)=bitset(fiout(j),i);
        end;
    end;
end;
