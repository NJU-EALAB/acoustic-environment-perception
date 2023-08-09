function copyRequiredFiles(filename,destPath)
[fList,pList] = matlab.codetools.requiredFilesAndProducts(filename);
for ii = 1:numel(fList)
    copyfile(fList{ii},destPath);
end