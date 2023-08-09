%% Arduino_StepMotor_Move demo
% content: Step motor rotation is controlled by matlab
% Liao Wenjun
% 2022-10-10

% before run, Make sure you have run the code "install_arduino.m" in folder "ArduinoIO"

clear all;
delete(instrfindall);
%%
% Paramete
Com_part = 'COM3';      % View the COM port in Device Manager
direc = 0;              % direction of rotation: 1 means clockwise; 0 means anticlockwise;
Selflock = 1;           % self-lock: 1 means self-lock in the absence of signal; 0 means free rotation in the absence of signal
theta = 90;            % rotation angle (degree)

% Run
Arduino_StepMotor_Move( Com_part, direc, theta, Selflock );


