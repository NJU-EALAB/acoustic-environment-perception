function [xPeak, yPeak, zPeak,xPeakId, yPeakId] = findpeaks2D(x,y,z,numPeak,disPeak,periodFlag)
% x [N]
% y [M]
% z [M,N]
% xPeakId,yPeakId are peak index, zPeak = z(xPeakId,yPeakId) are peak
% xPeak = x(xPeakId)
% periodFlag:0 no period;1 dim1;2 dim2;3 all dim
x = x(:);
y = y(:);
[M,N] = size(z);
assert(length(x)==N);
assert(length(y)==M);
xPeak = zeros(M*N,1);
yPeak = zeros(M*N,1);
zPeak = zeros(M*N,1);
xPeakId = zeros(M*N,1);
yPeakId = zeros(M*N,1);
flag = 0;
%%
if nargin < 6
    periodFlag = 0;
end
if (periodFlag==0)
    mIdx = 2:M-1;
    nIdx = 2:N-1;
end
if (periodFlag==1)
    mIdx = 1:M;
    nIdx = 2:N-1;
end
if (periodFlag==2)
    mIdx = 2:M-1;
    nIdx = 1:N;
end
if (periodFlag==3)
    mIdx = 1:M;
    nIdx = 1:N;
end
%%
for m = mIdx
    for n = nIdx
        around = getPeriodAround(z,m,n);
        if z(m,n)>=max(around)
            flag = flag+1;
            xPeakId(flag) = n;
            yPeakId(flag) = m;
            xPeak(flag) = x(n);
            yPeak(flag) = y(m);
            zPeak(flag) = z(m,n);
        end
    end
end
%%
[zPeak, id] = sort(zPeak(1:flag),'descend');
xPeak = xPeak(id);
yPeak = yPeak(id);
xPeakId = xPeakId(id);
yPeakId = yPeakId(id);
if nargin >= 5
    idx = 2;
    while idx <= flag
        minDis = min(vecnorm([xPeak(idx) yPeak(idx)]-[xPeak(1:idx-1) yPeak(1:idx-1)],2,2));
        if minDis<=disPeak
            flag = flag-1;
            xPeakId(idx) = [];
            yPeakId(idx) = [];
            xPeak(idx) = [];
            yPeak(idx) = [];
            zPeak(idx) = [];
        else
            idx = idx+1;
        end
        if idx > numPeak
            break;
        end
    end
end
if nargin >= 4
    flag = min(flag,numPeak);
    zPeak = zPeak(1:flag);
    xPeak = xPeak(1:flag);
    yPeak = yPeak(1:flag);
    xPeakId = xPeakId(1:flag);
    yPeakId = yPeakId(1:flag);
end

end

%%
%%
function around = getPeriodAround(z,m,n)
[M,N] = size(z,[1 2]);
mIdx = [m-1 m m+1];
if m==1
    mIdx = [M m m+1];
end
if m==M
    mIdx = [m-1 m 1];
end
nIdx = [n-1 n n+1];
if n==1
    nIdx = [N n n+1];
end
if n==N
    nIdx = [n-1 n 1];
end

around = z(mIdx,nIdx);
around = around([1:4 6:9]);
end