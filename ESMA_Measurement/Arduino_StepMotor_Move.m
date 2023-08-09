function [ ] = Arduino_StepMotor_Move( Com_part, direc, theta, selflock )
% content: Step motor rotation is controlled by matlab
% Liao Wenjun
% 2023-0316 X1专用

% Make sure you have run the code "install_arduino.m" in folder "ArduinoIO"

% Create a global variable only once, because it takes a long time to create "Arduino2StepMotor"
global Arduino2StepMotor
if isempty(Arduino2StepMotor)
    global Arduino2StepMotor
    Arduino2StepMotor = arduino(Com_part);
end

Arduino2StepMotor.pinMode( 8, 'output' );               % control self-lock
Arduino2StepMotor.pinMode( 12, 'output' );               % contral direction of rotation
Arduino2StepMotor.pinMode( 13, 'output' );               % contral step move

Arduino2StepMotor.digitalWrite( 8, 1-selflock );
Arduino2StepMotor.digitalWrite( 12, 1-direc );

Pulse = 1000;                                           % gear of the drive ( comparison Pulse/rev table in the driver )
Calibration = 5.1818;                                   % coefficient between the driver and the step motor
num = round(theta/(360/(Pulse*Calibration)));           % the number of step move

% run
for k = 1 : 1 : num
    Arduino2StepMotor.digitalWrite(13, 1);
    pause(1e-3);
    Arduino2StepMotor.digitalWrite(13, 0);
    pause(1e-3);
end

end

