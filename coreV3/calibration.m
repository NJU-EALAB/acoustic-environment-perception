cd(fileparts(mfilename('fullpath')));
addpath(genpath('../'));
clear all
close all
%%
% dataPath0 = '../data/20220712kjg507/IR_ESMA_18_20220719.mat';
% dataPath0 = 'D:\dxm-ez-20221206\Directivity\20221207_11_12_54.mat';
% dataPath0 = '../ESMA_Measurement/20230313_17_00_06_refspk4.mat';
dataPath0 = '../ESMA_Measurement/20230522_16_14_11.mat';
dataPath0 = ita2irm(dataPath0,1);
load(dataPath0,'Data');
%% 
micSelectIdx = [17];
srcSelectIdx = [1];
% rRef = 10.1229;
rRef = 9.7;
IR_cali = double(cell2mat(Data{1, 1}.IR(micSelectIdx,srcSelectIdx)));
fs = Data{1}.fs;
assert(size(IR_cali,2)==1);
%%
save('calibIR.mat','IR_cali','fs','rRef');