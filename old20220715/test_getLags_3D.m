clear all;
% close all;
%% setup
setup = 3;
switch setup
    case 3
        dataName = 'srcLocSetup3_3.mat';
        load(['data/',dataName],'Data');
        IRCell = Data{1}.IR;
        fs = Data{1}.fs;
        micPos14 = [-0.3;0;1.2]+[0 0 0;0.195 0 0;0.395 0 0;0.6 0 0].';
        micPos56 = [1.94;1.81;1.22]+[0 0 0;0 0.5 0].';
        micPos78 = [-1.03;1.81;1.17]+[0 0 0;0 0 0.5].';
        micPos = [micPos14,micPos56,micPos78];
        srcPosReal = [1.94 4.52 1.2].';
    otherwise
        error('no such setup');
end
assert(length(IRCell) == size(micPos,2));
IR = zeros(length(IRCell{1}),length(IRCell));
for ii = 1:length(IRCell)
    IR(:,ii) = IRCell{ii}(:);
end
Ac = getAcPara(25);
c = Ac.c;
%% calculate
TDOA = getTDOA(IR, fs);
[srcPos0, errSrcPos] = getSrcPos(micPos, IR, fs, c);
TOA = vecnorm(srcPos0-micPos,2,1)./c;% time of arrival
TOAcompensate = mean(TOA-TDOA+TDOA(end));

numIR = 2;
precision = 0.1;
% plot(IR)
% lag = getLag(IR, IR(7100:7600,1), precision);
TOAs = getLags(IR, IR(1:8400,1), numIR, precision)./fs;
TOAs = TOAs-TOAs(1,end)+TOAcompensate;
% srcPos0 = zeros(size(micPos,1),1);
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','iter');
srcPos = [];
errSrcPos = [];
for ii = 1:size(TOAs,1)
    err = @(srcPos)errTOA(srcPos, micPos, TOAs(ii,:), c);
    srcPos(:,ii) = lsqnonlin(err,srcPos0,[],[],options);
    errSrcPos(ii) = 3*c*std(err(srcPos(:,ii)));
end
%% results
% disp(norm(srcPos-srcPosReal));
figure;
scatter(micPos(1,:),micPos(2,:),'DisplayName','microphone','LineWidth',2);
hold on;
scatter(srcPosReal(1,:),srcPosReal(2,:),'DisplayName','real source','LineWidth',2);
scatter(srcPos(1,:),srcPos(2,:),'DisplayName','source','LineWidth',2);
scatter(srcPos0(1,:),srcPos0(2,:),'DisplayName','source0','LineWidth',2);
axis([-2 2 -2 5]);
axis equal
grid minor
legend
plotCircle(c*TOAs(1,:),micPos(1:2,:),'--k',1);
% plotCircle(c*TOAs(2,:),micPos(1:2,:),'k',1);