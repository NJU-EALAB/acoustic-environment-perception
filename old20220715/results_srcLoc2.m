function results_srcLoc2(IRPath,chIdx,srcPosReal)
%% init
% clear all

%% calculate
[srcPosMeas,micPos] = getSrcPos2(IRPath,chIdx);
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
