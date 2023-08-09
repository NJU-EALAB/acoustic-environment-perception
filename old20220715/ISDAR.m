function [srcPos, errSrcPos] = ISDAR(arrayPos, arrayAxis, aoa, distance)
% INPUT
% arrayPos: microphone array position [3,N]
% arrayAxis: microphone array axis [3,N]
% aoa: angle (deg) of arrival wrt. arrayAxis [M,N]
% distance: distance between source and microphone array [M,N]
% OUTPUT
% srcPos: source position [3,M]
% errSrcPos [1,M]
[M,N] = size(aoa,1,2);
aoa = mod(aoa,360);
aoa(aoa>180) = 360-aoa(aoa>180);
srcPos = zeros(3,M);
errSrcPos = zeros(1,M);
assert(N == 2);% TODO: N>2?
arrayAxis = arrayAxis./vecnorm(arrayAxis,2,1);
r = distance.*sind(aoa);
assert(all(r>=0,'all'));
center = zeros(3,M,N);
for n = 1:N
    center(:,:,n) = arrayPos(:,n)+arrayAxis(:,n)*distance(:,n).';
end

% srcPos0 = zeros(3,M);
% err = @(srcPos)errPos(srcPos, arrayPos, arrayAxis, aoa, distance);
% options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','iter');
% srcPos = lsqnonlin(err,srcPos0,[],[],options);
% errSrcPos = 3*std(err(srcPos));
for ii = 1:M
    err = zeros(1,M);
    srcPos_tmp = zeros(3,M);
    for jj = 1:M
        r1 = r(ii,1);
        c1 = center(:,ii,1);
        n1 = arrayAxis(:,1);
        r2 = r(jj,2);
        c2 = center(:,jj,2);
        n2 = arrayAxis(:,2);
        
        fun = @(th)norm(point2circle(c1+r1*null(n1.')*[cos(th);sin(th)],r2,c2,n2)).^2;
        options = optimoptions('fminunc','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','none');
        [th,err(:,jj)] = fminunc(fun,0,options);
        [~,srcPos_tmp(:,jj)] = point2circle(c1+r1*null(n1.')*[cos(th);sin(th)],r2,c2,n2);
    end
    [errSrcPos(:,ii),jj] = min(err);
    srcPos(:,ii) = srcPos_tmp(:,jj);
end
end
%%
%%
function [y,midPos] = point2circle(x,r,c,n)
a = null([x-c,n].');
a = a(:,1);
b = null([a,n].');
b = b(:,1);
if b'*(x-c)<0
    b = -b;
end
y = x-c-r*b;
midPos = x-0.5*y;
end
% function err = errPos(srcPos, arrayPos, arrayAxis, aoa, distance)
% 
% end
