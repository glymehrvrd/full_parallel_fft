function [ cout ] = combinecell( a,b )

% cout={};
% for i=1:length(b)
%     cout{i}=[a{i};b{i}];
% end;

cout=cellfun(@(x,y) [x;y],a,b,'UniformOutput',false);
end

