function p = getPlane3(p0,n)
p0 = p0(:);
n = n(:)./norm(n(:));
% 0 = (k*n-p0)'*n;
k = p0.'*n./(n.'*n);
p = k*n;
end
