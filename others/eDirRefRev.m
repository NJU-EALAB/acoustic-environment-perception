function [eDir, eRef, eRev] = eDirRefRev(ir,fs,t1,t2,t3)
if nargin<5
    t3 = inf;
end
if nargin<4
    t2 = 50/1000;
end
if nargin<3
    t1 = 2/1000;
end
assert(size(ir,2)==1);
irIta = itaAudio();
irIta.timeData = ir;
sampleStart = ita_start_IR(irIta);
n1 = floor(t1*fs);
n2 = floor((t2-t1)*fs);
n3 = floor((t3-t2)*fs);

if 1
    figure;
    plot(ir);
    hold on
    xline(sampleStart);
    xline(sampleStart+n1);
    xline(sampleStart+n1+n2);    
    xline(sampleStart+n1+n2+n3);
end

ir = ir(sampleStart:end);
eDir = 10*log10(sum(ir(1:min(end,n1)).^2));
ir = ir(n1+1:end);
eRef = 10*log10(sum(ir(1:min(end,n2)).^2));
ir = ir(n2+1:end);
eRev = 10*log10(sum(ir(1:min(end,n3)).^2));
end