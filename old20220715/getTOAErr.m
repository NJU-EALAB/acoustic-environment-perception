function err = getTOAErr(lags, pks, micPos, srcPos, refSrcPos, c, fs)
numPksDir = 3;
[M,N] = size(lags,1,2);
pks = pks./max(pks,[],1);
[pks, idx] = sort(pks,1,'descend');
for n = 1:N
    lags(:,n) = lags(idx(:,n),n);
end
%% direct sound
lagsOA = vecnorm(micPos-srcPos,2,1)./c.*fs;
lagsDOA = lagsOA-lagsOA(1);
errLags = lags(1:numPksDir,:)-lagsDOA;
err0 = inf;
for m = 1:numPksDir
    relLags = errLags(:,2:end)-errLags(m,1);
    [~, idx] = min(abs(relLags),[],1);
    err = var([0;diag(relLags(idx,:))]);
    if (m==1)&&any(idx~=1)
        warning('warning: direct peak is not first peak');
    end
    if err<err0
        err0 = err;
        lagsComp = lagsOA-diag(lags([m idx],:)).';
    end
end
soundPath = (lags+lagsComp)./fs.*c;
debug = 0;
if debug
    figure;
    for ii = 1:size(soundPath,2)
        plot(soundPath(:,ii),pks(:,ii),'*','LineWidth',3);
        hold on;
    end
    drawnow;
end
%% reflect sound
% load('matlab.mat');
tic
err = zeros(1,size(refSrcPos,2));
for ii = 1:size(refSrcPos,2)
    soundPathReal = vecnorm(micPos-refSrcPos(:,ii),2,1);
    errPath = soundPath(2:end,:)-soundPathReal;
    [~, idx] = min(abs(errPath),[],1);%./(0+pks)
    %     pksNorm(ii) = norm(diag(pks(idx,:)));
    errPathMin = diag(errPath(idx,:));
        err(ii) = norm(errPathMin-mean(errPathMin),2).^2./(length(errPathMin)-1);
%     err(ii) = norm(errPathMin-mean(errPathMin),1)./(length(errPathMin)-1);
end
toc
end