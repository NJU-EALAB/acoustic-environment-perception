function [revAtt, channelNames] = reverbCurve(IR,fs)
IR_ita = itaAudio;
% Set sampling rate
IR_ita.samplingRate = fs;
% Let's set the time data, you could use your own MATLAB data here !
IR_ita.time = IR;

raResults = ita_roomacoustics(IR_ita, 'EDC', 'freqRange', [100 4000], 'bandsPerOctave', 1);
revAtt = raResults.EDC.time;
channelNames = raResults.EDC.channelNames;
%% plot
itaPlotFlag = 0;
if itaPlotFlag
    raResults.EDC.plot_time_dB
else
    t = (0:size(revAtt,1)-1)./fs;
    revAtt_db = 0.5*mag2db(revAtt./revAtt(1));
    figure;
    plot(t,revAtt_db);
    xlabel('t(s)');
    ylabel('E(dB)');
    legend(channelNames);
end
title('混响声衰减特性曲线');
end