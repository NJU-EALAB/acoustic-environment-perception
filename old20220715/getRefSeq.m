function refSeq = getRefSeq(IR, directIR, numPeak)
% get reflection sequence of the direct sound and (numPeak-1) reflections
% It is assumed that the sound absorption of a wall is independent of frequency
% INPUT
% IR: measurement impulse response [L,N]
% directIR: impulse response of direct sound [L0,N]
% numPeak: only (numPeak-1) reflections are considered
% OUTPUT
% refSeq: reflection sequence [L,N]

% addpath('./simulink');
N = size(IR,2);
if N ~= size(directIR,2)
    assert(1 == size(directIR,2));
    directIR = repmat(directIR,1,N);
end

refSeq = zeros(size(IR,1),N);

for ii = 1:N
    refSeq(:,ii) = getRefSeq_(IR(:,ii), directIR(:,ii), numPeak);
end
end

%%
%%
function refSeq = getRefSeq_(IR, directIR, numPeak)
% INPUT
% IR: measurement impulse response [L,1]
% directIR: impulse response of direct sound [L0,1]
% numPeak: only (numPeak-1) reflections are considered
% OUTPUT
% refSeq: reflection sequence

IR = IR(:);
directIR = directIR(:);

[r, lag] = xcorr(IR, directIR);
r = r(lag>=0);
refSeq = 0*r;

[~,locs] = findpeaks(xcorr(directIR),'SortStr','descend','NPeaks',5);
minPeakDistance = max(abs(locs-locs(1)));
disp(['minPeakDistance: ',num2str(minPeakDistance)]);

[~,locs] = findpeaks(r./max(r),'SortStr','descend','NPeaks',numPeak,'MinPeakHeight',0.0,'MinPeakDistance',minPeakDistance);
locs = locs(:);
idx = [-1;0;1]+locs.';
idx = idx(:);
idx(idx<1) = [];
idx(idx>numel(refSeq)) = [];
refSeq(idx) = r(idx);
% refSeqIdx = locs+parabolicFit(refSeq,locs);

debug = 0;
if debug
    lag = lag(lag>=0);
    figure;
    plot(lag,r);
    hold on;
    stem(lag,refSeq);
end
end