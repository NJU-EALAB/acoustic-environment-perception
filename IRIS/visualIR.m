function visualIR(IR,conf,ax)
assert(size(IR,2)==1);
yMax = max(abs(IR));
tMax = conf.tMax;
t = ((1:length(IR(:,1)))-conf.onsetIdx)./conf.fs;
%%
if nargin<3
    figure;
    ax = gca;
end
axes(ax);
hold on;
xlim([t(1) tMax]);
ylim([-yMax yMax]);

if isfield(conf,'ArrivalTimeColour')
    ArrivalTimeColour = conf.ArrivalTimeColour;
    TimeIntervalStart = 0;
    for ii = 1:numel(ArrivalTimeColour)
        TimeIntervalEnd = min(tMax,1e-3*ArrivalTimeColour(ii).TimeIntervalEnd);
        sqX = [TimeIntervalStart TimeIntervalEnd TimeIntervalEnd TimeIntervalStart];
        sqY = yMax*[-1 -1 1 1];
        RGB = ArrivalTimeColour(ii).Colour;
        fill(sqX,sqY,'r','EdgeColor','none','FaceColor',[RGB.R RGB.G RGB.B]./255,'FaceAlpha',0.8);
        TimeIntervalStart = TimeIntervalEnd;
    end
end

plot(t,IR,'k');
hold off;
end
