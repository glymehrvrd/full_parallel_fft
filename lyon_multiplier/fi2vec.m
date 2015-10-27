function [vecout] = fi2vec(fiin)
% convert fi object to binary vector
% fi word length equals to row number of vec.

vecout=zeros(fiin.WordLength,length(fiin));

for j=1:size(vecout,2)
    vecout(:,j)=bitget(fiin(j),1:size(vecout,1))';
end;
