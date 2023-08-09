clc
clear all
%% load plugin
pluginpath = 'Sennheiser AMBEO A-B format converter.vst3';
% audioTestBench(pluginpath);
hostedPlugin = loadAudioPlugin(pluginpath);
pluginInfo = info(hostedPlugin)
% dispParameter(hostedPlugin)
%                   Parameter    Value    Display
%         ________________________________________
%      1            High Pass:   0.0000       off 
%      2   Coincidence Filter:   1.0000        on 
%      3             Rotation:   0.5000         0 
%      4             Position:   0.0000   Upright 
%      5        Output Format:   1.0000     ambiX 
%      6               Bypass:   0.0000       Off 
%% config
% setParameter(hostedPlugin,'High Pass',0);
% setParameter(hostedPlugin,'Coincidence Filter',1);
% setParameter(hostedPlugin,'Rotation',0.5);
% setParameter(hostedPlugin,'Position',0);
setParameter(hostedPlugin,'Output Format',0);% Fuma
% setParameter(hostedPlugin,'Bypass',0);
fs = 48000;
setSampleRate(hostedPlugin,fs);

% getParameter(hostedPlugin,'Rotation')
disp(getSampleRate(hostedPlugin));
%%
A = [1 1 1 1;1 1 -1 -1;1 -1 1 -1;1 -1 -1 1];% Lf Rf Lb Rb to W X Y Z
figure;
audioIn = [[1 0 0 0];zeros(99,4)];
audioOut = process(hostedPlugin,audioIn);
plot(audioOut);
hold on;
legend
audioIn = [[0 1 0 0];zeros(99,4)];
audioOut = process(hostedPlugin,audioIn);
plot(audioOut);
audioIn = [[0 0 1 0];zeros(99,4)];
audioOut = process(hostedPlugin,audioIn);
plot(audioOut);
audioIn = [[0 0 0 1];zeros(99,4)];
audioOut = process(hostedPlugin,audioIn);
plot(audioOut);

audioIn = [[1 0 0 0];zeros(99,4)];
audioOut = process(hostedPlugin,audioIn);
fvtool(audioOut(:,1),'Fs',fs);
% fvtool(audioOut(:,2),'Fs',fs);
