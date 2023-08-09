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
srcSelectIdx = [1:5 7:32];
% srcSelectIdx = [25 3];
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
    srp = frameProcessor(sh2srp,sh,frameLen,frameLen,3);
    srpCum_dB{srcIdx} = 0.5*mag2db(mean((db2mag(srp)).^2,3));
    %%%
    [directIdxSH] = getDirectIR(sh(:,1),fs);
    srpDir = frameProcessor(sh2srp, sh(directIdxSH(1):directIdxSH(2),:), frameLen, frameLen, 3);
    srpDirCum_dB{srcIdx} = 0.5*mag2db(mean((db2mag(srpDir)).^2,3));
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
    savefig(['powermap',num2str(srcIdx),'.fig']);
    %% get IRIS
    wxyz = real(frameProcessor(sh2slai,sh,frameLen));
    w(:,srcIdx) = wxyz(:,1);
    sndHedgehog = IRIS_BFormat(wxyz,conf);
    %% sparse DOA in SH domain (beta)
%     sparseDoaSH(sh,sphHarmType);
    close all;
end
%% get source position
%%%
switch 2
    case 1
        ESMAPos = [0;0;1.7];
        refMicIdx = 5;
        % refMicPos = zeros(3,1);
        [refMicPos(1,:),refMicPos(2,:),refMicPos(3,:)] = sph2cart(micParams.azi(refMicIdx),micParams.ele(refMicIdx),micParams.radius);
        refMicPos = ESMAPos+refMicPos;
        rRef = 5.69;
    case 2
       %% wall pos
       wallPos = [
           0,0,-0.001
           0,0,3.65
           9.14,0,0
           -6.24,0,0
           0,5.77,0
           0,-6.01,0
           ].';
       %% real pos in ez
        ESMAPos = [0;0;1.5];
        refMicIdx = 5;
        % refMicPos = zeros(3,1);
%         [refMicPos(1,:),refMicPos(2,:),refMicPos(3,:)] = sph2cart(micParams.azi(refMicIdx),micParams.ele(refMicIdx),micParams.radius);
%         refMicPos = ESMAPos+refMicPos;
        refMicPos = [0 1 1.2].';
%         pos = [5.00400000000000	3.40000000000000	2.46000000000000
% 5.00400000000000	1.70000000000000	2.46000000000000
% 5.00400000000000	0	2.46000000000000
% 5.00400000000000	-1.70000000000000	2.46000000000000
% 5.00400000000000	-3.40000000000000	2.46000000000000
% 5.68600000000000	0	2.46000000000000
% -6.92800000000000	1.31300000000000	2.46000000000000
% -6.92800000000000	-1.31300000000000	2.46000000000000
% 2.55000000000000	4	2.46000000000000
% 0.150000000000000	4	2.46000000000000
% -2.25000000000000	4	2.46000000000000
% -4.65000000000000	4	2.46000000000000
% 2.55000000000000	-4	2.46000000000000
% 0.150000000000000	-4	2.46000000000000
% -2.25000000000000	-4	2.46000000000000
% -4.65000000000000	-4	2.46000000000000
% 2.55400000000000	2.80500000000000	2.86000000000000
% 2.55400000000000	0.935000000000000	2.86000000000000
% 2.55400000000000	-0.935000000000000	2.86000000000000
% 2.55400000000000	-2.80500000000000	2.86000000000000
% 0.154000000000000	2.80500000000000	2.86000000000000
% 0.154000000000000	0.935000000000000	2.86000000000000
% 0.154000000000000	-0.935000000000000	2.86000000000000
% 0.154000000000000	-2.80500000000000	2.86000000000000
% -2.24600000000000	2.80500000000000	2.86000000000000
% -2.24600000000000	0.935000000000000	2.86000000000000
% -2.24600000000000	-0.935000000000000	2.86000000000000
% -2.24600000000000	-2.80500000000000	2.86000000000000
% -4.64600000000000	2.80500000000000	2.86000000000000
% -4.64600000000000	0.935000000000000	2.86000000000000
% -4.64600000000000	-0.935000000000000	2.86000000000000
% -4.64600000000000	-2.80500000000000	2.86000000000000];
        pos = [
5.72565280120966	3.01000000000000	2.35000000000000
5.72565280120966	1.60000000000000	2.35000000000000
5.72565280120966	0	2.35000000000000
5.72565280120966	-1.58000000000000	2.35000000000000
5.72565280120966	-3.13000000000000	2.35000000000000
6	0	0
-5.64434719879034	0.740000000000000	2.84000000000000
-5.64434719879034	-0.970000000000000	2.84000000000000
2.91565280120966	4.25000000000000	2.35000000000000
0.455652801209657	4.25000000000000	2.35000000000000
-1.89434719879034	4.25000000000000	2.35000000000000
-4.29434719879034	4.25000000000000	2.35000000000000
2.91565280120966	-4.48000000000000	2.35000000000000
0.455652801209657	-4.48000000000000	2.35000000000000
-1.89434719879034	-4.48000000000000	2.35000000000000
-4.29434719879034	-4.48000000000000	2.35000000000000
3.12565280120966	2.90000000000000	2.84000000000000
3.14565280120966	1.14000000000000	2.84000000000000
3.14565280120966	-1.37000000000000	2.84000000000000
3.12565280120966	-3.13000000000000	2.84000000000000
0.825652801209658	2.90000000000000	2.84000000000000
0.315652801209658	1.14000000000000	2.84000000000000
0.315652801209658	-1.37000000000000	2.84000000000000
0.825652801209658	-3.13000000000000	2.84000000000000
-2.29434719879034	2.90000000000000	2.84000000000000
-2.41434719879034	1.14000000000000	2.84000000000000
-2.41434719879034	-1.37000000000000	2.84000000000000
-2.29434719879034	-3.13000000000000	2.84000000000000
-4.64434719879034	2.90000000000000	2.84000000000000
-4.64434719879034	1.14000000000000	2.84000000000000
-4.64434719879034	-1.37000000000000	2.84000000000000
-4.64434719879034	-3.13000000000000	2.84000000000000
        ];
        x = pos(:,1).';
        y = pos(:,2).';
        z = pos(:,3).';
        srcPosReal = [x;y;z];
        [azReal_rad,elReal_rad,~] = cart2sph(x-ESMAPos(1),y-ESMAPos(2),z-ESMAPos(3));
        [~,~,rReal] = cart2sph(x-refMicPos(1),y-refMicPos(2),z-refMicPos(3));
        azelReal = [azReal_rad;elReal_rad].'./pi.*180;
        rRef = vecnorm(srcPosReal(:,3)-refMicPos,2,1);
