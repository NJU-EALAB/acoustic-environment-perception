clear all
addpath('./data');
dataname = 'IR_3564_20200722_';
dataidx = 1:2:9;

%%
jj = 0;
for ii = dataidx
    load([dataname,num2str(ii),'.mat']);
    IR(:,(1:4)+4*jj) = cell2mat(Data{1, 1}.IR([3 5 6 4],:).');%#ok
    plot(IR(:,1+4*jj));
    directIRRange = input('directIRRange: ');
    directIR{jj+1} = IR(directIRRange(1):directIRRange(2),1+4*jj);%#ok
    jj = jj+1;
end
fs = Data{1}.fs;
save('./data/IR_44444_20200722_1.mat','IR','directIR','fs');

%%
IR = [];
directIR = {};
jj = 0;
for ii = dataidx+1
    load([dataname,num2str(ii),'.mat']);
    IR(:,(1:4)+4*jj) = cell2mat(Data{1, 1}.IR([3 5 6 4],:).');%#ok
    plot(IR(:,1+4*jj));
    directIRRange = input('directIRRange: ');
    directIR{jj+1} = IR(directIRRange(1):directIRRange(2),1+4*jj);%#ok
    jj = jj+1;
end
fs = Data{1}.fs;
save('./data/IR_44444_20200722_2.mat','IR','directIR','fs');