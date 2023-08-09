%% init
Ac = getAcPara(25);
c = Ac.c;

elementSpace = 0.275;
arrayPos = [-5.33 0.12 1.88;0.18 0.16 1.12+elementSpace/2;0 -1.97+0.12 2.23;5.15 0.12 1.94].';
arrayAxis = [1 0 0;0 0 -1;1 0 0;1 0 0].';
micPos = reshape([arrayPos-0.5*elementSpace*arrayAxis;arrayPos+0.5*elementSpace*arrayAxis],3,[]);

srcIdx = 5;
% srcPosReals = [2.03,4.58,2.12;0 4.63 2.12;-1.45 3.93 2.12].';
% srcPosReal = srcPosReals(:,srcIdx);
load(['./data/IR_srcPos',num2str(srcIdx),'.mat']);
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR.');
%%%
srcPos0 = [0 2 2].';
srcPosReal = getSrcPos(micPos, IR, fs, c, srcPos0);
%%%

figure;
scatter3(micPos(1,:),micPos(2,:),micPos(3,:),'DisplayName','microphone','LineWidth',2);
hold on;xlabel('x');ylabel('y');zlabel('z');legend;axis equal;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'DisplayName','real source','LineWidth',2);
% scatter3(srcPosMeas(1,:),srcPosMeas(2,:),srcPosMeas(3,:),'DisplayName','measurement source','LineWidth',2);

%% get directIR
figure;
plot(IR(:,1));
switch srcIdx
    case 1
        directIR = IR(4219:4254,1);
    case 2
        directIR = IR(3998:4079,1);
    case 3
        directIR = IR(3763:3869,1);
    case 4
        directIR = IR(7511:7597,1);
    case 5
        directIR = IR(7261:7355,1);
end
% directIR = IR(:,1);
figure;
plot(directIR);

%% get source position
numPeak = 40;
precision = 0.1;
num = 1000;
% refSrcPos = refSrcPos*ones(1,num);
% refSrcPos(1,:) = linspace(-5,15,num)';
% refSrcPos(2,:) = linspace(0,20,num)';
% refSrcPos(3,:) = linspace(-2,4,num)';
x = linspace(-10,10,num);
y = linspace(0,10,num/2);
refSrcPos = getMesh(x,y,srcPosReal(3));
[lags, pks] = getLags(IR, directIR, numPeak, precision);
err = getTOAErr(lags, pks, micPos, srcPosReal, refSrcPos, c, fs);
err = reshape(err,num/2,num);

% semilogy(refSrcPos(1,:),err)
[X,Y] = meshgrid(x,y);
err_db = mag2db(err);
[xPeak, yPeak, zPeak] = findpeaks2D(x,y,-err_db,2,0.5);
zPeak = -zPeak;
%% get refBound
refPoint = [mean(xPeak);mean(yPeak)];
refNorm = [diff(xPeak);diff(yPeak)];
refNorm = refNorm./norm(refNorm);
refBound = null(refNorm.');
%% plot
figure;
surf(X,Y,err_db)
caxis([-60 0]);
% zlim([0 1e2])
shading interp
xlabel('x');
ylabel('y');
view([0 90]);
hold on
bound = [-5 5.67 0;5.97 5.67 0].';
boundMeas = refPoint+4*refBound*[1 0 -1];
plot3(bound(1,:),bound(2,:),10+0*bound(3,:),'k','LineWidth',2);
plot3(boundMeas(1,:),boundMeas(2,:),10+0*boundMeas(1,:),'r','LineWidth',2);
plot3(xPeak,yPeak,10+0*zPeak,'ko','LineWidth',2);
hold off
