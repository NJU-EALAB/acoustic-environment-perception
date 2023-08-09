function sndIntSeries = getSndIntSeries(IR,conf)
% sndIntSeries;% (sndIntNum,3) [Ix;Iy;Iz]
%%
assert(size(IR,2)==4);% WXYZ

%% get direction of sound intensity
% get particle velocity form XYZ
N1 = 120;
Hd = getHFilter(N1);
N2 = 240;
b1 = getIntFilter(N2,conf.fs);
IRv = filter(Hd,1,[IR(:,2:4);zeros(N1/2,3)]);
IRv = filter(b1,1,[IRv;zeros(N2/2,3)]);
IR = [[zeros((N1+N2)/2,1);IR(:,1)], IRv];
% low pass filter for IR
N3 = 120;
Fs = conf.fs;
Fp = conf.LPfilterFc;
Ap = 0.01;
Ast = 60;
FIR = getLPFilter(N3,Fs,Fp,Ap,Ast);
LPIR = filter(FIR,1,[IR;zeros(N3/2,4)]);

% align onset
LPIR = LPIR((N1+N2+N3)/2+1:end,:);
IR = IR((N1+N2)/2+1:end,:);

IDir = LPIR(:,1).*LPIR(:,2:4);
IDir = IDir./vecnorm(IDir,2,2);
%% get sound intensity
sndIntSeries = vecnorm(IR(:,1).*IR(:,2:4),2,2).*IDir;
end

%%
%%
function NUM = getLPFilter(N,Fs,Fp,Ap,Ast)
Rp = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
Rst = 10^(-Ast/20);

NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge');
% fvtool(NUM,'Fs',Fs);

end
function Hd = getHFilter(N)

% N;   % Order
TW = 0.01;  % Transition Width

h = fdesign.hilbert('N,TW', N, TW);

Hd = design(h, 'firls');
Hd = Hd.Numerator;
end
function b1 = getIntFilter(N,fs)
% fs = 48000;
% N = 240;
fl = 100;

f = [0 linspace(fl,10000,1000) fs./2].*2./fs;
m = [1 fl./linspace(fl,10000,1000) 0];

b1 = fir2(N,f,m);
% [h1,w] = freqz(b1,1);
% 
% plot(fs/2*f,mag2db(m),fs/2*w/pi,mag2db(abs(h1)))
% xlabel('\omega / \pi')
% lgs = {'Ideal','fir2 default'};
% legend(lgs)
end