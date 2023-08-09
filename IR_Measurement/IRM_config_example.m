%% IR Measurmnent
% Liu Ziyun
% 2017-08-24

% close all;
% clc;clear;
clear config;
cd(fileparts(mfilename('fullpath')));
addpath(genpath('../array position measurement'));
% addpath('/Users/liuziyun/Documents/GitHub/IR_toolbox');
% addpath('/Users/liuziyun/Documents/GitHub/IR_Measurment');
% addpath('/Users/liuziyun/Documents/GitHub/IR_Measurment_SpiderMic');

%% Config Hardware
samplerate_speed = 1;
config.fs = 48e3 * samplerate_speed;
config.frameSize = 2048;
% config.frameSize = 1024/samplerate_speed;
% conifg.nBits = 24;      

config.inSens = 2.449;           % Input Sensitivty in V @ 0 dBFS
config.outSens = 6.904;          % Output Sensitivty in V @ 0 dBFS

config.micSense = -37.9;		 % 1 Pa = -37.9 dBFS

% config.Vout = 0.01;
config.OutGain = 0.01;            % Initial OutGain Value

% config.Ref_in_chn = 8;
% config.Ref_out_chn = 6;

config.Rec_in_chn = [ 1:8 ];

config.out_chn_select = [ 1 ];


config.RecorderChannelMapping = [ config.Rec_in_chn ];
config.PlayerChannelMapping = [ config.out_chn_select ];

% config.DeviceName = 'Fireface UC Mac (23935003)';
config.DeviceName = 'Focusrite USB ASIO';

% load('CHZ216-08_RME.mat');
% config.Mic_info = Mic_info;
load('CHZ216-02_RME.mat');
% config.Mic_info = [ config.Mic_info;Mic_info ];
config.Mic_info = Mic_info;

%% Config Measurment
config.fl = 4;                  % fl and fh are the lowest and highest 
                                 % frequencies of this measurment respectively.
config.fh = config.fs/2;

config.sweep_length = 8192*samplerate_speed*8;      % as fftsize/2
config.sweep_time = config.sweep_length / config.fs; 
config.fftsize = config.sweep_length*16;

config.N_repeat = 4;             % Repeat for 6 times
config.N_measure = size(config.out_chn_select,2);

%% Parallel Processing Init
config.usingParallel = 0;
if config.usingParallel
    p = gcp(); % get the current parallel pool
end