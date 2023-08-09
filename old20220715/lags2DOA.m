function [aoa, score, relDistance] = lags2DOA(lags, d, c, fs, precision, pks)
[M,N] = size(lags,1,2);
% d = 0.2; % distance between microphones
% c = 344;
% precision = 0.1;
% fs = 192000/precision;
pks = pks./max(pks,[],1);
ratio = 1.2;
maxDiff = round(ratio*d/c*fs);
idxRange = (-maxDiff:precision:maxDiff);

lagsTrim = zeros(M,1);
score = zeros(M,1);

for m = 1:M
    relLags = lags(:,2:end)-lags(m,1);
    err = zeros(1,length(idxRange));
    for ii = 1:length(idxRange)
        err(ii) = norm(min(abs(relLags-idxRange(ii)*(1:N-1)),[],1));
    end
    [err0,ii] = min(err);
%     score(m) = 1/err0;
%     score(m) = (0.1+pks(m,1))/err0;
    score(m) = (0.1+pks(m,1))/(0.1+err0);
    lagsTrim(m) = idxRange(ii);
end
% stem(lag,(1:4)+0*lag)
aoa = asind(max(min(lagsTrim./fs.*c./d,1),-1));
relDistance = lags(:,1)./fs.*c;
[score, id] = sort(score,'descend');
aoa = aoa(id);
relDistance = relDistance(id);
end