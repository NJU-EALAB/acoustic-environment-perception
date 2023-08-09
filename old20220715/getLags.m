function [lags, pks] = getLags(IR, directIR, numIR, precision)
% get lags of the direct sound and (NumIR-1) reflections
% It is assumed that the sound absorption of a wall is independent of frequency
% INPUT
% IR: measurement impulse response [L,N]
% directIR: impulse response of direct sound [L0,N]
% numIR: only (NumIR-1) reflections are considered
% precision: precision of lags
% OUTPUT
% lags: room impulse response [NumIR,N]

if nargin<4
    precision = 1;
end
N = size(IR,2);
if N ~= size(directIR,2)
    assert(1 == size(directIR,2));
    directIR = repmat(directIR,1,N);
end
lags = zeros(numIR,N);
pks = zeros(numIR,N);
if precision>0 && precision<1
    [p,q] = rat(1/precision);
    IR = resample(IR,p,q);
    directIR = resample(directIR,p,q);
elseif precision ~= 1
    error('invalid precision');
end

minPeakDistance = max(abs(getRoomIR_(directIR(:,1), directIR(:,1), 9, 0)));
disp(['minPeakDistance: ',num2str(minPeakDistance)]);
for ii = 1:N
    [lags(:,ii), pks(:,ii)] = getRoomIR_(IR(:,ii), directIR(:,ii), numIR, minPeakDistance);
end
lags = precision*lags;
end

%%
%%
function [lags, pks] = getRoomIR_(IR, directIR, numIR, minPeakDistance)
% INPUT
% IR: measurement impulse response [L,1]
% directIR: impulse response of direct sound [L0,1]
% numIR: only (NumIR-1) reflections are considered
% OUTPUT
% lags: lags of the direct sound and (NumIR-1) reflections [NumIR,1]

IR = IR(:);
directIR = directIR(:);
[r, lag] = xcorr(IR, directIR);
[pks,locs] = findpeaks(r./max(abs(r)),'SortStr','descend','NPeaks',numIR,'MinPeakHeight',0.0,'MinPeakDistance',minPeakDistance);
lagsTmp = lag(locs(1:min(numIR,numel(locs))));
lags = nan(numIR,1);
lags(1:numel(lagsTmp)) = lagsTmp;
pks = [pks;nan(numIR-numel(pks),1)];

debug = 0;
if debug
    figure;
    plot(lag,r);
    hold on;
    stem(lag(locs),max(abs(r))*pks);
    drawnow;
end
end