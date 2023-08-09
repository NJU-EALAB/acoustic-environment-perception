function savePath = mergeData(dataPath,chIdx,forceSaveFlag)
if nargin < 3
    forceSaveFlag = 1;
end
if iscell(dataPath)
    savePath = [dataPath{1}(1:end-4),'_merge.mat'];
else
    savePath = [dataPath(1:end-4),'_merge.mat'];
end

if (~forceSaveFlag)&&(isfile(savePath))
    return;
end
%%
if iscell(dataPath)
    Data0 = cell(0,1);
    for ii = 1:numel(dataPath)
        load(dataPath{ii});
        Data0 = [Data0;Data];
    end
else
    load(dataPath);
    Data0 = Data;
end
measurementNum = size(Data0,1);

Data = Data0(1);
Data{1}.IR = [];
for ii = 1:length(Data0)
    Data{1}.IR = [Data{1}.IR; Data0{ii}.IR(chIdx,:)];
end
if isfield(Data{1},'micPos')
    Data{1}.micPos = [];
    for ii = 1:length(Data0)
        Data{1}.micPos = [Data{1}.micPos, Data0{ii}.micPos(:,chIdx)];
    end
end
save(savePath,'Data','measurementNum');

end