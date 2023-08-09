%%程序利用mls序列测试冲激响应
%mls序列与序列响应进行圆周卷积，结果即为冲激响应、
clc
clear
L=2^8-1;
x= mls(L,'ExcitationLevel',0);
h=[0 0 3.2 1.8 0.98 1];
y0=conv(x,h);
y=y0+2*randn(size(y0));
y1(1:L,1)=y(1:L);
T = [eye(L) eye(L)];
y2 = T(:,1:length(y))*y;
r=circXcorr(y1,x);
r=r/L;
r2=impzest(x,y);
stem(1:6,h)
hold on;
stem(1:10,r(1:10))
stem(1:10,r2(1:10))
hold off;
%%
figure;
fs = 48000;
N = 8;
t = 0:1/fs:(2^N-1)/fs;
t = t(1:2^N-1)';
m = xcorr(mls(2^N-1));
c = xcorr(chirp(t,10,t(end),22000));
plot([m./max(m),c./max(c)])