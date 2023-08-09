function [mag_dB_avg, f_lin] = LIR_rms_Avg(LIR, oct_sm, fs, nfft)
%LIR_dB_Avg Average of all response in listening area in dB scale

if nargin < 4
    nfft = size(LIR,1);
end

if nargin < 3
    fs = 48e3;
end

if nargin < 2
    oct_sm = 3;
end

for i=1:size(LIR,2)
    [ mag_lin(:,i), f_lin ] = ir2mag_lin(LIR(:,i), fs, nfft);
%     mag_dB_sm(:,i) = smoothSpectrum(mag_dB(:,i),f_lin',oct_sm);
%     mag_dB_sm(:,i) = mag_dB_sm(:,i)+mic_sen_mkp;
end

mag_avg = rms(mag_lin, 2);
mag_dB_avg = mag2db(mag_avg);
mag_dB_avg = smoothSpectrum(mag_dB_avg,f_lin',oct_sm);

% figure;
% semilogx(f_lin,[db(mag_lin)]);xlim([40 400]);ylim([-80 -45]);


end

