% clear all
% addpath(genpath(cd));

run init.m

posData = struct;
udpPort = udpport('LocalHost','127.0.0.1','LocalPort',5006,'Timeout',3600);
flush(udpPort);

cumMeanPos = CumMean;
cumMeanAzi = CumMean;

while true
    [posData, tagName] = posDataDecode(posData, udpPort);
    % position
    posData.(tagName) = getLocationFixed(posData.(tagName),ancPos,tagZ);
    % azimuth
    posData.(tagName).azimuth = posData.(tagName).rawData(6);
    %% mean data
    if strcmp(tagName,'t1')
        azi = cumMeanAzi(posData.(tagName).azimuth);
        % decide save or not
        disp([posData.(tagName).locationFixed.' posData.(tagName).error]);
        if posData.(tagName).error < 1+0*0.065
            pos = cumMeanPos(posData.(tagName).locationFixed);
            errorBetween = norm(cumMeanPos.dMean);
            if errorBetween <= 0.001
                azi = aziCorr(azi,azi0);
                % print
                disp('Position is found.')
                disp(pos.');
                disp(azi);
                
                break;
            end
        end
    end
end








