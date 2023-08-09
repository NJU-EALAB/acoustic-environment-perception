function lags = getLags(IR, directIR, numIR, precision)
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
if precision>0 && precision<1
    [p,q] = rat(1/precision);
    IR = resample(IR,p,q);
    directIR = resample(directIR,p,q);
elseif precision ~= 1
    error('invalid precision');
end

for ii = 1:N
    [roomIR, lags(:,ii)] = getRoomIR_(IR(:,ii), directIR(:,ii), numIR);
end
lags = precision*lags;
end

%%
%%
function [roomIR, lags] = getRoomIR_(IR, directIR, numIR)
% INPUT
% IR: measurement impulse response [L,1]
% directIR: impulse response of direct sound [L0,1]
% numIR: only (NumIR-1) reflections are considered
% OUTPUT
% roomIR: room impulse response [L,1]
% lags: lags of the direct sound and (NumIR-1) reflections [NumIR,1]

IR = IR(:);
L = length(IR);
directIR = directIR(:);
L0 = length(directIR);
IR = [IR;zeros(L0,1)];
roomIR = zeros(L,1);
lags = zeros(numIR,1);

for ii = 1:numIR
    [r, lag] = xcorr(IR, directIR);
    [~, I] = max(r);%max(abs(r));
    maxIdx = lag(I);
    assert(maxIdx>=0);
    lags(ii) = maxIdx;
    roomIR(maxIdx+1) = roomIR(maxIdx+1)+directIR\IR(maxIdx+1:maxIdx+L0);
    IR(maxIdx+1:maxIdx+L0) = IR(maxIdx+1:maxIdx+L0)-roomIR(maxIdx+1)*directIR;
end
assert(length(roomIR) == L);
% plot(roomIR)
end