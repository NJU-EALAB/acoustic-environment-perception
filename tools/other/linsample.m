function y = linsample(x1,x2,n)
x1 = x1(:);
x2 = x2(:);
y = zeros(length(x2),n);

d = 0.5./n*(x2-x1);
for ii = 1:length(x1)
    y(ii,:) = linspace(x1(ii)+d(ii),x2(ii)-d(ii),n);
end

end