function mat = cell2mat3(cel)
mat = zeros(size(cel,1),size(cel,2),numel(cel{1}));
for ii = 1:size(cel,1)
    for jj = 1:size(cel,2)
        mat(ii,jj,:) = cel{ii,jj}(:);
    end
end
end