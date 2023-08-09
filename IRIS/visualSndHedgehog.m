function visualSndHedgehog(sndHedgehog,conf,ax)
assert(size(sndHedgehog,2)==5);% [I_az I_el I_dB p_dB t]
tMax = conf.tMax;
%%
if nargin<3
    figure;
    ax = gca;
end
axes(ax);
hold on;
ArrivalTimeColour = conf.ArrivalTimeColour;
lgFlag = zeros(1,numel(ArrivalTimeColour));
DisplayName = cell(1,size(sndHedgehog,1));
for jj = 1:size(sndHedgehog,1)
    TimeIntervalStart = 0;
    for ii = 1:numel(ArrivalTimeColour)
        TimeIntervalEnd = min(tMax,1e-3*ArrivalTimeColour(ii).TimeIntervalEnd);
        if (TimeIntervalStart<=sndHedgehog(jj,5))&&(sndHedgehog(jj,5)<TimeIntervalEnd)
            RGB = ArrivalTimeColour(ii).Colour;
            [x,y,z] = sph2cart(sndHedgehog(jj,1),sndHedgehog(jj,2),sndHedgehog(jj,4)+conf.OffsetdB);
            if lgFlag(ii) == 0
                DisplayName{jj} = [num2str(1000*TimeIntervalStart),' - ',num2str(1000*TimeIntervalEnd)];
                lgFlag(ii) = 1;
            else
                DisplayName{jj} = '';
            end
            plot3([0 x],[0 y],[0 z],'Color',[RGB.R RGB.G RGB.B]./255,'LineWidth',3);

            break;
        end
        TimeIntervalStart = TimeIntervalEnd;
    end
end
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
axis(conf.OffsetdB*[-1 1 -1 1 -1 1]);
grid on;
try
    legend21b(DisplayName{:});
end
view(30,30)
hold off;
end