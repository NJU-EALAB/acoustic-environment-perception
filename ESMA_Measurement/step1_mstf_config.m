%% Measuring a transfer function with the ITA Toolbox
%
% clear
%% Set Hardware
% Set your recording hardware in 'IO Settings'-tab ('recording' and
% 'playback device'). 
ita_preferences;

% For a calibrated measurement it is also
% recommended to check 'Measurement Chain' on the % same 'IO Settings'
% tab.

ccx;

%% Measurement Setup
% Create an instance of  the transfer function measurement class.
MS = itaMSTF;

% Specify an excitation signal. Possible choices are:
% 'exp' : exponential sweep
% 'lin' : linear sweep
% 'noise': white noise
% itaAudio() : any itaAudio variable can be saved here
MS.type = 'exp';

% The output measurement chain consists of 3 elements (D/A converter, 
% amp and actuator for the output). If your measurement involves 
% calibrating a loudspeaker you should be an expert user, since this is
% not a trivial question. As a beginner you can leave your output
% measurement chain uncalibrated.
MS.inputChannels = [ 1:17 ]; % for multiple channels (e.g. 1, 2 & 3): [1 2 3] 

MS.outputChannels = [ 1 ] ;   % for multiple channels sound tegethor

OutChannelMap = [ 1 ];       % for multiple channels sound one by one
TwChannelMap = [];              % for tweeter channels change freq range
numSpk = length(OutChannelMap);

MS.fftDegree = 16;
MS.samplingRate = 48000;
% MS.trackLength = 5;

% Since our system will usually have a response decay time (in room
% acoustics: reverberation time), we need to make sure the last bit of
% measurable energy can arrive at our input. Therefor we define a 
% waiting time at the end of the measurement during which the system 
% will record that last bit. This value should at least be equal to the
% decay time for the last sent out part of the signal (e.g. the 
% reverberation time for the highest frequency of the excitation sweep).
MS.stopMargin = 0.5;


% We need to specify the output volume of our system. This can either be
% done by adjusting the output settings of your amp (by turing a knob,
% flipping a switch, etc.) or by digitally manipulating the amplitude of
% the excitation signal. The unit of the specified value is dBFS (dB 
% Full Scale), the dB distance to the maximum digital signal amplitude 
%of the measurement system.
MS.outputamplification = -36;
MS.freqRange = [20 24000];
twfreqRange = [500 24000];

MS.averages = 3;


% Have a look.
MS
%%
% Arduino_StepMotor_Move( 'COM5', 0, 0, 0 );
% Arduino_StepMotor_Move( 'COM5', 0, 360, 1 );

%% Calibration
% The calibration process basically stays the same, just with more
% possible elements to calibrate. The input is calibrated first. The 
% electrical parts of the output chain (D/A and amp) need to be rewired 
% to the input for calibration. make sure to select the right input
% element in the output calibration GUI (e.g. preamp). At the same time
% the calibration process measures the delay caused by the D/A and A/D% 
% processes and stores it in numbers of latency samples.

% MS.calibrate;
% Have a look
% MS.latencysamples


%% Measurement
% After the execution of the measurement the raw recording will be 
% deconvoluted using the excitation signal. The result is an impulse
% response (time domain) or transfer function (frequency domain).

% result = MS.run;
% SPL = ita_sound_level_meter(MS);

% Have a look at the result in the time domain (.plot_time or pt)

% result.pt
% result.ptd
% result.pf
%% save
% MS.outputamplification = -26-44+12;
% result = MS.run
% result.pt
% %
% filename = string(datetime,'yyyyMMdd_HH_mm_ss');
% save(filename,'MS','result');
