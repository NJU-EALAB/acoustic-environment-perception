%% RAVEN simulation: Example for HOA simulation of a shoebox (only encoded RIRs)
% Author: las@akustik.rwth-aachen.de
% date:     2019/06/26
%
% <ITA-Toolbox>
% This file is part of the application Raven for the ITA-Toolbox. All rights reserved.
% You can find the license for this m-file in the application folder.
% </ITA-Toolbox>

%% project settings
ravenBasePath = 'C:\ITASoftware\Raven\';
myLength=9;
myWidth=7;
myHeight=3;
projectName = [ 'myHOA_ShoeboxRoom' num2str(myLength) 'x' num2str(myWidth) 'x' num2str(myHeight) ];

%% create project and set input data
rpf = itaRavenProject([ ravenBasePath 'RavenInput\Classroom\Classroom.rpf' ]);   % modify path if not installed in default directory
rpf.copyProjectToNewRPFFile([ ravenBasePath 'RavenInput\' projectName '.rpf' ]);
rpf.setProjectName(projectName);
rpf.setModelToShoebox(myLength,myWidth,myHeight);

rpf.setNumParticles(60000); % 60,000 particles for ray tracing simulation
rpf.setFilterLength(2000);  % FilterLength (in ms)
rpf.setISOrder_PS(2);       % set Image source order
 
%% HOA configuration 
rpf.setGenerateBRIR(0);     % deactivate binaural filters 
rpf.setGenerateRIR(1);      % deactivate mono filters
rpf.setGenerateISHOA(1);    % activate HOA for image sources
rpf.setGenerateRTHOA(1);    % activate HOA for ray tracing 
rpf.setAmbisonicsOrder(1);  % set HOA Order

% NOTE: pos is [x z,-y]?
% rpf.setSourcePositions([9 1.7 -2.5]);% [9 1.7000 -2.5000]
% rpf.setReceiverPositions([4.4500 1 -3.9000]);% [4.4500 1 -3.9000]
%% adjust wall materials of room
for iMat=1:6
    myAbsorp = 0.991 * ones(1,31);    % 10% absorption for all walls
    myScatter = 0.003 * ones(1,31);   % 30% scattering for all walls
    rpf.setMaterial(rpf.getRoomMaterialNames{iMat},myAbsorp,myScatter);
end

%% start simulation
rpf.run;

%% get results
mono_ir_ita = rpf.getMonauralImpulseResponseItaAudio();

% RAVEN HOA results use the ACN notation: https://en.wikipedia.org/wiki/Ambisonic_data_exchange_formats#ACN
% Full normalization is applied (N3D as used in Fourier Acoustics)
RIRs = rpf.getAmbisonicsImpulseResponseItaAudio; % as ITA audio object
RIRs_raw = rpf.getAmbisonicsImpulseResponse;     % as matrix

%% check results
ita_plot_time(mono_ir_ita);
ita_plot_time(RIRs);

%% and now?
%  results need to be convolved with an anechoic signal (ita_convolve) 
%  and then decoded using a HOA decoder, e.g., using
%  ita_hoa_decode(Bformat, LoudspeakerPos, varargin) for B-Format signals
rpf.plotModel;
%% init IRIS
%%% setting
conf.OffsetdB = 40;
conf.SegmentTime = 0.002;
%%% advanced setting
confIRIS = readstruct('measurement.xml');
conf.ArrivalTimeColour = confIRIS.Project.ResultsViewData.IrisPlotViewData.ArrivalTimeColoursList.ArrivalTimeColours(1).ArrivalTimeColourList.ArrivalTimeColourItem; 
conf.directSoundThresholdDB = 30;
conf.tMax = 1.5;% [s]
conf.LPfilterFc = 5000; %[Hz]
% conf.fs = fs;
conf.axis = eye(3);
%%
sndHedgehog = IRIS_ita(RIRs,conf);