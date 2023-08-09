cd(fileparts(mfilename('fullpath')));
addpath(genpath('../'));
clear all
close all
%% init
c = 343;
srcSelectIdx = [1];
srcRealSelectIdx = [4];
% ESMAPos = [0.808;0;0.48];%gulou litang
% refMicPos = ESMAPos+[-0.73;0;0.076];%gulou litang
ESMAPos = [0;0;1.603+0.65];%xianlin enling
refMicPos = ESMAPos+[0;-1.16;0];%xianlin enling
refMicIdx = 17;

% dataPath0 = '../ESMA_Measurement/20230316_16_34_57.mat';% spk 1 for src loc
% dataPath0 = '../ESMA_Measurement/20230317_12_45_32.mat';% 反射面0：其他反射声过强
% dataPath0 = '../ESMA_Measurement/20230317_13_50_28_ref1.mat';% 反射面1：成功定位（案例1）
% dataPath0 = '../ESMA_Measurement/20230317_14_24_19_ref2.mat';% 反射面1 扬声器右移2m：成功定位但反射声重合
% dataPath0 = '../ESMA_Measurement/20230317_14_36_28.mat';% 反射面1+扰动 扬声器右移2m：反射声重合
% dataPath0 = '../ESMA_Measurement/20230317_15_01_59.mat';% 反射面1+扰动2 扬声器右移2m：其他反射声
% dataPath0 = '../ESMA_Measurement/20230317_15_18_57.mat';% ？反射面1+扰动2 扬声器移回原位：成功定位
% dataPath0 = '../ESMA_Measurement/20230317_15_25_41.mat';% ？反射面1+扰动2 扬声器移回原位：成功定位
% dataPath0 = '../ESMA_Measurement/20230317_15_32_28.mat';% ？反射面1+扰动2 扬声器右移2m：其他反射声
dataPath0 = '../ESMA_Measurement/20230317_16_30_13.mat';% ？反射面2 ：仅反射声成功定位（案例2）
% dataPath0 = '../ESMA_Measurement/20230317_16_44_48.mat';% ？反射面1+扰动2 扬声器移回原位：
% dataPath0 = '../ESMA_Measurement/20230317_16_59_52.mat';% ？反射面1+扰动2 扬声器移回原位：

dataPath0 = ita2irm(dataPath0,1);
load(dataPath0,'Data');
IR_addMic = double(cell2mat(Data{1, 1}.IR(refMicIdx,srcSelectIdx)));

chIdx = [1:16];
% chIdx = [1:3,5:16];
dataPath = mergeData(dataPath0,chIdx,1);
load(dataPath,'Data','measurementNum');
IR = cell2mat3(Data{1}.IR(:,srcSelectIdx));
fs = Data{1}.fs;
frameLen = 1024;
% frameLen = 48000;
disp(frameLen/fs);

maxOrder = 8;
micParams = MicArrayPresets('esma2',measurementNum, maxOrder, 0);
sphHarmType = 'complex';

cali = load('calibIR.mat');
assert(fs==cali.fs);
cali.IR_cali = cali.IR_cali(1:size(IR_addMic,1));
assert(numel(cali.IR_cali)==size(IR_addMic,1));
%% init sma2sh
maxGain_dB = 20;
filterOrder = 256;
sma2sh = SMA2SH(micParams,maxGain_dB,fs,filterOrder,'sphHarmType',sphHarmType);
sma2sh.setup;
% sma2sh.fvtool;
%% init sh2srp
dAngle = 2;
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
SRIR = cell(size(IR,2),1);
RIR = cell(size(IR,2),1);
binaural = cell(size(IR,2),1);
azelAll = zeros(size(IR,2),2);

