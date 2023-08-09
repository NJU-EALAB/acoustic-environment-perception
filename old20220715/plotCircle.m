function plotCircle(r,center,plotConf,~)
theta = linspace(0,2*pi,1000);
hold on;
for ii = 1:size(center,2)
    x = center(:,ii)+r(ii)*[cos(theta);sin(theta)];
    plot(x(1,:),x(2,:),plotConf);
    if nargin>=4
        plot([center(1,ii),x(1,125)],[center(2,ii),x(2,125)],plotConf);
    end
end
% hold off;
end