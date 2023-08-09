cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));

%% 测量1
% load('./data/20220507gl120/IR_srcPos1.mat');
IRPath = './IR_Measurement/IR_srcPos1.mat';
%% 混响声衰减特性感知
results_revAttChar2(IRPath);
%% 观演空间早期反射声时间序列获取
results_refSeq(IRPath);
%% 反射声测量（IRIS图）
load(IRPath);
data = Data{4};
micAxisX = 0.5*(data.micPos(:,2)-data.micPos(:,4));
micAxisX(3) = 0;
micAxisZ = [0 0 1].';
micAxisY = -cross(micAxisX,micAxisZ);
axis = [micAxisX,micAxisY,micAxisZ];
axis = axis./vecnorm(axis);
% IRIS(data,5:8);
sndHedgehog = IRIS(data,5:8,axis);

micPos = 1/3*(data.micPos(:,1)+data.micPos(:,2)+data.micPos(:,4));
srcPos = [2.71 -0.37 1.7].'-micPos;
[az,el] = cart2sph(srcPos(1),srcPos(2),srcPos(3));
[x1(1),x1(2),x1(3)] = sph2cart(az,el,1);
[x2(1),x2(2),x2(3)] = sph2cart(sndHedgehog(1,1),sndHedgehog(1,2),1);
ang = acos(x1*x2');
disp([sndHedgehog(1,[1 2]),az,el,ang]./pi.*180);
