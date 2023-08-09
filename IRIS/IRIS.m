function sndHedgehog = IRIS(data,chIdx,axis)
if nargin < 3
    axis = eye(3);
end
%% setting
conf.OffsetdB = 40;
conf.SegmentTime = 0.002;
%% advanced setting
confIRIS = readstruct('measurement.xml');
conf.ArrivalTimeColour = confIRIS.Project.ResultsViewData.IrisPlotViewData.ArrivalTimeColoursList.ArrivalTimeColours(1).ArrivalTimeColourList.ArrivalTimeColourItem; 
conf.directSoundThresholdDB = 30;
conf.tMax = 1.5;% [s]
conf.LPfilterFc = 5000; %[Hz]
%% init
IRISPath = fileparts(mfilename('fullpath'));
addpath([IRISPath,'/../']);
%% load
% load(IRPath);
% data = Data{1};
conf.fs = data.fs;
IRAFormat = cell2mat(data.IR(chIdx,1).');
%% A to B format
if "maci64" == computer('arch')
    pluginpath = [IRISPath,'/Sennheiser AMBEO A-B format converter_mac.vst3'];
else 
    pluginpath = [IRISPath,'/Sennheiser AMBEO A-B format converter.vst3'];
end

% audioTestBench(pluginpath);
hostedPlugin = loadAudioPlugin(pluginpath);
pluginInfo = info(hostedPlugin);
setParameter(hostedPlugin,'Output Format',0);% Fuma
setSampleRate(hostedPlugin,conf.fs);
setMaxSamplesPerFrame(hostedPlugin, size(IRAFormat,1));

disp('A2B...');
IR = process(hostedPlugin,IRAFormat);
%%
conf.axis = axis;
sndHedgehog = IRIS_BFormat(IR,conf);
end