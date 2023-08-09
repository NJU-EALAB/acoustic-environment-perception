function Z = zeroOfBesselj1(N)
%����1��besselj�����,N�������������x=0��
s = 1;%ɨ���ࣨ�ɽ�����ʽ�����Լpi��
Z = zeros(1,N);%1��besselj�����
n = 2;
x0 = 0.1;
while n <= N
    if besselj(1,x0)*besselj(1,x0+s) <= 0
        Z(n) = fzero(@(x)besselj(1,x),[x0,x0+s]);
        n = n+1;
    end
    x0 = x0+s;
end    