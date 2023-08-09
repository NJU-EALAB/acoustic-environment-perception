function [ phase , f_lin ] = ir2phase( IR, fs, nfft)
%Compute Phase Freq Response in dB @linear freq index  

% Change Log:
% 2020-03-02    First Ed. by Liu Ziyun

rtf = fft(IR, nfft);
phase = angle(rtf(1:end/2+1,1));

f_lin = linspace(0, fs/2, nfft/2+1); 

end