srpCum_dB = cell(size(IR,2),1);
srpDirCum_dB = cell(size(IR,2),1);
srpRefCum_dB = cell(size(IR,2),1);
for srcIdx = 1:size(IR,2)
    %% get src azel
    ir = squeeze(IR(:,srcIdx,:)).';

    sh = frameProcessor(sma2sh,ir,frameLen);
    srp = frameProcessor(sh2srp,sh,frameLen,frameLen,3);
    srpCum_dB{srcIdx} = 0.5*mag2db(mean((db2mag(srp)).^2,3));
    %%%
    [directIdxSH] = getDirectIR(sh(:,1),fs);
    srpDir = frameProcessor(sh2srp, sh(directIdxSH(1):directIdxSH(2),:), frameLen, frameLen, 3);
    srpDirCum_dB{srcIdx} = 0.5*mag2db(mean((db2mag(srpDir)).^2,3));
    srpRef = frameProcessor(sh2srp, sh(directIdxSH(2)+1:end,:), frameLen, frameLen, 3);
    srpRefCum_dB{srcIdx} = 0.5*mag2db(mean((db2mag(srpRef)).^2,3));
    %%%
    %%% init sh2bin
    sh2bin_vst = vst.binauralDecoder(fs,size(IR,3));
    SRIR{srcIdx} = real(complex2realCoeffs(sh.')).';
    RIR{srcIdx} = SRIR{srcIdx}(:,1);
    sh2bin = @(shReal)sh2bin_vst.process(shReal)*[eye(2);zeros(62,2)];
    binaural{srcIdx} = sh2bin(SRIR{srcIdx}(:,1:64));
    
    figure;
    [srpEl,idxEl] = max(srpDirCum_dB{srcIdx});
    [srpMax,idxAz] = max(srpEl);
    idxEl = idxEl(idxAz);
    azel = [azimuth(idxAz)./pi.*180,elevation(idxEl)./pi.*180];
    azelAll(srcIdx,:) = azel;
    disp([azel,srpMax])
    srpSurf = surf(azimuth./pi.*180,elevation./pi.*180,srpCum_dB{srcIdx});
    shading interp
    %     axis equal
    view(2)
    numPeak = 1;
    [xPeak, yPeak, zPeak, xPeakId, yPeakId] = findpeaks2D(azimuth,elevation,srpDirCum_dB{srcIdx},numPeak,0,2);
    for ii = 1:numel(zPeak)
        datatip(srpSurf,'DataIndex',size(srpCum_dB{srcIdx},1)*(xPeakId(ii)-1)+yPeakId(ii));
    end
%     savefig(['powermap',num2str(srcIdx),'.fig']);
    %% get IRIS
    wxyz = real(frameProcessor(sh2slai,sh,frameLen));
    w(:,srcIdx) = wxyz(:,1);
    sndHedgehog = IRIS_BFormat(wxyz,conf);
    %%
%     close all;
end
%% get source position
% warning('offset: 8 deg.');
% azelAll_rad = (azelAll-[8 0])./180.*pi;
azelAll_rad = (azelAll)./180.*pi;

IR_refMic = [IR_addMic, cali.IR_cali];
[directIdx] = getDirectIR(IR_refMic,fs);
mask = 0*IR_refMic;
for ii = 1:size(IR_refMic,2)
    mask(directIdx(1,ii):directIdx(2,ii),ii) = 1;
end
r = c*getTDOA(IR_refMic.*mask, fs);% from spks to refMic

r = r(1:end-1)-r(end)+cali.rRef;% from spks to refMic
srcPos = aziEleDis2Pos(azelAll_rad.',ESMAPos,r,refMicPos);

run script_pos_enling.m
x = pos(srcRealSelectIdx,1).';
y = pos(srcRealSelectIdx,2).';
z = pos(srcRealSelectIdx,3).';
srcPosReal = [x;y;z];
[azReal_rad,elReal_rad,~] = cart2sph(x-ESMAPos(1),y-ESMAPos(2),z-ESMAPos(3));
[~,~,rReal] = cart2sph(x-refMicPos(1),y-refMicPos(2),z-refMicPos(3));
azelReal = [azReal_rad;elReal_rad].'./pi.*180;

figure;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:));
hold on
scatter3(srcPos(1,:),srcPos(2,:),srcPos(3,:));
axis equal;
title('扬声器位置')
% zlim([0 3]);
dSrcPos = vecnorm(srcPosReal-srcPos,2,1);
dr = abs(r-rReal);
[~, dSrcAngle] = getIncludedAngle(srcPos-ESMAPos,srcPosReal-ESMAPos);
figure;
scatter(1:numel(dSrcPos),dSrcPos);
title('位置误差');
figure;
scatter(1:numel(dr),dr);
title('距离误差');
figure;
scatter(1:numel(dSrcAngle),dSrcAngle);
title('角度误差');
save('res_srcPos.mat','azelAll_rad','srcPosReal','srcPos','dSrcPos','dr','dSrcAngle');
%% Direction estimation of direct sound and reflected sound
save('data_powermap.mat','azelAll_rad','azimuth','elevation',...
    'wallPos','srcPosReal','ESMAPos','srpCum_dB','srpDirCum_dB','srpRefCum_dB');
% load('data_powermap.mat');
srcIdx = 1;
azimuth0 = azimuth(1:end-1);
[az,el] = getSoundAzel(wallPos, srcPosReal(:,(srcIdx)), ESMAPos);
numPeak = 4;
[xPeak, yPeak, zPeak, xPeakId, yPeakId] = findpeaks2D(azimuth0,elevation,srpCum_dB{srcIdx}(:,1:end-1),numPeak,0,2);

figure(200);
srpSurf = surf(azimuth0./pi.*180,elevation./pi.*180,srpCum_dB{srcIdx}(:,1:end-1));
shading interp
%     axis equal
view(2)
hold on;
scatter3(az(:,1)./pi.*180,el(:,1)./pi.*180,0*el(:,1)+max(srpCum_dB{srcIdx},[],'all'),'k','LineWidth',2);
scatter3(xPeak(:,1)./pi.*180,yPeak(:,1)./pi.*180,0*yPeak(:,1)+1+max(srpCum_dB{srcIdx},[],'all'),'r^','filled');
hold off;
%% only reflected sound
numPeak = 4;
[xPeak, yPeak, zPeak, xPeakId, yPeakId] = findpeaks2D(azimuth0,elevation,srpRefCum_dB{srcIdx}(:,1:end-1),numPeak,0,2);

figure(201);
srpSurf = surf(azimuth0./pi.*180,elevation./pi.*180,srpRefCum_dB{srcIdx}(:,1:end-1));
shading interp
%     axis equal
view(2)
hold on;
scatter3(az(2:end,1)./pi.*180,el(2:end,1)./pi.*180,0*el(2:end,1)+max(srpRefCum_dB{srcIdx},[],'all'),'k','LineWidth',2);
scatter3(xPeak(:,1)./pi.*180,yPeak(:,1)./pi.*180,0*yPeak(:,1)+1+max(srpRefCum_dB{srcIdx},[],'all'),'r^','filled');
hold off;
%% save
filename = 'RIRs.mat';
save(filename,'RIR','SRIR','binaural');

jsonData = struct;
assert(size(srcPos,1)==3);
jsonData.x = srcPos(1,:);
jsonData.y = srcPos(2,:);
jsonData.z = srcPos(3,:);
jsonTxt = jsonencode(jsonData);
filename = 'ls_position.json';
fileID = fopen(filename,'w');
fprintf(fileID,jsonTxt);
fclose(fileID);
%% refSeq and schroeder curves
audiowrite('IR_addMic.wav',IR_addMic,fs);
if 0
    for ii = 1:size(IR_addMic,2)
        [lags, ~, pks_dB] = refSeq(IR_addMic(:,ii),fs);
        revAtt = reverbCurve(IR_addMic(:,ii),fs);
    end
end
%%
if 0
run genReport_srcPos
run genReport_refSndDir2
end