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
IR = IR(:,1:4);
numIR = 10;
precision = 0.1;
lags = getLags(IR, IR(1:8400,1), numIR, precision);warning('direct sound 1:8400');

d = 0.2; % distance between microphones
precision = 0.1;
[aoa, score, relDistance] = lags2DOA(lags,d,c,fs,precision);

distance = relDistance+norm([-0.3;0;1.2]-[1.94 4.52 1.2].');%direct sound 1:8400. relDistance-0
n_src = 7;
x = -0.3+distance(1:n_src).*cosd(90+aoa(1:n_src));
y = 0+distance(1:n_src).*sind(90+aoa(1:n_src));

%% results
% disp(norm(srcPos-srcPosReal));
figure;
scatter(micPos(1,:),micPos(2,:),'DisplayName','microphone','LineWidth',2);
hold on;
scatter(srcPosReal(1,:),srcPosReal(2,:),'DisplayName','real source','LineWidth',2);
scatter(x,y,'DisplayName','source','LineWidth',2);
axis equal
grid minor
legend




