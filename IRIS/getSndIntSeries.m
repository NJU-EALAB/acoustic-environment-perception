function sndIntSeries = getSndIntSeries(IR,conf)
% sndIntSeries;% (sndIntNum,3) [Ix;Iy;Iz]
%%
assert(size(IR,2)==4);% WXYZ
%% get low pass filter for IR
N = 120;
Fs = conf.fs;
Fp = conf.LPfilterFc;
Ap = 0.01;
Ast = 60;
FIR = getLPFilter(N,Fs,Fp,Ap,Ast);
%% get direction of sound intensity
LPIR = filter(FIR,1,[IR;zeros(N/2,4)]);
LPIR = LPIR(N/2+1:end,:);
IDir = LPIR(:,1).*LPIR(:,2:4);
%% get sound intensity
sndIntSeries = vecnorm(IR(:,1).*IR(:,2:4),2,2).*IDir./vecnorm(IDir,2,2);
end

%%
%%
function NUM = getLPFilter(N,Fs,Fp,Ap,Ast)
Rp = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
Rst = 10^(-Ast/20);

NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge');
% fvtool(NUM,'Fs',Fs);

end