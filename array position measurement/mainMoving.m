clear all
addpath(genpath(cd));

run init.m

posData = struct;
udpPort = udpport('LocalHost','127.0.0.1','LocalPort',5006,'Timeout',3600);
flush(udpPort);

n=5;
medFiltPos = dsp.MedianFilter(n);
medFiltAzi = dsp.MedianFilter(n);

plotStep = 10;
figure;
scatter3(ancPos(1,:),ancPos(2,:),ancPos(3,:),'LineWidth',2);
view([0 90]);
hold on;
ix = 0;

while true
   [posData, tagName] = posDataDecode(posData, udpPort);
   
    % position
    posData.(tagName) = getLocationMoving(posData.(tagName),ancPos);
    % azimuth
    posData.(tagName).azimuth = posData.(tagName).rawData(6);
    %% median data
    if strcmp(tagName,'t1')
        pos = medFiltPos(posData.(tagName).locationMoving.');
        pos = pos.';
        azi = medFiltAzi(posData.(tagName).azimuth);
        % print
        disp(pos.');
        disp(azi);
        % plot
        scatter3(pos(1),pos(2),pos(3),'filled','r');
        if mod(ix,plotStep) == 0
            drawnow;
        end
    end
end







