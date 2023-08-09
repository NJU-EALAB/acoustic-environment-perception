function results_srcLoc(IRPath,chIdx,srcPosReal)
%% init
% clear all
Ac = getAcPara(25);
c = Ac.c;

srcPos0 = [0 2 2].';

mergeData(IRPath,chIdx);
load([IRPath(1:end-4),'_merge.mat']);

% elementSpace = 0.275;
% arrayPos = [-5.33 0.12 1.88;0.18 0.16 1.12+elementSpace/2;0 -1.97+0.12 2.23;5.15 0.12 1.94].';
% arrayAxis = [1 0 0;0 0 -1;1 0 0;1 0 0].';
% micPos = reshape([arrayPos-0.5*elementSpace*arrayAxis;arrayPos+0.5*elementSpace*arrayAxis],3,[]);
% % srcPosReal = [-3.57,3.21,2.45+0.51].';
% srcPosReals = [2.03,4.58,2.12;0 4.63 2.12;-1.45 3.93 2.12].';
% srcIdx = 1;
% srcPosReal = srcPosReals(:,srcIdx);
% load(['./data/IR_srcPos',num2str(srcIdx),'.mat']);
micPos = Data{1}.micPos;
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR.');
%% calculate
srcPosMeas = getSrcPos(micPos, IR, fs, c, srcPos0);
jsonData.ls_position = srcPosMeas;
jsonTxt = jsonencode(jsonData);
filename = 'ls_position.json';
fileID = fopen(filename,'w');
fprintf(fileID,jsonTxt);

figure;
scatter3(micPos(1,:),micPos(2,:),micPos(3,:),'DisplayName','microphone','LineWidth',2);
hold on;xlabel('x');ylabel('y');zlabel('z');legend;axis equal;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'DisplayName','real source','LineWidth',2);
scatter3(srcPosMeas(1,:),srcPosMeas(2,:),srcPosMeas(3,:),'DisplayName','measurement source','LineWidth',2);
title(['error: ',num2str(norm(srcPosReal-srcPosMeas))]);
disp([srcPosReal,srcPosMeas].');
disp(norm(srcPosReal-srcPosMeas));
end