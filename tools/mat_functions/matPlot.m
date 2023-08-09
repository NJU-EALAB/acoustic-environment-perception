function matPlot(y)
[M,N] = size(y,[1 2]);
t = tiledlayout(figure,M,N,'Padding', 'tight','TileSpacing','tight');
t.Units = 'inches';
t.OuterPosition = 4*[0 0 N M];
ymax = max(y,[],'all');
ymin = min(y,[],'all');
for ii = 1:M
    for jj = 1:N
        nexttile(N*(ii-1)+jj);
        plot(squeeze(y(ii,jj,:)));
        ylim([ymin,ymax]);
    end
end
end