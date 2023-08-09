function [directIdx, directIR] = getDirectIR(IR,confOrFs)
if isstruct(confOrFs)
    [directIdx, directIR] = getDirectIR_old(IR,confOrFs);
else
    winLen = round(confOrFs*0.002);
    chNum = size(IR,2);
    directIdx = zeros(2,chNum);
    directIR = zeros(winLen,chNum);
    for ii = 1:chNum
        irIta = itaAudio();
        irIta.timeData = IR(:,ii);
        sampleStart = ita_start_IR(irIta);
        directIdx(1,ii) = max(1,sampleStart-round(winLen./10));
        directIdx(2,ii) = directIdx(1,ii)+winLen-1;
        directIR(:,ii) = IR(directIdx(1,ii):directIdx(2,ii),ii);
    end
end
end
%%
function [directIdx, directIR] = getDirectIR_old(IR,conf)
% INPUT
% IR;% (IRLen,channelNum)
% conf.fs;
% conf.windowLength;% [ms] 时间窗长度
% conf.threshold;% [dB] 大于阈值视为直达声起始部分
% OUTPUT
% directIdx;% (2,chNum)
% directIR;% (winLen,chNum)
%%
chNum = size(IR,2);
absIR = abs(IR);
[maxIR,maxIRIdx] = max(absIR,[],1);
if isnumeric(conf.windowLength)
    winLen = round(conf.fs*0.001*conf.windowLength);
    directIR = zeros(winLen,chNum);
end

threshold = db2mag(conf.threshold)*maxIR;
directIdx = zeros(2,chNum);

for ii = 1:chNum
    directIdx(1,ii) = find(absIR(:,ii)>=threshold(ii),1);
    directIdx(2,ii) = directIdx(1,ii)+winLen-1;
    directIR(:,ii) = IR(directIdx(1,ii):directIdx(2,ii),ii);
    if (maxIRIdx(ii)>directIdx(2,ii))
        warning(sprintf('WindowLength is too short. maxIRIdx: %d; winEndIdx: %d',maxIRIdx(ii),directIdx(2,ii)));
    end
end

end