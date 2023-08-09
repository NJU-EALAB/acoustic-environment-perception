c = 344;
fs = 48000;
eleDis = 0.092;
insig = refSeq(:,1:4);
precision = 0.1;
[E, theta, lag] = delaySum_(insig,eleDis,fs,c,precision);
[pks,locs] = findpeaks(E,'SortStr','descend','NPeaks',10,'MinPeakHeight',0,'MinPeakDistance',0);
EP = E(locs);
thetaP = theta(locs);
lagP = lag(locs);
%%
nstart = 133000;
lagP-nstart
figure;
plot(insig(nstart:nstart+3000-1,:));
hold on
plot(lagP-nstart,1e-6+0*lagP,'bo');
figure;
plot(theta,E);
hold on
stem(thetaP,EP);
function [E, theta, lag] = delaySum_(insig,eleDis,fs,c,precision)
if nargin<5
    precision = 1;
end
if precision>0 && precision<1
    [p,q] = rat(1/precision);
    insig = resample(insig,p,q);
elseif precision ~= 1
    error('invalid precision');
end
maxIdx = ceil(eleDis/c*fs/precision);
N = size(insig,2);
insig = [zeros(maxIdx,N);insig;zeros(maxIdx,N);];
idxRange = -maxIdx:maxIdx;
for ii = 1:length(idxRange)
    theta(ii) = real(asind(idxRange(ii)*precision/fs*c/eleDis));
    outsig = insig(:,1);
    for jj = 2:N
        outsig = outsig+circshift(insig(:,jj),(jj-1)*idxRange(ii));
    end
    E(ii) = norm(outsig).^2;
%     E(ii) = max(abs(outsig));
%     outsig = movsum(outsig.^2,5);
%     [E(ii),lag(ii)] = max(outsig);
end
% lag = (lag-maxIdx).*precision;
lag = NaN;
end