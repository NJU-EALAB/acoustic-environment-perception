function Z = zeroOfBesselj1(N)
%计算1阶besselj的零点,N零点数量（包括x=0）
s = 1;%扫描间距（由渐近公式零点间距约pi）
Z = zeros(1,N);%1阶besselj的零点
n = 2;
x0 = 0.1;
while n <= N
    if besselj(1,x0)*besselj(1,x0+s) <= 0
        Z(n) = fzero(@(x)besselj(1,x),[x0,x0+s]);
        n = n+1;
    end
    x0 = x0+s;
end    