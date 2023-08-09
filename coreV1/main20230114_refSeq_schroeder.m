cd(fileparts(mfilename('fullpath')));
addpath(genpath('../'));
clear all
close all
%%
% dataPath0 = '../data/20220712kjg507/IR_ESMA_18_20220719.mat';
% dataPath0 = 'D:\dxm-ez-20221206\Directivity\20221207_11_12_54.mat';
dataPath0 = '../ESMA_Measurement/data/20221212_17_39_33.mat';
dataPath0 = ita2irm(dataPath0,0);
chIdx = 1:16;
dataPath = mergeData(dataPath0,chIdx,0);
%% init
% srcSelectIdx = [1:5 7:32];
srcSelectIdx = [3];
load(dataPath,'Data','measurementNum');
IR = cell2mat3(Data{1}.IR(:,srcSelectIdx));
fs = Data{1}.fs;
frameLen = 1024;
% frameLen = 48000;
disp(frameLen/fs);

maxOrder = 8;
micParams = MicArrayPresets('esma2',measurementNum, maxOrder, 0);
sphHarmType = 'complex';

%% init sma2sh
maxGain_dB = 20;
filterOrder = 256;
sma2sh = SMA2SH(micParams,maxGain_dB,fs,filterOrder,'sphHarmType',sphHarmType);
sma2sh.setup;
% sma2sh.fvtool;
%% run
w = zeros(size(IR,[3 2]));
SRIR = cell(size(IR,2),1);
RIR = cell(size(IR,2),1);
binaural = cell(size(IR,2),1);
azelAll = zeros(size(IR,2),2);

srpCum_dB = cell(size(IR,2),1);
srpDirCum_dB = cell(size(IR,2),1);
for srcIdx = 1:size(IR,2)
    %% get src azel
    ir = squeeze(IR(:,srcIdx,:)).';

    sh = frameProcessor(sma2sh,ir,frameLen);

end
%% save
load(dataPath0);
fs = Data{1}.fs;
ir_meas = double(cell2mat(Data{1, 1}.IR(17,srcSelectIdx).'));
ir_mic5 = double(cell2mat(Data{1, 1}.IR(5,srcSelectIdx).'));
ir_sh0 = double(real(sh(:,1)));
save('ir3.mat','fs','ir_meas','ir_mic5','ir_sh0');
%% refSeq and schroeder curves
load('ir3.mat');

reverbCurve(ir_sh0,fs);
reverbCurve(ir_mic5,fs);
reverbCurve(ir_meas,fs);

refSeq(ir_sh0,fs);
refSeq(ir_mic5,fs);
refSeq(ir_meas,fs);

