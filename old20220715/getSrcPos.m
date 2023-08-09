function [srcPos, errSrcPos] = getSrcPos(micPos, IR, fs, c, srcPos0)
% INPUT
% micPos: microphone position [2,N] or [3,N]
% IR: impulse response [L,N]
% fs: sample frequency in Hz
% c: speed of sound in m/s
% OUTPUT
% srcPos: source position [2,1] or [3,1]
% errSrcPos: 3*c*std(err(srcPos));
if nargin<5
    srcPos0 = zeros(size(micPos,1),1);
end
TDOA = getTDOA(IR, fs);
err = @(srcPos)errTDOA(srcPos, micPos, TDOA, c);
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','off');
srcPos = lsqnonlin(err,srcPos0,[],[],options);
errSrcPos = 3*c*std(err(srcPos));
end