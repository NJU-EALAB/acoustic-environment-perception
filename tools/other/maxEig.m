function [lambda,vec] = maxEig(A)
vec0 = randn(size(A,2),1);
lambda0 = inf;
while true
vec = A*vec0;
vecMaxAbs = max(abs(vec));
vec = vec./vecMaxAbs;
lambda = (vec'*A*vec)./(vec'*vec);
tol = max(abs( (lambda-lambda0)./lambda0 ));
if tol<1e-6
    break;
end
lambda0 = lambda;
vec0 = vec;
end

end