end
load(dataPath0);
%%%
c = 343;
warning('offset: 8 deg.');
azelAll_rad = (azelAll-[8 0])./180.*pi;
% azelAll_rad = (azelAll)./180.*pi;
if 0
    IR4TDOA = squeeze(IR(refMicIdx,:,:)).';
    [directIdx] = getDirectIR(IR4TDOA,fs);
    mask = 0*IR4TDOA;
    for ii = 1:size(IR4TDOA,2)
        mask(directIdx(1,ii):directIdx(2,ii),ii) = 1;
    end
    r = c*getTDOA(IR4TDOA.*mask, fs);% from spks to refMic
else
    IR_addMic = double(cell2mat(Data{1, 1}.IR(end,:)));
    IR4TDOA = IR_addMic(:,srcSelectIdx);
    [directIdx] = getDirectIR(IR4TDOA,fs);
    mask = 0*IR4TDOA;
    for ii = 1:size(IR4TDOA,2)
        mask(directIdx(1,ii):directIdx(2,ii),ii) = 1;
    end
    r = c*getTDOA(IR4TDOA.*mask, fs);% from spks to refMic
end
r = r-r(3)+rRef;% from spks to refMic
srcPos = aziEleDis2Pos(azelAll_rad.',ESMAPos,r,refMicPos);
figure;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:));
hold on
scatter3(srcPos(1,:),srcPos(2,:),srcPos(3,:));
axis equal;
title('扬声器位置')
% zlim([0 3]);
dSrcPos = vecnorm(srcPosReal(:,srcSelectIdx)-srcPos,2,1);
dr = abs(r-rReal(:,srcSelectIdx));
[~, dSrcAngle] = getIncludedAngle(srcPos-ESMAPos,srcPosReal(:,srcSelectIdx)-ESMAPos);
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
    'wallPos','srcPosReal','srcSelectIdx','ESMAPos','srpCum_dB');
% load('data_powermap.mat');
srcIdx = 5;
azimuth0 = azimuth(1:end-1)-8/180*pi;
[az,el] = getSoundAzel(wallPos, srcPosReal(:,srcSelectIdx(srcIdx)), ESMAPos);
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
% load(dataPath0);
fs = Data{1}.fs;
IR0 = double(cell2mat(Data{1, 1}.IR(1).'));
refSeq(IR0,fs);
reverbCurve(IR0,fs);

figure;
filtertype = 'FIR';
Rp = 0.1;
Astop = 40;
lowPassFilter = dsp.LowpassFilter(...
    'DesignForMinimumOrder',false, ...
    'SampleRate',conf.fs, ...
    'FilterType',filtertype, ...
    'FilterOrder',512, ...
    'PassbandFrequency',10000, ...
    'PassbandRipple',Rp, ...
    'StopbandAttenuation',Astop);
irFilt = lowPassFilter(IR0);
tiledlayout('flow');
nexttile;plot(IR0)
nexttile;plot(irFilt)
nexttile;plot(abs(fft(IR0)))
nexttile;plot(abs(fft(irFilt)))