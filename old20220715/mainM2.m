cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));
%% 测量2
%% 扬声器空间位置感知
% srcPosReal = [-3.57,3.21,2.45+0.51].';
srcPosReals = [2.71 -0.37 1.7;4.7 0.3 1.25;2.71 -0.37 1.7;3.74 -0.51 1.7;0.43 0.5 1.55;6.64 -0.33 1.7;5.18 -0.08 1.91].';
% 4.7 0.3 1.25
% 2.71 -0.37 1.7
for srcIdx = 1:size(srcPosReals,2)
    srcPosReal = srcPosReals(:,srcIdx);
    IRPath = ['./IR_Measurement/IR_srcPos',num2str(srcIdx),'.mat'];
    results_srcLoc(IRPath,1:4,srcPosReal);% TDOA
    results_srcLoc2(IRPath,1:4,srcPosReal);% TDOA计算DOA，最小化DOA误差
    drawnow;
end
    srcPosReal = srcPosReals(:,6);
    IRPath = ['./IR_Measurement/IR_srcPos6.5.mat'];
    results_srcLoc(IRPath,1:4,srcPosReal);
    results_srcLoc2(IRPath,1:4,srcPosReal);
    drawnow;
    srcPosReal = srcPosReals(:,6);
    IRPath = ['./IR_Measurement/IR_srcPos6_8meas.mat'];
    results_srcLoc(IRPath,1:4,srcPosReal);
    results_srcLoc2(IRPath,1:4,srcPosReal);
    drawnow;
    srcPosReal = srcPosReals(:,7);
    IRPath = ['./IR_Measurement/IR_srcPos7.2.mat'];
    results_srcLoc(IRPath,1:4,srcPosReal);
    results_srcLoc2(IRPath,1:4,srcPosReal);
    drawnow;
    srcPosReal = srcPosReals(:,7);
    IRPath = ['./IR_Measurement/IR_srcPos7_8meas.mat'];
    results_srcLoc(IRPath,1:4,srcPosReal);
    results_srcLoc2(IRPath,1:4,srcPosReal);
    drawnow;
%% 观演空间和舞台空间声学反射边界方位感知
% get filenames of IR data
clear all
for ii = 1:3
    filenames{ii} = ['./IR_Measurement/IR_srcPos',num2str(ii+2),'.mat'];%#ok
end

% 
chIdx = 1:4;
run results_refBoundLoc_v4.m

% wall:
% x=-0.6
% y = -1.17