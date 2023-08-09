function [echogram, t] = refSeq2(ir,fs)
if 0
load('rir-38.mat');
ir = double(DirData.time(:,17));
fs = DirData.samplingRate;
end
dt = 5e-3;
dn = round(dt*fs);
N = ceil(length(ir)./dn);
ir = reshape([ir;zeros(N*dn-length(ir),1)],dn,[]);
echogram = 10*log10(mean(ir.^2,1)).';
% echogram = echogram-max(echogram);

t = (0:length(echogram)-1).*dn./fs;

figure;
stem(t,echogram)
end