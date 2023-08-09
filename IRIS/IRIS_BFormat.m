function sndHedgehog = IRIS_BFormat(IR,conf)
%% get onset index
% confDirect.fs = conf.fs;
% confDirect.windowLength = 1000*conf.SegmentTime;% [ms] 时间窗长度
% confDirect.threshold = -conf.directSoundThresholdDB;% [dB] 大于阈值视为直达声起始部分
[directIdx, directIR] = getDirectIR(IR(:,1),conf.fs);
conf.onsetIdx = directIdx(1);
%% get hedgehog
sndHedgehog = getSndHedgehog(IR,conf);
sndHedgehog(:,1:2) = transAzEl(sndHedgehog(:,1:2),conf.axis);
sndHedgehog_deg = [sndHedgehog(:,1:2)./pi.*180, sndHedgehog(:,3:end)];
% disp(sndHedgehog_deg);
%% plot sound intensity
N = 6;
figh = figure;
figh.WindowState = 'maximized';
t = tiledlayout(figh,N,1);
ax = nexttile(t,1);
ax.Layout.TileSpan = [N-1,1];
visualSndHedgehog(sndHedgehog,conf,ax);
%% plot IR W
ax = nexttile(t,N);
visualIR(IR(:,1),conf,ax);

end