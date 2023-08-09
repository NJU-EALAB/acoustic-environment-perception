function TDOA = getTDOA(IR, fs)
% INPUT
% IR: impulse response [L,N]
% fs: sample frequency in Hz
% OUTPUT
% TDOA: time difference of arrival in s. [1,N]
precision = 0.1;
TDOA = getLag(IR, IR(:,end), precision)./fs;
assert(TDOA(end)==0);
end