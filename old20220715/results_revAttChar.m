% Reverberation attenuation characteristics
clear all
close all
load('./data/IR_2222_20200722.mat');
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR(1).');
IR = IR(:)./max(IR);
%% get direct IR
figure;
plot(IR);
% dirIRStart = input('dirIRStart: ');
% dirIREnd = input('dirIREnd: ');
% dirIR = IR(dirIRStart:dirIREnd);
dirIR = IR(2360:2440);
%% method 1
[r, lags] = xcorr(IR,dirIR);
rang = find(lags>=0,1);
r = r(rang:end);
lags = lags(rang:end);
r = r./max(r);
% r = r-mean(r);

figure;
plot(r);
%%% get rev att
revAtt = flip(cumsum(flip(r,1),1),1);

figure;
plot(revAtt);
%% method 2
numPeak = 400;
r = getRefSeq(IR, dirIR, numPeak);
r = r./max(r);
figure;
plot(r);
%%% get rev att
revAtt = flip(cumsum(flip(r,1),1),1);

figure;
plot(revAtt);
%% post process
t = (0:length(revAtt)-1)./fs;
revAtt_db = mag2db(revAtt./revAtt(1));
figure;
plot(t,revAtt_db);
xlabel('t(s)');