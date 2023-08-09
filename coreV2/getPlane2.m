function np = getPlane2(x1,x2)
x1 = x1(:);
x2 = x2(:);
a = x2-x1;
k = x1.'*(x1-x2)./(a.'*(x2-x1));
np = x1+k*a;
end
