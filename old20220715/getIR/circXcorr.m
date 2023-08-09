function y = circXcorr(a, b, L)
if nargin<2
    b = a;
end
La = numel(a);
Lb = numel(b);
if nargin<3
    L = max(La,Lb);
end
a = [a(:);zeros(L-La,1)];
b = [b(:);zeros(L-Lb,1)];
y = zeros(L,1);
for ii = 1:L
    y(ii) = a'*circshift(b,ii-1);
end
% plot(y)
end
