function hostedPlugin = powermap(micParams,fs,frameSize)
ERROR: The object does not define any tunable parameters.
mfPath = fileparts(mfilename('fullpath'));
if isempty(mfPath)
    mfPath = '.';
end
pluginpath = [mfPath,'\sparta_powermap.dll'];

% audioTestBench(pluginpath);
hostedPlugin = loadAudioPlugin(pluginpath);
% pluginInfo = info(hostedPlugin);

%%
% dispParameter(hostedPlugin);
% tuner = parameterTuner(hostedPlugin);
% drawnow

order = micParams.maxOrder;% max order == 7
setParameter(hostedPlugin,'order',(order-1)/6);
getParameter(hostedPlugin,'order');

num_sensors = length(micParams.azi);% max num_sensors == 64
setParameter(hostedPlugin,'num_sensors',num_sensors/64);
getParameter(hostedPlugin,'num_sensors');

array_radius = micParams.radius;% max array_radius == 0.4 m
setParameter(hostedPlugin,'array_radius',(array_radius-0.001)/0.399);
getParameter(hostedPlugin,'array_radius');
setParameter(hostedPlugin,'baffle_radius',(array_radius-0.001)/0.399);
getParameter(hostedPlugin,'baffle_radius');

Azim = micParams.azi;
Azim = mod(Azim,2*pi);
Azim(Azim>pi) = Azim(Azim>pi)-2*pi;% [-pi,pi]
Elev = micParams.ele;% [-pi/2,pi/2]
for ii = 1:num_sensors
    setParameter(hostedPlugin,['Azim_',num2str(ii-1)],Azim(ii)./pi./2+0.5);
    setParameter(hostedPlugin,['Elev_',num2str(ii-1)],Elev(ii)./pi+0.5);
end


setSampleRate(hostedPlugin,fs);
setMaxSamplesPerFrame(hostedPlugin, frameSize);

end