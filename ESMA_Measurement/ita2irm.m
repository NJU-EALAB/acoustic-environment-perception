function savePath = ita2irm(dataPath,forceSaveFlag)
if nargin < 2
    forceSaveFlag = 1;
end
matFile = load(dataPath,'DirData');
if ~isfield(matFile,'DirData')
    savePath = dataPath;
    return;
end
savePath = [dataPath(1:end-4),'_fromITA.mat'];
if (~forceSaveFlag)&&(isfile(savePath))
    return;
end

Data = cell(size(matFile.DirData,1),1);
for ii = 1:size(matFile.DirData,1)
    Data{ii}.fs = matFile.DirData(ii,1).samplingRate;
    Data{ii}.IR = cell(matFile.DirData(ii,1).dimensions,size(matFile.DirData,2));
    for jj = 1:size(matFile.DirData,2)
        ir = matFile.DirData(ii,jj).timeData;
        for kk = 1:matFile.DirData(ii,jj).dimensions
            Data{ii}.IR{kk,jj} = ir(:,kk);
        end
    end
end
save(savePath,'Data');

end