function azi = aziCorr(azi,azi0)
% in: -180<=azi<=180
% out: 0<=azi<360
azi = azi-azi0(1);
azi0 = azi0-azi0(1);
azi = mod(azi,360);
azi0 = mod(azi0,360);

if length(azi0) > 1
    aziTrue = linspace(0,360,length(azi0)+1);
    azi0 = [azi0(:);azi0(1)+360];
    azi = interp1(azi0,aziTrue,azi(:));
end

azi = mod(azi,360);