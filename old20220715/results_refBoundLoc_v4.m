tStart = tic;
%% init
Ac = getAcPara(25);
c = Ac.c;

conf.windowLength = 1;% [ms] 时间窗长度
conf.threshold = -40;% [dB] 大于阈值视为直达声起始部分

% elementSpace = 0.275;
% arrayPos = [-5.33 0.12 1.88;0.18 0.16 1.12+elementSpace/2;0 -1.97+0.12 2.23;5.15 0.12 1.94].';
% arrayAxis = [1 0 0;0 0 -1;1 0 0;1 0 0].';
% micPos = reshape([arrayPos-0.5*elementSpace*arrayAxis;arrayPos+0.5*elementSpace*arrayAxis],3,[]);

% get filenames of IR data
% for ii = 1:5
%     filenames{ii} = ['./data/IR_srcPos',num2str(ii),'.mat'];%#ok
% end
% get directIR
load(filenames{1});
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR.');

conf.fs = fs;
[~, directIR] = getDirectIR(IR(:,1),conf);
figure;
plot(directIR./max(directIR));
title('直达声IR');

% gen wall parameters
numR = 201;
numAz = 360;
r = linspace(0.001,5,numR);
az = linspace(0,2*pi,numAz+1);% azimuth 
az = az(1:end-1);
el = 0;% elevation 

sph = getMesh(az,el,r);
[x,y,z] = sph2cart(sph(1,:),sph(2,:),sph(3,:));
wall.x = [x;y;z];
wall.n = wall.x./vecnorm(wall.x);


%% 
srcPos0 = [0 2 2].';
srcPosReal = zeros(3,length(filenames));
err = 0;
for ii = 1:length(filenames)
    srcPosReal(:,ii) = getSrcPos2(filenames{ii},chIdx);
    mirrorSrcPos = getMirrorSrcPos(srcPosReal(:,ii),wall);
    load(filenames{ii});
    for jj = 1:numel(Data)
        micPos = Data{jj}.micPos(:,chIdx);
        IR = cell2mat(Data{jj}.IR(chIdx,:).');
        err = err+getOneSrcErr(micPos,IR,directIR,c,fs,srcPosReal(:,ii),mirrorSrcPos);
    end
end
err = reshape(err,numAz,numR);
err_db = mag2db(err);

%% result
[minErr, azIdx] = min(err,[],1);
[minErr, rIdx] = min(minErr,[],2);
azIdx = azIdx(rIdx);
[~,errIdx] = min(err(:));
nRes = wall.n(:,errIdx);
xRes = wall.x(:,errIdx);

toc(tStart);
%% plot
figure;
[X,Y] = meshgrid(r,az./pi.*180);
surf(X,Y,err_db)
caxis([-60 10]);
% zlim([0 1e2])
shading interp
xlabel('r');
ylabel('az(deg)');
view([0 90]);
hold on;
scatter3(r(rIdx),az(azIdx)./pi.*180,10+err(azIdx,rIdx),'k','LineWidth',2);
hold off;

figure;
scatter3(micPos(1,:),micPos(2,:),micPos(3,:),'DisplayName','last microphone','LineWidth',2);
hold on;xlabel('x');ylabel('y');zlabel('z');legend;axis equal;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'DisplayName','measurement source','LineWidth',2);
bound = [-3 5.67 0;3 5.67 0].';
bound = [-0.6 5 0;-0.6 -1.17 0;3 -1.17 0].';
nRes = nRes./norm(nRes);
refBound = null(nRes(1:2).');
refBound(3) = 0;
boundMeas = xRes+3*refBound*[1 0 -1];
plot3(bound(1,:),bound(2,:),10+0*bound(3,:),'k','LineWidth',2,'DisplayName','real wall');
plot3(boundMeas(1,:),boundMeas(2,:),10+0*boundMeas(1,:),'r','LineWidth',2,'DisplayName','measured wall');
hold off;
view([0 90]);

%%
%%
function err = getOneSrcErr(micPos,IR,directIR,c,fs,srcPosReal,refSrcPos)
numPeak = 3;
precision = 0.1;

[lags, pks] = getLags(IR, directIR, numPeak, precision);
err = getTOAErr(lags, pks, micPos, srcPosReal, refSrcPos, c, fs);
end
