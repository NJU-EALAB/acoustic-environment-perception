%% 
% DirData = MS.run
% save('rir.mat','DirData')
%% Dir Measurement

use_TurnTable = 1;
TurnTable_No = 3;

%%
count = 20;
% count = 4;

dAngle = -360/count;
% dAngle = 0;
start_phi = 90;

r = 2;
theta = 90;

% about Coordinates check this file
% open ita_tutorial_itaCoordinates;

end_phi = start_phi + dAngle*(count-1);

% samplingCoords = itaCoordinates(count);
% samplingCoords.theta = theta*pi/180;
% samplingCoords.phi = [start_phi:dAngle:end_phi] *pi/180;

samplingCoords = ita_generateSampling_equiangular(start_phi:dAngle:end_phi,theta);
samplingCoords.r = r;

% have a look
scatter(samplingCoords);

DirData = itaAudio(count,numSpk);

%% Turntable connect
if(use_TurnTable)
    if TurnTable_No == 1        
        u = udp('192.168.1.177',8888);
        fopen(u);
    elseif TurnTable_No == 2
%         dAngle = -10;
        angle = dAngle*count;
        tcpclient = tcpip('192.168.181.181',8181, 'Timeout', 60,'OutputBufferSize',10240,'InputBufferSize',10240);
        fopen(tcpclient);
        fwrite(tcpclient,'CT+SPKMUTE(1);');
        fwrite(tcpclient,'CT+HEARTBEAT(0);');
    elseif TurnTable_No == 3
        Com_part = 'COM5'; % View the COM port in Device Manager
        Direc = (sign(dAngle)+1)/2; % direction of rotation: 1 means clockwise; 0 means anticlockwise;
        Selflock = 1; % self-lock: 1 means self-lock in the absence of signal; 0 means free rotation in the absence of signal
        Arduino_StepMotor_Move( Com_part, 0, 0, 0 ); % test & setup global variable
    else
        error('No such TurnTable_No.');
    end
end
%% Measurement Go
% pause(10);
tic;
for ii = 1:(count)          % Direction
    %% Measurement
    for jj = 1:length(OutChannelMap)  % Spk
        
        MS.outputChannels = OutChannelMap(jj);
        
        if ismember(jj,TwChannelMap)
           MS.freqRange = twfreqRange;         
        end
        
        DirData(ii,jj) = MS.run;
%         DirData(ii,jj).channelCoordinates = samplingCoords;
        DirData(ii,jj).comment = ['spk_' num2str(jj) '@ dir_' num2str(ii)];
    end     
    %% Turntable Op.
    if(use_TurnTable)
        if TurnTable_No == 1
            fwrite (u,'1');
            flag = 1;
            while flag
                Check = 'none';
                Check = fscanf(u,'%s');
                if (strcmp(Check,'done'))
                    flag = 0;
                end
            end
            pause(0.8);
        elseif TurnTable_No == 2
            pause(0.1);
            turnTable(tcpclient, dAngle);
        elseif TurnTable_No == 3
            pause(0.1);
            Arduino_StepMotor_Move( Com_part, Direc, abs(dAngle), Selflock );
            pause(1);
            Arduino_StepMotor_Move( Com_part, 0, 0, 0 );
            pause(1);
        else
            error(' No such TurnTable_No.');
        end
    end
    %% Peek Result
    if(~use_TurnTable)
        DirData{ii,1}.pt;
    end

    fprintf('Measured \t %d \t of %d \n' ,ii,count);
    
    if(ii<count && ~use_TurnTable)
        pause;
    end
    
end

toc;

%%
% Use merge() to comibe itaAudio
for jj = 1:length(OutChannelMap)  % Spk
    for ii = 1:(count)          % Direction
        tmp(ii) = DirData(ii,jj);
    end
    SpkDir(jj) = merge(tmp);
    SpkDir(jj).channelCoordinates = samplingCoords;
end

%% TurnTable
if(use_TurnTable)
    if TurnTable_No == 1        
        fclose(u);
    elseif TurnTable_No == 2
        pause(0.5);
%         turnTable(tcpclient, -angle);
        fclose(tcpclient);
        delete(tcpclient);
    elseif TurnTable_No == 3
        pause(2);
        Arduino_StepMotor_Move( Com_part, 1-Direc, abs(count*dAngle), Selflock );
        Arduino_StepMotor_Move( Com_part, 0, 0, 0 );
    else
        error(' No such TurnTable_No.');
    end
end

%%

filename = string(datetime,'yyyyMMdd_HH_mm_ss');
save(filename,'DirData','MS');


