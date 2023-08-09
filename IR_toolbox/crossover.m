function [sos_l, sos_h] = crossover(n, Wn)
% CROSSOVER calculates the IIR filter coefficients for a Linkwitz-Riley 
% crossover.
%
% <Inputs>
% 	n          Crossover order. Only support 2, 4, and 8.
% 	Wn         Normalized cutoff frequency. 1 means half of sample rate.
%
% <Outputs>
% 	sos_l  Low-pass filter SOS obj.
% 	sos_h  High-pass filter SOS obj.

if nargin < 3
	sav = 0;
end

% Butterworth filter design
[b1, a1] = butter(n/2, Wn, 'low');
[b2, a2] = butter(n/2, Wn, 'high');

% Cascade two sections
b1 = conv(b1, b1);
a1 = conv(a1, a1);
b2 = conv(b2, b2);
a2 = conv(a2, a2);

[sos_l,~] = tf2sos(b1,a1);
[sos_h,~] = tf2sos(b2,a2);

end

