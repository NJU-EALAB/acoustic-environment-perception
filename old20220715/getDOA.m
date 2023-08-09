function [doa, pos] = getDOA(micPos, IR, fs, c)
% INPUT
% micPos: microphone position [2,N] or [3,N]
% IR: impulse response [L,N]
% fs: sample frequency in Hz
% c: speed of sound in m/s
% OUTPUT
% doa: [3,1]
% pos: mean mic pos[3,1]
r = 7;

pos = mean(micPos,2);
TDOA = getTDOA(IR, fs);
err = @(x)errTDOA(pos+sph2cartPos(x(1),x(2),r), micPos, TDOA, c);
% find init azel
az0 = 0;
el0 = 0;
for az = linspace(0,2*pi,100)
    for el = linspace(-pi/2,pi/2,100)
        if norm(err([az;el]))<norm(err([az0;el0]))
            az0 = az;
            el0 = el;
        end
    end
end
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','iter');
azel = lsqnonlin(err,[az0;el0],[],[],options);
doa = sph2cartPos(azel(1),azel(2),r);
end

function pos = sph2cartPos(az,el,r)
[x,y,z] = sph2cart(az,el,r);
pos = [x;y;z];
end