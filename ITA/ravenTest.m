% open D:\Files\GitHub\toolbox-master\applications\SoundFieldSimulation\Raven\ita_raven_tutorial_english.m
clc
close all
clear all
%%
ravenpath = 'C:\ITASoftware\Raven';
rpf = itaRavenProject([ravenpath '\Raveninput\Classroom\Classroom.rpf']);
rpf.plotModel;
%%
% rpf.setISOrder_PS(1);
% rpf.setGenerateISHOA(1);
%% 
rpf.setGenerateRIR(1);
% Generates a monaural room impulse response as output.
% NOTE: e.g. rpf.setGenerateRIR(1);
rpf.setGenerateBRIR(0);
% Generates a binaural room impulse response as output.
rpf.setGenerateISHOA(0);
% Generates a HOA (High Order Ambisonics) image source impulse response as output.
rpf.setGenerateRTHOA(0);
% Generates a HOA (High Order Ambisonics) Ray Tracing impulse response as output.
rpf.setGenerateISVBAP(0);
% Generates a VBAP (Vector Base Amplitude Panning) image source impulse response as output.
rpf.setGenerateRTVBAP(0);
% Generates a VBAP (Vector Base Amplitude Panning) Ray Tracing impulse response as output.
rpf.setExportFilter(1);
% Activates the filter. You have to use this function if you would like to calculate impulse responses.
% Example: rpf.setExportFilter(1);
rpf.setExportHistogram(0);
% Activates the histogram. You have to use this function if you would like to calculate room
% parameters like reverberatiotn time, definition, clarity etc.
%%
rpf.run;
%% output
mono_ir_ita = rpf.getMonauralImpulseResponseItaAudio();
% Returns a monaural room impulse response (one channel).
binaural_ir_ita = rpf.getBinauralImpulseResponseItaAudio();
% Returns a binaural room impulse response (two channels).
ambisonics_ir_ita = rpf.getAmbisonicsImpulseResponseItaAudio();
% Returns an ambisonics impulse response (multiple channels).
Vbap_ir_ita = rpf.getVBAPImpulseResponseItaAudio();
% Returns a VBAP impulse response (multiple channels)

