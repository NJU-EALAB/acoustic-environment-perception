function [xPeak, yPeak, zPeak] = findpeaks2D(x,y,z,numPeak,disPeak)
% x [N]
% y [M]
% z [M,N]
% xPeak,yPeak are peak index, zPeak = z(xPeak,yPeak) are peak
x = x(:);
y = y(:);
[M,N] = size(z);
assert(length(x)==N);
assert(length(y)==M);
xPeak = zeros(M*N,1);
yPeak = zeros(M*N,1);
zPeak = zeros(M*N,1);
flag = 0;
mz = movmax(z,3,1);
for m = 2:M-1
    for n = 2:N-1
        around = [mz(m,[n-1 n+1]).';z([m-1 m+1],n)];
        if z(m,n)>=max(around)
            flag = flag+1;
            xPeak(flag) = x(n);
            yPeak(flag) = y(m);
            zPeak(flag) = z(m,n);
        end
    end
end

[zPeak, id] = sort(zPeak(1:flag),'descend');
xPeak = xPeak(id);
yPeak = yPeak(id);
if nargin >= 5
    idx = 2;
    while idx <= flag
        minDis = min(vecnorm([xPeak(idx) yPeak(idx)]-[xPeak(1:idx-1) yPeak(1:idx-1)],2,2));
        if minDis<=disPeak
            flag = flag-1;
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
end

end
