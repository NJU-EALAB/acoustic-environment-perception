clear all;
% close all;
%% setup
setup = 1;
switch setup
    case 1
        dataName = 'srcLocSetup1_1.mat';
        load(['data/',dataName],'Data');
        IRCell = Data{1}.IR;
        fs = Data{1}.fs;
        micPos = [1 1;1.195 1;1.395 1;1.6 1;-1 1;-1 0].';
        srcPosReal = [0 4].';
    case 2
        dataName = 'srcLocSetup2_1.mat';
        load(['data/',dataName],'Data');
        IRCell = Data{1}.IR;
        fs = Data{1}.fs;
        micPos = [1 1;1 1.195;1 1.395;1 1.6;-1 1;-1 0].';
        srcPosReal = [0 4].';
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
srcPos = getSrcPos(micPos, IR, fs, c);
%% results
disp(norm(srcPos-srcPosReal));
figure;
scatter(micPos(1,:),micPos(2,:),'DisplayName','microphone','LineWidth',2);
hold on;
scatter(srcPosReal(1,:),srcPosReal(2,:),'DisplayName','real source','LineWidth',2);
scatter(srcPos(1,:),srcPos(2,:),'DisplayName','source','LineWidth',2);
axis([-2 2 -2 5]);
grid minor
legend