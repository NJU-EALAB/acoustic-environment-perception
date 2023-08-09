function [ mag_dB , f_lin ] = ir2mag_dB( IR, fs, nfft)
%Compute Mag Freq Response in dB @linear freq index  

% Change Log:
% 2016-12-24    First Ed. by Liu Ziyun

rtf = fft(IR, nfft);
mag = abs(rtf(1:end/2+1,1));
mag_dB = mag2db(mag);

f_lin = linspace(0, fs/2, nfft/2+1); 

end
