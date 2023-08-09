function sndHedgehog = getSndHedgehog(IR,conf)
% sndHedgehog;% (sndIntSeriesNum,5) [I_az I_el I_dB p_dB t]
%%
sndIntSeries = getSndIntSeries(IR,conf);

winLen = round(conf.SegmentTime.*conf.fs);
sndIntSeries(1:conf.onsetIdx-1,:) = [];
IR(1:conf.onsetIdx-1,:) = [];

t = ((1:length(sndIntSeries(:,1)))-1).'./conf.fs;
%% direct sound
I = sum(sndIntSeries(1:winLen,:),1);
[azimuth,elevation,r0] = cart2sph(I(1),I(2),I(3));
p0 = rms(IR(1:winLen,1,1));
sndHedgehog(1,:) = [azimuth,elevation,0,0,mean(t([1,winLen]))];

%% other sound
ii = 2;
idx = winLen+1;
while idx+winLen-1<=length(t)
    I = sum(sndIntSeries(idx:idx+winLen-1,:),1);
    [azimuth,elevation,r] = cart2sph(I(1),I(2),I(3));
    I_dB = 10*log10(r./r0);
    p_dB = mag2db(rms(IR(idx:idx+winLen-1,1))./p0);
    if p_dB>-conf.OffsetdB
        sndHedgehog(ii,:) = [azimuth,elevation,I_dB,p_dB,mean(t([idx,idx+winLen-1]))];
        ii = ii+1;
    end
    idx = idx+winLen;
end
end