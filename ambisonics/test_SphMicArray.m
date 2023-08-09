clear all
addpath(genpath(cd));
addpath(genpath('../tools/'));

%% init
micParams = MicArrayPresets('em32');
fs = 44100;
frameLen = 1024;
disp(frameLen/fs);

sphHarmType = 'complex';

%% init pw2sh
maxSHOrder = 20;
pw2sh = PW2SH(maxSHOrder,'sphHarmType',sphHarmType);
pw2sh.setup;
%% init sh2sma
filterOrder = 2048;
sh2sma = SH2SMA(micParams,maxSHOrder,fs,filterOrder,'sphHarmType',sphHarmType);
sh2sma.setup;
%% init sh2sma_freq
freq = [1000 2000];
sh2sma_freq = SH2SMA_freq(micParams,maxSHOrder,freq,'sphHarmType',sphHarmType);
sh2sma_freq.setup;
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
sectorAzimuth = [0 pi/2 pi -pi/2];
sectorElevation = [0 0 0 0];
patternWeight = 'omni';
sh2slai = SH2SLAI(sectorAzimuth,sectorElevation,maxOrder-1,lowPassFilterParams,patternWeight,'sphHarmType',sphHarmType);
sh2slai.setup;
%% simulation
pw.az = [100]./180.*pi;
pw.el = [-10]./180.*pi;
sinFreq = [2000];
noiseGain = 0.1;
% pw.az = [0 0]./180.*pi;
% pw.el = [-20 0]./180.*pi;
% sinFreq = [1000 2000];
% noiseGain = 0.01;
sine = dsp.SineWave('Frequency',sinFreq,'SampleRate',fs,'SamplesPerFrame',frameLen);
u = [ones(1,numel(pw.az));zeros(frameLen-1,numel(pw.az))];
% shW = zeros(1,(maxSHOrder+1)^2);
% shW(2) = 1;
figure;
for ii = 1:1000
%     ii
    
    sh0 = pw2sh(sine(),pw.az,pw.el);
%     sh0 = pw2sh(randn(frameLen,numel(pw.az)),pw.az,pw.el);
%     sh0 = pw2sh(u,pw.az,pw.el);u = 0*u;
    sma = sh2sma(sh0);
    sma = sma+noiseGain*randn(size(sma));
    sma_freq = sh2sma_freq(pw2sh(1,pw.az,pw.el));
    tic;    
    sh = sma2sh(sma);
    srp = sh2srp(sh);
%     srp = sh2srp(sh0(:,1:size(sh,2)));
    [wxyz,azel] = sh2slai(sh);
%     [slai,azel] = sh2slai(sh0(:,1:size(sh,2)));
    toc;
    
    [srpEl,idxEl] = max(srp);
    [srpMax,idxAz] = max(srpEl);
    idxEl = idxEl(idxAz);
    disp([azimuth(idxAz)./pi.*180,elevation(idxEl)./pi.*180,srpMax])
    disp(azel./pi.*180);
    srpSurf = surf(azimuth./pi.*180,elevation./pi.*180,srp);
    % shading interp
%     axis equal
    view(2)
    dt = datatip(srpSurf,'DataIndex',size(srp,1)*(idxAz-1)+idxEl);
    drawnow
end
%%
