clear all
close all
%% new docx
import mlreportgen.report.*
import mlreportgen.dom.*
rpt = Report('声源位置','docx');
rpt.Locale = 'zh';
%%
load('res_srcPos.mat');
% srcIdx = [1:5 8:31];
srcIdx = 1:size(srcPos,2);
srcPos = srcPos(:,srcIdx);
dSrcPos = dSrcPos(:,srcIdx);
dr = dr(:,srcIdx);
dSrcAngle = dSrcAngle(:,srcIdx);
srcPosReal = srcPosReal(:,srcIdx);
fh = figure;
scatter3(srcPos(1,:),srcPos(2,:),srcPos(3,:),'.','LineWidth',2);
hold on
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'.','LineWidth',2);
axis equal;
title('观演空间扬声器空间位置')
lg = legend('估计坐标','真实坐标');
lg.Location = 'northeast';
xlabel('x轴');
ylabel('y轴');
zlabel('z轴');
fig = Figure(fh);
append(rpt,fig);
append(rpt,Paragraph(''));

figure;
scatter(1:numel(dSrcPos),dSrcPos);
title('位置误差');
figure;
scatter(1:numel(dr),dr);
title('距离误差');
figure;
scatter(1:numel(dSrcAngle),dSrcAngle);
title('角度误差');

%table
cellData1 = cellfun(@(x)num2str(x,'(%.2f,%.2f,%.2f)'),mat2cell(srcPos.',ones(size(srcPos,2),1)),'UniformOutput',false);
cellData2 = cellfun(@(x)num2str(x,'(%.2f,%.2f,%.2f)'),mat2cell(srcPosReal.',ones(size(srcPos,2),1)),'UniformOutput',false);
cellData3 = cellfun(@(x)num2str(x,'%.2f'),num2cell([dSrcAngle;100*dr;100*dSrcPos].'),'UniformOutput',false);
cellData = [num2cell((1:numel(dSrcAngle)).'),cellData1,cellData2,cellData3];
tbl = FormalTable({'扬声器编号','感知位置(m)','真实位置(m)','方向感知误差(deg)','距离感知误差(cm)','位置感知误差(cm)'},cellData);
tbl.Style = {...
    RowSep('solid','black','1px'),...
    ColSep('solid','black','1px'),};
    tbl.Border = 'single';
tbl.TableEntriesStyle = {HAlign('center')};
append(rpt,tbl);

%% summary
close(rpt);
