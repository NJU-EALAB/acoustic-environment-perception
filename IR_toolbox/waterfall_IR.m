function [mag_dB, f_lin, time] = waterfall_IR(IR,oct_sm,step)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fs = 48e3;
nfft = size(IR,1);

for i = 1:floor(size(IR,1)/step)
    IR(1:i*step,:) = 0;
    [ mag_dB(:,i) , f_lin ] = ir2mag_dB( IR, fs, nfft);
    mag_dB_sm(:,i) = smoothSpectrum(mag_dB(:,i),f_lin',oct_sm);
    time(i) = i*step/fs;
end

% Create figure
waterfall(f_lin, time, mag_dB');

% Create axes
axes1 = gca;

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.035 0.085]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[200 7000]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-95 -40]);
% view(axes1,[60 60]);
% grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'YMinorTick','on','XScale','log');

end

