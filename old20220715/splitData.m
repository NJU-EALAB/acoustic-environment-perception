function splitData(dataPath)
load(dataPath);
Data0 = Data;
numSrcCh = size(Data{1, 1}.IR,2);

for n = 1:numSrcCh
    Data = Data0;
    for ii = 1:length(Data0)
        Data{ii}.IR = Data{ii}.IR(:,n);
    end
    save([dataPath(1:end-4),'_src',num2str(n),'.mat'],'Data');
end
end