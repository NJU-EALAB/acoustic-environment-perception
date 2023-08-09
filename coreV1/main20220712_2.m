cd(fileparts(mfilename('fullpath')));
addpath(genpath('../'));
clear all
close all
%%
dataPath0 = '../data/20220712kjg507/IR_ESMA_18.mat';
chIdx = 1:16;
dataPath = mergeData(dataPath0,chIdx,0);
%% init
load(dataPath);
IR = cell2mat3(Data{1}.IR);
fs = Data{1}.fs;
frameLen = 128;
% frameLen = 48000;
disp(frameLen/fs);

maxOrder = 8;
micParams = MicArrayPresets('esma',18, maxOrder);
sphHarmType = 'complex';

% maxOrder = 5;
% micParams = MicArrayPresets('esma',3, maxOrder);
% IR = IR([1:16,16*6+1:16*7,16*12+1:16*13],:,:);
%% init sma2sh
maxGain_dB = 20;
filterOrder = 256;
sma2sh = SMA2SH(micParams,maxGain_dB,fs,filterOrder,'sphHarmType',sphHarmType);
sma2sh.setup;
% sma2sh.fvtool;
%% init sh2srp
azimuth = linspace(-pi,pi,72*2+1);
elevation = linspace(-pi/2,pi/2,36*2+1);
maxOrder = micParams.maxOrder;
lowPassFilterParams.status = 'on';
lowPassFilterParams.fs = fs;
lowPassFilterParams.maxFreq = 10000;
lowPassFilterParams.filterOrder = 50;
patternWeight = [];
sh2srp = SH2SRP(azimuth,elevation,maxOrder,lowPassFilterParams,patternWeight,'sphHarmType',sphHarmType);
sh2srp.setup;
%% init sh2slai
sectorAzimuth = [0];
sectorElevation = [0];
patternWeight = 'omni';
sh2slai = SH2SLAI(sectorAzimuth,sectorElevation,maxOrder-1,lowPassFilterParams,patternWeight,'sphHarmType',sphHarmType);
sh2slai.setup;
%% simulation
srcIdx = 1;
ir = squeeze(IR(:,srcIdx,:)).';
ir(1:5000,:) = [];

srpCum = 0;
figure;
ii = 0;
while true
    ii = ii+1;
    if ii*frameLen>size(ir,1)
        break;
    end
    sma = ir((ii-1)*frameLen+1:ii*frameLen,:);
    tic;    
    sh = sma2sh(sma);
    srp = sh2srp(sh);
    srpCum = (srpCum+(db2mag(srp)).^2);
    srpCum_dB = 0.5*mag2db(srpCum);
    srpCum_dB = srp;
%     srp = sh2srp(sh0(:,1:size(sh,2)));
    [wxyz,azel] = sh2slai(sh);
%     [slai,azel] = sh2slai(sh0(:,1:size(sh,2)));
    toc;
    
    [srpEl,idxEl] = max(srpCum_dB);
    [srpMax,idxAz] = max(srpEl);
    idxEl = idxEl(idxAz);
    disp([azimuth(idxAz)./pi.*180,elevation(idxEl)./pi.*180,srpMax])
    disp(azel./pi.*180);
    srpSurf = surf(azimuth./pi.*180,elevation./pi.*180,srpCum_dB);
    % shading interp
%     axis equal
    view(2)
    dt = datatip(srpSurf,'DataIndex',size(srpCum_dB,1)*(idxAz-1)+idxEl);
    drawnow
end
%%
