function visualSndIntSeries(sndIntSeries,conf)
TODO
assert(size(sndIntSeries,2)==2);% 2D plot
arg = angle(sndIntSeries(:,1)+1i*sndIntSeries(:,2));
t = ((1:length(sndIntSeries(:,1)))-conf.onsetIdx)./conf.fs;
I = vecnorm(sndIntSeries,2,2);
end