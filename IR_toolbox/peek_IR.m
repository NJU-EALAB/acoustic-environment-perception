function [  ] = peek_IR( IR , oct_sm, fs, mic_sen_mkp)
% Take a peek of IR and its freq response

if nargin < 4
    mic_sen_mkp = 0;
end

if nargin < 3
    fs = 48e3;
end

if nargin < 2
    oct_sm = 24;
end

if length(IR)>8192
    nfft = size(IR,1);
else
    nfft = 8192;
end

for i=1:size(IR,2)
    [ mag_dB(:,i), f_lin ] = ir2mag_dB(IR(:,i), fs, nfft);
    mag_dB_sm(:,i) = smoothSpectrum(mag_dB(:,i),f_lin',oct_sm);
    mag_dB_sm(:,i) = mag_dB_sm(:,i)+mic_sen_mkp;
end

figure;
subplot(2,1,1);
plot(IR);
subplot(2,1,2);
semilogx(f_lin,mag_dB_sm);xlim([20 20000]);

% figure;
% semilogx(f_lin,max(mag_dB_sm,[],2)-min(mag_dB_sm,[],2));xlim([200 20000]);


end

