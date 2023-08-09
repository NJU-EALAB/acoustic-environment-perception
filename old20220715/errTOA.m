function errLsq = errTOA(srcPos, micPos, TOA0, c)
% INPUT
% srcPos: source position [2,1] or [3,1]
% micPos: microphone position [2,N] or [3,N]
% TOA0: time of arrival [1,N]
% c: speed of sound in m/s
% OUTPUT
% errLsq: error function for lsqnonlin
srcPos = srcPos(:);
assert(abs(length(srcPos)-2.5) <0.6);
assert(length(srcPos) == size(micPos,1));
TOA = vecnorm(srcPos-micPos,2,1)./c;% time of arrival
errLsq = (TOA0-TOA).';
end