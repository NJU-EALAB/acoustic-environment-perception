function results_refSeq(IRPath)
numPeak = 50;
conf.windowLength = 1;% [ms] 时间窗长度
conf.threshold = -40;% [dB] 大于阈值视为直达声起始部分
%%
load(IRPath);
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR(1).');
%%
figure;
plot(IR./max(IR));
title('RIR');
% dirIRStart = input('dirIRStart: ');
% dirIREnd = input('dirIREnd: ');
% dirIR = IR(dirIRStart:dirIREnd);
%%
conf.fs = fs;
[~, dirIR] = getDirectIR(IR,conf);
figure;
plot(dirIR./max(dirIR));
title('直达声IR');
%%
% error('Enter the direct sound range.');
% dirIR = IR(4220:4295);% Enter the direct sound range.
% figure;
% plot(dirIR./max(dirIR));
%%
% refSeq = getRefSeq(IR, dirIR, numPeak);
% refSeq = refSeq./max(refSeq,[],1);
[lags, pks] = getLags(IR, dirIR, numPeak, 0.1);
lags = (lags-lags(1))./fs;
figure;
% plot(0:length(refSeq)-1,refSeq);
% hold on;
stem(lags,pks);
xlabel('t(s)');
title('早期反射声时间序列');
end