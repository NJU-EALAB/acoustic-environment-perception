function TDOA = getTDOA4GUI(IR, fs, refSpkIdx)
% INPUT
% IR: impulse response [L,N]
% fs: sample frequency in Hz
% OUTPUT
% TDOA: time difference of arrival in s. [1,N]
precision = 0.1;
TDOA = getLag(IR, IR(:,refSpkIdx), precision)./fs;
assert(TDOA(refSpkIdx)==0);
end