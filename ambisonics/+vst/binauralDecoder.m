function hostedPlugin = binauralDecoder(fs,frameSize)
mfPath = fileparts(mfilename('fullpath'));
if isempty(mfPath)
    mfPath = '.';
end
pluginpath = [mfPath,'\BinauralDecoder.dll'];

% audioTestBench(pluginpath);
hostedPlugin = loadAudioPlugin(pluginpath);
% pluginInfo = info(hostedPlugin);

%%
% dispParameter(hostedPlugin);
% tuner = parameterTuner(hostedPlugin);
% drawnow

maxOrder = 7;% max order == 7
setParameter(hostedPlugin,1,(maxOrder+1)/8);
getParameter(hostedPlugin,1);

setParameter(hostedPlugin,2,0);% N3D

dt990 = 1;
if dt990
    setParameter(hostedPlugin,3,0.652344);
end


setSampleRate(hostedPlugin,fs);
setMaxSamplesPerFrame(hostedPlugin, frameSize);

end