clear all
close all
%% new docx
import mlreportgen.report.*
import mlreportgen.dom.*
rpt = Report('反射声方位','docx');
rpt.Locale = 'zh';
%% Direction estimation of direct sound and reflected sound
load('data_powermap.mat');
% wallPos(2,end) = -4
azimuth0 = azimuth(1:end-1);
for srcIdx = 1:numel(srpCum_dB)
    srpCum_dB{srcIdx} = [srpCum_dB{srcIdx}(:,azimuth0>=-pi),srpCum_dB{srcIdx}(:,azimuth0<-pi)];
end
azimuth0 = [azimuth0(azimuth0>=-pi),2*pi+azimuth0(azimuth0<-pi)];

refThreshold = -6;
ii = 0;
ang = [];
for srcIdx = 1:size(srcPosReal,2)
    ii = ii+1;
    %% plot
    [az,el] = getSoundAzel(wallPos, srcPosReal(:,srcIdx), ESMAPos);
%     [az,el] = getSoundAzel_order2(wallPos, srcPosReal(:,srcSelectIdx(srcIdx)), ESMAPos);

    assert(numel(srcIdx)==1);
    [azPeak, elPeak, powerPeak] = findpeaks2D(azimuth0,elevation,srpCum_dB{srcIdx},inf,0,2);
    [x1,y1,z1] = sph2cart(azPeak,elPeak,1);
    [azPeak, elPeak] = cart2sph(x1,y1,z1);
    [x2,y2,z2] = sph2cart(azelAll_rad(srcIdx,1),azelAll_rad(srcIdx,2),1);
    [~,dirSndIdx] = max([x1,y1,z1]*[x2,y2,z2].');

    dirPowerPeak = powerPeak(dirSndIdx);
    azPeak = azPeak(powerPeak>=dirPowerPeak+refThreshold);
    elPeak = elPeak(powerPeak>=dirPowerPeak+refThreshold);
    powerPeak = powerPeak(powerPeak>=dirPowerPeak+refThreshold);

    fh = figure;
    srpSurf = surf(azimuth0./pi.*180,elevation./pi.*180,srpCum_dB{srcIdx});
    shading interp
    %     axis equal
    axis tight
    view(2)
    hold on;
    scatter3(az(1,1)./pi.*180,el(1,1)./pi.*180,0*el(1,1)+max(srpCum_dB{srcIdx},[],'all'),'filled','k','LineWidth',2);
    scatter3(az(2:end,1)./pi.*180,el(2:end,1)./pi.*180,0*el(2:end,1)+max(srpCum_dB{srcIdx},[],'all'),'k','LineWidth',2);
    scatter3(azPeak(dirSndIdx)./pi.*180,elPeak(dirSndIdx)./pi.*180,0*elPeak(dirSndIdx)+1+max(srpCum_dB{srcIdx},[],'all'),'r*','LineWidth',0.8);
    scatter3(azPeak([1:dirSndIdx-1,dirSndIdx+1:end])./pi.*180,elPeak([1:dirSndIdx-1,dirSndIdx+1:end])./pi.*180,0*elPeak([1:dirSndIdx-1,dirSndIdx+1:end])+1+max(srpCum_dB{srcIdx},[],'all'),'r+','LineWidth',2);
%     title(num2str(srcIdx));
    xlabel('方位角');
    ylabel('俯仰角');
    legend21b('','直达声实际方位','反射声实际方位','直达声感知方位','反射声感知方位');
    hold off;
    %% results
    if numel(azPeak) == 1
        txt_res = '没有识别到强反射声。';
    else
        if dirSndIdx >= 2
            maxRefIdx = 1;
        else
            maxRefIdx = 2;
        end
        [x1,y1,z1] = sph2cart(az(2:end),el(2:end),1);
        [x2,y2,z2] = sph2cart(azPeak(maxRefIdx),elPeak(maxRefIdx),1);
        [angCos, wallIdx] = max([x1,y1,z1]*[x2,y2,z2].');
        ang(ii) = acosd(angCos);
        txt_wall = repmat({'其他反射面'},100,1);
%         txt_wall(1:6) = {'地面','屋顶','前墙','后墙','左墙','右墙'};
        txt_wall(1:6) = {'反射面1','反射面2','反射面3','反射面4','反射面5','反射面6'};
        txt_res = ['识别到',num2str(numel(azPeak)-1),'个强反射声，其中最强的反射声的方位角和俯仰角为' ...
            '(',num2str(azPeak(maxRefIdx)./pi.*180),'°,',num2str(elPeak(maxRefIdx)./pi.*180),'°)，' ...
            '可能是由',txt_wall{wallIdx},'引起的反射声（理论俯仰角为' ...
            '(',num2str(az(wallIdx+1)./pi.*180),'°,',num2str(el(wallIdx+1)./pi.*180),'°)，' ...
            '角度误差为',num2str(ang(ii)),'°）。'];
    end

    %% write
    if 1
        % text
        txt = ['扬声器',num2str(ii),'的入射声场声能分布图如下图所示。',txt_res];
        para = Paragraph(txt);
        append(rpt,para)

        % figure
        fig = Figure(fh);
        % fig.Snapshot.Height = '4in';
        % fig.Snapshot.Width = '6in';
        fig.Snapshot.Caption = (['扬声器',num2str(ii),'入射声场声能分布图']);
        
        append(rpt,fig);
        append(rpt,Paragraph(''));

        close gcf
        % table
        %     square = magic(10);
        %     tbl = Table(square);
        %     tbl.Style = {...
        %         RowSep('solid','black','1px'),...
        %         ColSep('solid','black','1px'),};
        %     tbl.Border = 'double';
        %     tbl.TableEntriesStyle = {HAlign('center')};
        %     append(rpt,tbl);
    end
end
%% summary

[errMax,errIdx] = max(ang);
append(rpt,Paragraph(['综上，扬声器',num2str(errIdx),'的反射声方向估计误差最大，为',num2str(errMax),'°。']))
close(rpt);
