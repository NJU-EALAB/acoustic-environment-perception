function results_revAttChar2(IRPath)
% Reverberation attenuation characteristics
% clear all
% close all
load(IRPath);
fs = Data{1}.fs;
IR = cell2mat(Data{1, 1}.IR(1).');
IR = IR(:)./max(IR);
%% get rev att
revAtt = flip(cumsum(flip(IR.^2,1),1),1);

% figure;
% plot(revAtt);
%% post process
t = (0:length(revAtt)-1)./fs;
revAtt_db = 0.5*mag2db(revAtt./revAtt(1));
figure;
plot(t,revAtt_db);
xlabel('t(s)');
ylabel('L(t)');
title('混响声衰减特性曲线');
end