cd(fileparts(mfilename('fullpath')));
addpath(genpath('../'));
clear all
close all
%%
dataPath0 = '../data/20220712kjg507/IR_ESMA_18_20220719.mat';
chIdx = 1:16;
dataPath = mergeData(dataPath0,chIdx,0);
%% init
load(dataPath);
IR = cell2mat3(Data{1}.IR);
fs = Data{1}.fs;
frameLen = 1024;
% frameLen = 48000;
disp(frameLen/fs);

maxOrder = 4;
micParams = MicArrayPresets('esma',18, maxOrder);
sphHarmType = 'complex';
%%% change to 32 ch
ch32Idx = 16*(0:3:17)+[10 12 13 14 16].';
ch32Idx = [1 8 ch32Idx(:).'];
IR = IR(ch32Idx,:,:);
micParams0 = micParams;
clear micParams
micParams.maxOrder = micParams0.maxOrder;
micParams.radius = micParams0.radius;
micParams.sphType = micParams0.sphType;
micParams.azi = micParams0.azi(ch32Idx);
micParams.ele = micParams0.ele(ch32Idx);
micParams.phi = micParams.azi;
micParams.theta = pi/2-micParams.ele;
%% init sma2sh
maxGain_dB = 20;
filterOrder = 256;
sma2sh = SMA2SH(micParams,maxGain_dB,fs,filterOrder,'sphHarmType',sphHarmType);
sma2sh.setup;
% sma2sh.fvtool;
%% init sh2srp
dAngle = 1;
azimuth = linspace(-pi,pi,360/dAngle+1);
elevation = linspace(-pi/2,pi/2,180/dAngle+1);
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
%% init IRIS
%%% setting
conf.OffsetdB = 40;
conf.SegmentTime = 0.002;
%%% advanced setting
confIRIS = readstruct('measurement.xml');
conf.ArrivalTimeColour = confIRIS.Project.ResultsViewData.IrisPlotViewData.ArrivalTimeColoursList.ArrivalTimeColours(1).ArrivalTimeColourList.ArrivalTimeColourItem; 
conf.directSoundThresholdDB = 30;
conf.tMax = 1.5;% [s]
conf.LPfilterFc = 5000; %[Hz]
conf.fs = fs;
conf.axis = eye(3);

%% run
w = zeros(size(IR,[3 2]));
azelAll = zeros(size(IR,2),2);
for srcIdx = 1:size(IR,2)
    %% get src azel
    ir = squeeze(IR(:,srcIdx,:)).';
    sh = frameProcessor(sma2sh,ir,frameLen);
    srp = frameProcessor(sh2srp,sh,frameLen,frameLen,3);
    srpCum_dB = 0.5*mag2db(mean((db2mag(srp)).^2,3));
    
    figure;
    [srpEl,idxEl] = max(srpCum_dB);
    [srpMax,idxAz] = max(srpEl);
    idxEl = idxEl(idxAz);
    azel = [azimuth(idxAz)./pi.*180,elevation(idxEl)./pi.*180];
    azelAll(srcIdx,:) = azel;
    disp([azel,srpMax])
    srpSurf = surf(azimuth./pi.*180,elevation./pi.*180,srpCum_dB);
    shading interp
    %     axis equal
    view(2)
    numPeak = 1;
    [xPeak, yPeak, zPeak, xPeakId, yPeakId] = findpeaks2D(azimuth,elevation,srpCum_dB,numPeak,0,2);
    for ii = 1:numel(zPeak)
        datatip(srpSurf,'DataIndex',size(srpCum_dB,1)*(xPeakId(ii)-1)+yPeakId(ii));
    end
    %% get IRIS
    wxyz = real(frameProcessor(sh2slai,sh,frameLen));
    w(:,srcIdx) = wxyz(:,1);
    sndHedgehog = IRIS_BFormat(wxyz,conf);
    %% sparse DOA in SH domain (beta)
%     sparseDoaSH(sh,sphHarmType);
end
%% get source position
%%% real pos in 507
ESMAPos = [0;0;1.2];
refMicIdx = 20;
% refMicPos = zeros(3,1);
[refMicPos(1,:),refMicPos(2,:),refMicPos(3,:)] = sph2cart(micParams.azi(refMicIdx),micParams.ele(refMicIdx),micParams.radius);
refMicPos = ESMAPos+refMicPos;
x = 0.98*[3 3 2 3 2 1];
y = 0.9*[3 2 0 -2 -3 -2];
z = [1.8 0.1 0.1 1.6 0.1 0.1];
srcPosReal = [x;y;z];
[azReal_rad,elReal_rad,~] = cart2sph(x-ESMAPos(1),y-ESMAPos(2),z-ESMAPos(3));
[~,~,rReal] = cart2sph(x-refMicPos(1),y-refMicPos(2),z-refMicPos(3));
azelReal = [azReal_rad;elReal_rad].'./pi.*180;
rEnd = vecnorm(srcPosReal(:,end)-refMicPos,2,1);
%%%
c = 343;
azelAll_rad = azelAll./180.*pi;
r = rEnd+c*getTDOA(squeeze(IR(refMicIdx,:,:)).', fs);% from spks to refMic
srcPos = aziEleDis2Pos(azelAll_rad.',ESMAPos,r,refMicPos);
%%%
dSrcPos = vecnorm(srcPosReal-srcPos,2,1);
dr = abs(r-rReal);
[~, dSrcAngle] = getIncludedAngle(srcPos-ESMAPos,srcPosReal-ESMAPos);