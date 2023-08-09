% find refBound in xz-plane
%% init
Ac = getAcPara(25);
c = Ac.c;

srcPosReal = [0.97;0.9;1.2].*[0 5 1;4 5 1].';
arrayPos = [0.97;0.9;1.8].*[
    4 0 1
    2 0 1
    0 0 1
    0 2 1
    4 2 1
    ].';
arrayAxis = [repmat([1 0 0],3,1);repmat([0 -1 0],1,1);repmat([0 1 0],1,1)].';
elementNum = 4;
elementSpace = 0.092;
micPos = reshape([
    arrayPos-1.5*elementSpace*arrayAxis
    arrayPos-0.5*elementSpace*arrayAxis
    arrayPos+0.5*elementSpace*arrayAxis
    arrayPos+1.5*elementSpace*arrayAxis
    ],3,[]);
micPos = [micPos, [0,0;0,0;1.06250000000000,1.33750000000000]];% add 2 mic

figure;
scatter3(micPos(1,:),micPos(2,:),micPos(3,:),'DisplayName','microphone','LineWidth',2);
hold on;xlabel('x');ylabel('y');zlabel('z');legend;axis equal;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'DisplayName','real source','LineWidth',2);
% scatter3(srcPosMeas(1,:),srcPosMeas(2,:),srcPosMeas(3,:),'DisplayName','measurement source','LineWidth',2);

%% load
srcIdx = 1;
data = load(['./data/IR_44444_20200722_',num2str(srcIdx),'.mat']);
fs = data.fs;
IR = data.IR;
directIR = data.directIR;
assert(size(IR,2)==elementNum*size(arrayPos,2));
% assert(size(micPos,2)==elementNum*size(arrayPos,2));
assert(numel(directIR)==size(arrayPos,2));
assert(srcIdx == 1);
data2 = load('IR_2222_20200722.mat');% add 2 mic
IR2 = cell2mat(data2.Data{1, 1}.IR.');
IR = [IR, IR2(:,[1 2])];
%% get source position
numPeak = 40;
precision = 0.1;
srcPos = srcPosReal(:,srcIdx);
num = 1000;
% refSrcPos = refSrcPos*ones(1,num);
% refSrcPos(1,:) = linspace(-5,15,num)';
% refSrcPos(2,:) = linspace(0,20,num)';
% refSrcPos(3,:) = linspace(-2,4,num)';
x = linspace(-10,10,num);
y = 4.5;
z = linspace(-5,5,num/2);
refSrcPos = getMesh(x,y,z);
[lags, pks] = getLags(IR, directIR{1}, numPeak, precision);
err = getTOAErr(lags, pks, micPos, srcPos, refSrcPos, c, fs);
err = reshape(err,num,num/2).';% note: is not reshape(err,num/2,num);

% semilogy(refSrcPos(1,:),err)
[X,Y] = meshgrid(x,z);
err_db = mag2db(err);
[xPeak, yPeak, zPeak] = findpeaks2D(x,z,-err_db,2,0.5);
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
ylabel('z');
view([0 90]);
hold on
bound = [-1.12 0 0;-1.12 0 2.5;5.97 0 2.5;5.97 0 0; -1.12 0 0].';
boundMeas = refPoint+4*refBound*[1 0 -1];
plot3(bound(1,:),bound(3,:),10+0*bound(3,:),'k','LineWidth',2);
plot3(boundMeas(1,:),boundMeas(2,:),10+0*boundMeas(1,:),'r','LineWidth',2);
plot3(xPeak,yPeak,10+0*zPeak,'ko','LineWidth',2);
hold off
