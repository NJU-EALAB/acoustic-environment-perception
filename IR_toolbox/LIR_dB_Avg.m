function [mag_dB_avg, f_lin] = LIR_dB_Avg(LIR, oct_sm, fs, nfft)
%LIR_dB_Avg Average of all response in listening area in dB scale

if nargin < 4
    nfft = size(LIR,1);
end

if nargin < 3
    fs = 48e3;
end

if nargin < 2
    oct_sm = 24;
end

for i=1:size(LIR,2)
    [ mag_dB(:,i), f_lin ] = ir2mag_dB(LIR(:,i), fs, nfft);
%     mag_dB_sm(:,i) = smoothSpectrum(mag_dB(:,i),f_lin',oct_sm);
%     mag_dB_sm(:,i) = mag_dB_sm(:,i)+mic_sen_mkp;
end

mag_dB_avg = mean(mag_dB, 2);
mag_dB_avg = smoothSpectrum(mag_dB_avg,f_lin',oct_sm);

% figure;
% semilogx(f_lin,[mag_dB_avg]);xlim([20 20000]);


end

